import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/billing_calc.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../services/app_state.dart';
import '../theme.dart';
import '../widgets.dart';

AppDatabase get _db => App.db;

Map<String, dynamic> _decode(String? s) {
  if (s == null || s.isEmpty) return {};
  try {
    return jsonDecode(s) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

// ------------------------------------------------------------ types de compteurs

class UtilityTypesPage extends StatelessWidget {
  const UtilityTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.meterTypes)),
      body: DbBuilder<List<UtilityType>>(
        load: () => _db.select(_db.utilityTypes).get(),
        builder: (context, list) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(t.meterTypesHelp, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
            for (final u in list)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => push(context, UtilityTypeForm(type: u)),
                  child: Row(children: [
                    IconBadge(utilityIcon(u.iconKey), Color(u.colorValue)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(Labels.utilityName(u), style: const TextStyle(fontWeight: FontWeight.w700)),
                          if (!u.active) ...[const SizedBox(width: 6), StatusChip(t.inactive, Colors.grey)],
                        ]),
                        Text(
                          '${t.pricePerUnit(Money.format(u.unitPrice), u.unit)}'
                          '${u.fixedFee > 0 ? ' · ${t.maintenanceShort(Money.format(u.fixedFee))}' : ''}',
                          style: const TextStyle(fontSize: 12.5),
                        ),
                        Text(
                          VatMode.values[u.vatMode] == VatMode.none
                              ? t.vatNone
                              : t.withRate(Labels.vatMode(t, VatMode.values[u.vatMode]), Num.format(u.vatRate)),
                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ]),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => push(context, const UtilityTypeForm()),
        icon: const Icon(Icons.add_rounded),
        label: Text(t.newType),
      ),
    );
  }
}

const _palette = [0xFF1E88E5, 0xFFF9A825, 0xFFE64A19, 0xFF43A047, 0xFF8E24AA, 0xFF0E7C7B, 0xFF6D4C41];

class UtilityTypeForm extends StatefulWidget {
  final UtilityType? type;
  const UtilityTypeForm({super.key, this.type});

  @override
  State<UtilityTypeForm> createState() => _UtilityTypeFormState();
}

class _UtilityTypeFormState extends State<UtilityTypeForm> {
  final _key = GlobalKey<FormState>();
  late final u = widget.type;
  late final _name = TextEditingController(text: u?.name);
  late final _unit = TextEditingController(text: u?.unit);
  late final _price = TextEditingController(text: u == null ? '' : Money.toInput(u!.unitPrice));
  late final _fee = TextEditingController(text: u == null || u!.fixedFee == 0 ? '' : Money.toInput(u!.fixedFee));
  late final _vat = TextEditingController(text: u == null || u!.vatRate == 0 ? '' : Num.format(u!.vatRate));
  late final _translations = {
    for (final code in I18n.codes)
      code: TextEditingController(text: (_decode(u?.translations)[code] as String?) ?? ''),
  };
  late VatMode _mode = VatMode.values[u?.vatMode ?? 0];
  late bool _vatOnFee = u?.vatOnFixedFee ?? false;
  late String _icon = u?.iconKey ?? 'other';
  late int _color = u?.colorValue ?? _palette.first;
  late bool _active = u?.active ?? true;
  final _simCons = TextEditingController(text: '10');

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final tariff = Tariff(
      unitPrice: Money.parse(_price.text) ?? 0,
      fixedFee: Money.parse(_fee.text) ?? 0,
      vatRate: Num.parse(_vat.text) ?? 0,
      vatMode: _mode,
      vatOnFixedFee: _vatOnFee,
    );
    final sim = BillingCalc.utility(Num.parse(_simCons.text) ?? 0, tariff);
    return FormPage(
      title: u == null ? t.newMeterType : Labels.utilityName(u!),
      formKey: _key,
      onSave: () async {
        final tr = {
          for (final e in _translations.entries)
            if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim(),
        };
        final c = UtilityTypesCompanion(
          name: Value(_name.text.trim()),
          unit: Value(_unit.text.trim()),
          unitPrice: Value(tariff.unitPrice),
          fixedFee: Value(tariff.fixedFee),
          vatRate: Value(tariff.vatRate),
          vatMode: Value(_mode.index),
          vatOnFixedFee: Value(_vatOnFee),
          iconKey: Value(_icon),
          colorValue: Value(_color),
          active: Value(_active),
          translations: Value(tr.isEmpty ? null : jsonEncode(tr)),
        );
        if (u == null) {
          await _db.into(_db.utilityTypes).insert(c);
        } else {
          await (_db.update(_db.utilityTypes)..where((x) => x.id.equals(u!.id))).write(c);
        }
        if (context.mounted) Navigator.pop(context);
      },
      children: [
        Field(_name, t.name, icon: Icons.label_outline, required: true, hint: t.gasHint),
        Field(_unit, t.unitOfMeasure, icon: Icons.straighten_rounded, required: true, hint: t.unitHint),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final e in utilityIcons.entries)
            ChoiceChip(label: Icon(e.value, size: 20), selected: _icon == e.key, onSelected: (_) => setState(() => _icon = e.key)),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 10, children: [
          for (final c in _palette)
            GestureDetector(
              onTap: () => setState(() => _color = c),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Color(c),
                child: _color == c ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
              ),
            ),
        ]),
        SectionHeader(t.translations),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(t.translationsHelp, style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
        for (final code in I18n.codes)
          Field(_translations[code]!, t.nameIn(I18n.nativeName(code)), icon: Icons.translate_rounded),
        SectionHeader(t.tariff),
        AmountField(_price, t.unitPrice, onChanged: (_) => setState(() {})),
        AmountField(_fee, t.meterFee, required: false, onChanged: (_) => setState(() {})),
        SectionHeader(t.vat),
        SegmentedButton<VatMode>(
          segments: [
            ButtonSegment(value: VatMode.none, label: Text(t.vatNoneShort)),
            ButtonSegment(value: VatMode.included, label: Text(t.vatIncludedCap)),
            ButtonSegment(value: VatMode.added, label: Text(t.vatAddedCap)),
          ],
          selected: {_mode},
          onSelectionChanged: (s) => setState(() => _mode = s.first),
        ),
        const SizedBox(height: 14),
        if (_mode != VatMode.none) ...[
          Field(_vat, t.vatRate, suffix: '%', icon: Icons.percent_rounded,
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Num.parse(v ?? '') == null ? t.rateRequired : null,
              onChanged: (_) => setState(() {})),
          SwitchRow(title: t.vatOnFee, value: _vatOnFee, onChanged: (v) => setState(() => _vatOnFee = v)),
        ],
        SectionHeader(t.simulation),
        AppCard(
          color: AppColors.primary.withValues(alpha: .06),
          child: Column(children: [
            Row(children: [
              Expanded(child: Text(t.consumption)),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: _simCons,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(isDense: true, suffixText: _unit.text),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            InfoRow(t.excludingTax, Money.format(sim.ht)),
            InfoRow(t.vat, Money.format(sim.vat)),
            InfoRow(t.totalCharged, Money.format(sim.ttc), strong: true),
          ]),
        ),
        const SizedBox(height: 14),
        SwitchRow(title: t.active, subtitle: t.inactiveTypeHelp, value: _active, onChanged: (v) => setState(() => _active = v)),
      ],
    );
  }
}

