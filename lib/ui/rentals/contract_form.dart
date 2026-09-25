import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../../services/photo_service.dart';
import '../theme.dart';
import '../widgets.dart';
import 'contract_detail_page.dart';
import 'tenant_form.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

class _ServiceDraft {
  final int serviceTypeId;
  int quantity;
  int included;
  int unitPrice;
  _ServiceDraft(this.serviceTypeId, this.quantity, this.included, this.unitPrice);
}

class _EntryIndex {
  final TextEditingController ctrl = TextEditingController();
  String? photo;
}

class _Data {
  final List<ApartmentView> freeApts;
  final List<Tenant> tenants;
  final List<ServiceType> services;
  _Data(this.freeApts, this.tenants, this.services);
}

/// Création (ou modification) d'un contrat de location.
class ContractForm extends StatefulWidget {
  final int? apartmentId;
  final Contract? contract;
  const ContractForm({super.key, this.apartmentId, this.contract});

  @override
  State<ContractForm> createState() => _ContractFormState();
}

class _ContractFormState extends State<ContractForm> {
  final _key = GlobalKey<FormState>();
  late int? _aptId = widget.contract?.apartmentId ?? widget.apartmentId;
  late int? _tenantId = widget.contract?.tenantId;
  late DateTime _start = widget.contract?.startDate ?? Dates.dayOnly(DateTime.now());
  late DateTime? _plannedEnd = widget.contract?.plannedEndDate;
  late bool _prorata = widget.contract?.entryProrata ?? true;
  late bool _tacit = widget.contract?.tacitRenewal ?? true;
  late final _rent = TextEditingController(text: widget.contract == null ? '' : Money.toInput(widget.contract!.rent));
  late final _deposit = TextEditingController(text: widget.contract == null ? '' : Money.toInput(widget.contract!.deposit));
  late final _depositPaid = TextEditingController(text: widget.contract == null ? '' : Money.toInput(widget.contract!.depositPaid));
  late final _notes = TextEditingController(text: widget.contract?.notes);
  final _services = <_ServiceDraft>[];
  final _entry = <int, _EntryIndex>{};
  bool _servicesLoaded = false;