// ------------------------------------------------------------ services

class ServiceTypesPage extends StatelessWidget {
  const ServiceTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.services)),
      body: DbBuilder<List<ServiceType>>(
        load: () => _db.select(_db.serviceTypes).get(),
        builder: (context, list) => list.isEmpty
            ? EmptyState(icon: Icons.local_parking_rounded, title: t.noService)
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                children: [
                  for (final s in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        onTap: () => _edit(context, s),
                        child: Row(children: [
                          const IconBadge(Icons.local_parking_rounded, AppColors.accent),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(Labels.serviceName(s), style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text(t.servicePriceLine(Money.format(s.unitPrice), Labels.serviceUnit(s)),
                                  style: const TextStyle(fontSize: 12.5)),
                            ]),
                          ),
                          if (!s.active) StatusChip(t.inactive, Colors.grey),
                        ]),
                      ),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, null),
        icon: const Icon(Icons.add_rounded),
        label: Text(t.newService),
      ),
    );
  }

  Future<void> _edit(BuildContext context, ServiceType? s) async {
    final t = context.t;
    final name = TextEditingController(text: s?.name);
    final unit = TextEditingController(text: s?.unitLabel ?? t.defaultUnit);
    final price = TextEditingController(text: s == null ? '' : Money.toInput(s.unitPrice));
    final tr = _decode(s?.translations);
    final trName = {for (final c in I18n.codes) c: TextEditingController(text: (tr[c] as Map?)?['name'] as String? ?? '')};
    final trUnit = {for (final c in I18n.codes) c: TextEditingController(text: (tr[c] as Map?)?['unit'] as String? ?? '')};
    var active = s?.active ?? true;
    final key = GlobalKey<FormState>();
    await showSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(s == null ? t.newService : t.edit, style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 16),
                Field(name, t.name, required: true, hint: t.parkingHint),
                Field(unit, t.unit, required: true, hint: t.serviceUnitHint),
                AmountField(price, t.monthlyPricePerUnit),
                Text(t.translations, style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                for (final c in I18n.codes)
                  Row(children: [
                    Expanded(child: Field(trName[c]!, t.nameIn(I18n.nativeName(c)))),
                    const SizedBox(width: 8),
                    Expanded(child: Field(trUnit[c]!, t.unitIn(I18n.nativeName(c)))),
                  ]),
                SwitchListTile(title: Text(t.active), value: active, onChanged: (v) => set(() => active = v)),
                FilledButton(
                  onPressed: () async {
                    if (!key.currentState!.validate()) return;
                    final json = <String, Object>{
                      for (final c in I18n.codes)
                        if (trName[c]!.text.trim().isNotEmpty || trUnit[c]!.text.trim().isNotEmpty)
                          c: {
                            if (trName[c]!.text.trim().isNotEmpty) 'name': trName[c]!.text.trim(),
                            if (trUnit[c]!.text.trim().isNotEmpty) 'unit': trUnit[c]!.text.trim(),
                          },
                    };
                    final c = ServiceTypesCompanion(
                      name: Value(name.text.trim()),
                      unitLabel: Value(unit.text.trim()),
                      unitPrice: Value(Money.parse(price.text)!),
                      active: Value(active),
                      translations: Value(json.isEmpty ? null : jsonEncode(json)),
                    );
                    if (s == null) {
                      await _db.into(_db.serviceTypes).insert(c);
                    } else {
                      await (_db.update(_db.serviceTypes)..where((x) => x.id.equals(s.id))).write(c);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: Text(t.save),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