  bool get _editing => widget.contract != null;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    if (!_editing) {
      _servicesLoaded = true;
      return;
    }
    final rows = await (App.db.select(App.db.contractServices)..where((s) => s.contractId.equals(widget.contract!.id))).get();
    setState(() {
      _services.addAll(rows.map((r) => _ServiceDraft(r.serviceTypeId, r.quantity, r.includedQuantity, r.unitPrice)));
      _servicesLoaded = true;
    });
  }

  Future<_Data> _load() async {
    final db = App.db;
    final apts = await Repo.apartments();
    final free = apts.where((a) => !a.occupied || a.apt.id == _aptId).toList();
    final activeTenantIds = (await Repo.contracts(status: 0)).map((c) => c.tenant.id).toSet();
    final tenants = (await (db.select(db.tenants)..orderBy([(t) => OrderingTerm.asc(t.fullName)])).get())
        .where((t) => !activeTenantIds.contains(t.id) || t.id == _tenantId)
        .toList();
    final services = await (db.select(db.serviceTypes)..where((s) => s.active.equals(true))).get();
    return _Data(free, tenants, services);
  }

  void _selectApartment(ApartmentView a) {
    setState(() {
      _aptId = a.apt.id;
      if (_rent.text.isEmpty && a.apt.rent > 0) _rent.text = Money.toInput(a.apt.rent);
      if (_deposit.text.isEmpty && a.apt.deposit > 0) {
        _deposit.text = Money.toInput(a.apt.deposit);
        _depositPaid.text = Money.toInput(a.apt.deposit);
      }
    });
  }

  Future<void> _save(_Data d) async {
    final db = App.db;
    final rent = Money.parse(_rent.text)!;
    final deposit = Money.parse(_deposit.text) ?? 0;
    final depositPaid = Money.parse(_depositPaid.text) ?? 0;
    int contractId = widget.contract?.id ?? 0;
    await db.transaction(() async {
      final c = ContractsCompanion(
        apartmentId: Value(_aptId!),
        tenantId: Value(_tenantId!),
        startDate: Value(_start),
        plannedEndDate: Value(_plannedEnd),
        rent: Value(rent),
        deposit: Value(deposit),
        depositPaid: Value(depositPaid),
        entryProrata: Value(_prorata),
        tacitRenewal: Value(_tacit),
        notes: Value(emptyToNull(_notes.text)),
      );
      if (_editing) {
        await (db.update(db.contracts)..where((x) => x.id.equals(contractId))).write(c);
        await (db.delete(db.contractServices)..where((s) => s.contractId.equals(contractId))).go();
      } else {
        contractId = await db.into(db.contracts).insert(c);
        for (final e in _entry.entries) {
          final v = Num.parse(e.value.ctrl.text);
          if (v == null) continue;
          await db.into(db.readings).insert(ReadingsCompanion.insert(
                meterId: e.key,
                contractId: Value(contractId),
                kind: const Value(1),
                date: _start,
                value: v,
                photoPath: Value(e.value.photo),
              ));
        }
      }
      for (final s in _services) {
        await db.into(db.contractServices).insert(ContractServicesCompanion.insert(
              contractId: contractId,
              serviceTypeId: s.serviceTypeId,
              quantity: Value(s.quantity),
              includedQuantity: Value(s.included),
              unitPrice: s.unitPrice,
            ));
      }
    });
    if (!mounted) return;
    if (_editing) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ContractDetailPage(contractId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DbBuilder<_Data>(
      load: _load,
      deps: [_aptId, _tenantId],
      builder: (context, d) {
        if (d.freeApts.isEmpty && !_editing) {
          return Scaffold(
            appBar: AppBar(title: Text(context.t.newLease)),
            body: EmptyState(icon: Icons.apartment_rounded, title: context.t.noFreeApartment, message: context.t.noFreeApartmentHelp),
          );
        }
        final apt = d.freeApts.where((a) => a.apt.id == _aptId).firstOrNull;
        return FormPage(
          title: _editing ? context.t.editLease : context.t.newLease,
          formKey: _key,
          saveLabel: _editing ? context.t.save : context.t.createLease,
          onSave: () async {
            if (!_servicesLoaded) return;
            await _save(d);
          },
          children: [
            SectionHeader(context.t.aptAndTenant),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<int>(
                initialValue: _aptId,
                isExpanded: true,
                decoration: InputDecoration(labelText: context.t.apartmentRequired, prefixIcon: const Icon(Icons.door_front_door_outlined)),
                items: [for (final a in d.freeApts) DropdownMenuItem(value: a.apt.id, child: Text(a.fullName, overflow: TextOverflow.ellipsis))],
                onChanged: _editing ? null : (v) => _selectApartment(d.freeApts.firstWhere((a) => a.apt.id == v)),
                validator: (v) => v == null ? context.t.chooseApartment : null,
              ),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: DropdownButtonFormField<int>(
                    key: ValueKey('tenant-$_tenantId-${d.tenants.length}'),
                    initialValue: d.tenants.any((t) => t.id == _tenantId) ? _tenantId : null,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: context.t.tenantRequired, prefixIcon: const Icon(Icons.person_outline)),
                    items: [for (final t in d.tenants) DropdownMenuItem(value: t.id, child: Text(t.fullName, overflow: TextOverflow.ellipsis))],
                    onChanged: _editing ? null : (v) => setState(() => _tenantId = v),
                    validator: (v) => v == null ? context.t.chooseTenant : null,
                  ),
                ),
              ),
              if (!_editing) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: context.t.newTenant,
                  onPressed: () async {
                    final id = await push<int>(context, const TenantForm());
                    if (id != null) setState(() => _tenantId = id);
                  },
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                ),
              ],
            ]),
            SectionHeader(context.t.conditions),
            DateField(label: context.t.entryDate, value: _start, onChanged: (v) => setState(() => _start = v)),
            DateField(
              label: context.t.initialTermEndOptional,
              value: _plannedEnd,
              clearable: true,
              onClear: () => setState(() => _plannedEnd = null),
              onChanged: (v) => setState(() => _plannedEnd = v),
            ),
            if (_plannedEnd != null)
              SwitchRow(
                title: context.t.tacitRenewal,
                subtitle: _tacit
                    ? context.t.tacitOnHelp
                    : context.t.tacitOffHelp,
                value: _tacit,
                onChanged: (v) => setState(() => _tacit = v),
              ),
            AmountField(_rent, context.t.monthlyRent),
            AmountField(_deposit, context.t.depositRequired, required: false),
            AmountField(_depositPaid, context.t.depositPaid, required: false),
            SwitchRow(
              title: context.t.firstMonthProrata,
              subtitle: _prorata
                  ? context.t.firstMonthProrataOn
                  : context.t.firstMonthProrataOff,
              value: _prorata,
              onChanged: (v) => setState(() => _prorata = v),
            ),
            SectionHeader(context.t.services,
                trailing: d.services.isEmpty
                    ? null
                    : TextButton.icon(
                        onPressed: () => _editService(d.services, null),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(context.t.add),
                      )),
            if (_services.isEmpty)
              AppCard(child: Text(context.t.noServices)),
            for (final s in _services)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Builder(builder: (_) {
                  final st = d.services.where((x) => x.id == s.serviceTypeId).firstOrNull;
                  final billable = (s.quantity - s.included).clamp(0, 1 << 30);
                  return AppCard(
                    onTap: () => _editService(d.services, s),
                    child: Row(children: [
                      const IconBadge(Icons.local_parking_rounded, AppColors.info, size: 38),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(st == null ? context.t.service : Labels.serviceName(st), style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(context.t.serviceQtySummary('${s.quantity}', '${s.included}', '$billable'), style: const TextStyle(fontSize: 12.5)),
                        ]),
                      ),
                      Text(context.t.amountPerMonth(Money.compact(billable * s.unitPrice)), style: const TextStyle(fontWeight: FontWeight.w700)),
                      IconButton(onPressed: () => setState(() => _services.remove(s)), icon: const Icon(Icons.close_rounded)),
                    ]),
                  );
                }),
              ),
            if (!_editing && apt != null && apt.meters.isNotEmpty) ...[
              SectionHeader(context.t.entryReadings),
              for (final mv in apt.meters) _entryField(mv),
            ],
            SectionHeader(context.t.notes),
            Field(_notes, context.t.notes, icon: Icons.notes, maxLines: 3),
          ],
        );
      },
    );
  }

  Widget _entryField(MeterView mv) {
    final e = _entry.putIfAbsent(mv.meter.id, () => _EntryIndex());
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Field(e.ctrl, '${Labels.utilityName(mv.type)} (${mv.type.unit})',
              icon: utilityIcon(mv.type.iconKey),
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              hint: context.t.entryReadingHint,
              validator: (v) => v == null || v.trim().isEmpty || Num.parse(v) != null ? null : context.t.indexInvalid),
        ),
        const SizedBox(width: 8),
        e.photo == null
            ? IconButton.filledTonal(
                onPressed: () async {
                  final p = await PhotoService.take();
                  if (p != null) setState(() => e.photo = p);
                },
                icon: const Icon(Icons.photo_camera_rounded),
              )
            : PhotoThumb(e.photo, size: 50),
      ]),
    );
  }

  Future<void> _editService(List<ServiceType> types, _ServiceDraft? existing) async {
    int? typeId = existing?.serviceTypeId ?? (types.length == 1 ? types.first.id : null);
    final qty = TextEditingController(text: '${existing?.quantity ?? 1}');
    final included = TextEditingController(text: '${existing?.included ?? 0}');
    final price = TextEditingController(
        text: existing != null
            ? Money.toInput(existing.unitPrice)
            : typeId == null
                ? ''
                : Money.toInput(types.firstWhere((t) => t.id == typeId).unitPrice));
    final formKey = GlobalKey<FormState>();
    await showSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Form(
            key: formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(ctx.t.service, style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DropdownButtonFormField<int>(
                  initialValue: typeId,
                  decoration: InputDecoration(labelText: ctx.t.serviceRequired),
                  items: [for (final t in types) DropdownMenuItem(value: t.id, child: Text(Labels.serviceName(t)))],
                  onChanged: (v) => set(() {
                    typeId = v;
                    price.text = Money.toInput(types.firstWhere((t) => t.id == v).unitPrice);
                  }),
                  validator: (v) => v == null ? ctx.t.chooseService : null,
                ),
              ),
              Row(children: [
                Expanded(child: Field(qty, ctx.t.totalQuantity, keyboard: TextInputType.number, validator: (v) => int.tryParse(v ?? '') == null ? ctx.t.number : null)),
                const SizedBox(width: 10),
                Expanded(child: Field(included, ctx.t.includedQuantity, keyboard: TextInputType.number, validator: (v) => int.tryParse(v ?? '') == null ? ctx.t.number : null)),
              ]),
              AmountField(price, ctx.t.extraUnitPrice,
                  helper: ctx.t.extraUnitHelp),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  setState(() {
                    if (existing != null) {
                      existing.quantity = int.parse(qty.text);
                      existing.included = int.parse(included.text);
                      existing.unitPrice = Money.parse(price.text)!;
                    } else {
                      _services.add(_ServiceDraft(typeId!, int.parse(qty.text), int.parse(included.text), Money.parse(price.text)!));
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: Text(ctx.t.validate),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
