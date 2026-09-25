import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/billing_calc.dart';
import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../services/app_state.dart';
import '../../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

class _Catalog {
  final List<UtilityType> utilities;
  final List<ServiceType> services;
  final List<ContractBenefit> benefits;
  _Catalog(this.utilities, this.services, this.benefits);

  String targetName(ContractBenefit b) => b.utilityTypeId != null
      ? utilities.where((u) => u.id == b.utilityTypeId).map(Labels.utilityName).firstOrNull ?? '?'
      : services.where((s) => s.id == b.serviceTypeId).map(Labels.serviceName).firstOrNull ?? '?';

  String unit(ContractBenefit b) =>
      b.utilityTypeId == null ? '' : utilities.where((u) => u.id == b.utilityTypeId).firstOrNull?.unit ?? '';

  IconData icon(ContractBenefit b) => b.utilityTypeId != null
      ? utilityIcon(utilities.where((u) => u.id == b.utilityTypeId).firstOrNull?.iconKey ?? '')
      : Icons.local_parking_rounded;

  Color color(ContractBenefit b) => b.utilityTypeId != null
      ? Color(utilities.where((u) => u.id == b.utilityTypeId).firstOrNull?.colorValue ?? 0xFF0E7C7B)
      : AppColors.accent;
}

enum _State {
  active(AppColors.success),
  upcoming(AppColors.info),
  ended(Colors.grey);

  final Color color;
  const _State(this.color);

  String label(AppLocalizations t) => switch (this) {
        _State.active => t.benefitApplied,
        _State.upcoming => t.benefitUpcoming,
        _State.ended => t.benefitSuspended,
      };
}

_State _stateOf(ContractBenefit b) {
  final now = Period.current();
  if (b.fromPeriod != null && b.fromPeriod! > now) return _State.upcoming;
  if (b.toPeriod != null && b.toPeriod! < now) return _State.ended;
  return _State.active;
}

String _range(AppLocalizations t, ContractBenefit b) {
  final from = b.fromPeriod == null ? t.leaseStart : Period.label(b.fromPeriod!);
  final to = b.toPeriod == null ? t.noLimit : Period.label(b.toPeriod!);
  return '$from → $to';
}

/// Avantages du locataire (exonérations, réductions) : activables et suspendables en cours de bail.
class BenefitsSection extends StatelessWidget {
  final int contractId;
  final bool editable;
  const BenefitsSection({super.key, required this.contractId, required this.editable});

  Future<_Catalog> _load() async {
    final db = App.db;
    return _Catalog(
      await db.select(db.utilityTypes).get(),
      await db.select(db.serviceTypes).get(),
      await (db.select(db.contractBenefits)
            ..where((b) => b.contractId.equals(contractId))
            ..orderBy([(b) => OrderingTerm.desc(b.id)]))
          .get(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DbBuilder<_Catalog>(
      load: _load,
      builder: (context, cat) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SectionHeader(context.t.benefits,
            trailing: editable
                ? TextButton.icon(
                    onPressed: () => showBenefitSheet(context, contractId),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(context.t.add),
                  )
                : null),
        if (cat.benefits.isEmpty)
          AppCard(
            child: Text(context.t.noBenefit,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        for (final b in cat.benefits)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _BenefitTile(b, cat, contractId, editable),
          ),
      ]),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final ContractBenefit b;
  final _Catalog cat;
  final int contractId;
  final bool editable;
  const _BenefitTile(this.b, this.cat, this.contractId, this.editable);

  @override
  Widget build(BuildContext context) {
    final st = _stateOf(b);
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      onTap: editable ? () => showBenefitSheet(context, contractId, benefit: b) : null,
      child: Row(children: [
        IconBadge(cat.icon(b), st == _State.ended ? cs.outline : cat.color(b), size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${cat.targetName(b)} · ${Labels.benefitSummary(context.t, b.mode, b.value, b.amount, cat.unit(b))}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (b.reason != null) Text(b.reason!, style: const TextStyle(fontSize: 12.5)),
            Text(_range(context.t, b), style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            const SizedBox(height: 4),
            StatusChip(st.label(context.t), st.color),
          ]),
        ),
        if (editable)
          PopupMenuButton<String>(
            onSelected: (v) => _action(context, v),
            itemBuilder: (_) => [
              if (st != _State.ended) PopupMenuItem(value: 'stop', child: Text(context.t.suspendFrom)),
              if (st == _State.ended) PopupMenuItem(value: 'resume', child: Text(context.t.resumeFrom)),
              PopupMenuItem(value: 'edit', child: Text(context.t.edit)),
              PopupMenuItem(value: 'delete', child: Text(context.t.delete)),
            ],
          ),
      ]),
    );
  }

  Future<void> _action(BuildContext context, String v) async {
    final db = App.db;
    switch (v) {
      case 'stop':
        final p = await pickMonth(context, Period.current());
        if (p == null) return;
        // Le mois choisi n'est plus couvert : l'avantage s'arrête au mois précédent.
        await (db.update(db.contractBenefits)..where((x) => x.id.equals(b.id)))
            .write(ContractBenefitsCompanion(toPeriod: Value(Period.add(p, -1))));
        if (context.mounted) toast(context, context.t.benefitSuspendedFrom(Period.label(p)));
      case 'resume':
        final p = await pickMonth(context, Period.current());
        if (p == null) return;
        // Nouvelle période : l'historique de l'ancienne reste intact pour les factures passées.
        await db.into(db.contractBenefits).insert(ContractBenefitsCompanion.insert(
              contractId: b.contractId,
              utilityTypeId: Value(b.utilityTypeId),
              serviceTypeId: Value(b.serviceTypeId),
              mode: Value(b.mode),
              value: Value(b.value),
              amount: Value(b.amount),
              reason: Value(b.reason),
              fromPeriod: Value(p),
            ));
        if (context.mounted) toast(context, context.t.benefitResumedFrom(Period.label(p)));
      case 'edit':
        await showBenefitSheet(context, contractId, benefit: b);
      case 'delete':
        if (await confirm(context, context.t.deleteBenefitQ, context.t.deleteBenefitHelp,
            ok: context.t.delete, danger: true)) {
          await (db.delete(db.contractBenefits)..where((x) => x.id.equals(b.id))).go();
        }
    }
  }
}

List<String> _reasons(AppLocalizations t) =>
    [t.reasonEneo, t.reasonCamwater, t.reasonOwner, t.reasonGoodwill, t.reasonCaretaker];

Future<void> showBenefitSheet(BuildContext context, int contractId, {ContractBenefit? benefit}) {
  return showSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _BenefitSheet(contractId, benefit),
  );
}

class _BenefitSheet extends StatefulWidget {
  final int contractId;
  final ContractBenefit? benefit;
  const _BenefitSheet(this.contractId, this.benefit);

  @override
  State<_BenefitSheet> createState() => _BenefitSheetState();
}

class _BenefitSheetState extends State<_BenefitSheet> {
  final _key = GlobalKey<FormState>();
  late final b = widget.benefit;
  late String? _target = b == null ? null : (b!.utilityTypeId != null ? 'u:${b!.utilityTypeId}' : 's:${b!.serviceTypeId}');
  late BenefitMode _mode = BenefitMode.values[b?.mode ?? 0];
  late final _value = TextEditingController(text: b == null ? '100' : Num.format(b!.value));
  late final _amount = TextEditingController(text: b == null || b!.amount == 0 ? '' : Money.toInput(b!.amount));
  late final _reason = TextEditingController(text: b?.reason);
  late int? _from = b == null ? Period.current() : b!.fromPeriod;
  late int? _to = b?.toPeriod;

  @override
  Widget build(BuildContext context) {
    final db = App.db;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: DbBuilder<(List<UtilityType>, List<ServiceType>)>(
        load: () async => (
          await (db.select(db.utilityTypes)..where((t) => t.active.equals(true))).get(),
          await (db.select(db.serviceTypes)..where((t) => t.active.equals(true))).get(),
        ),
        builder: (context, data) {
          final (utilities, services) = data;
          final isUtility = _target?.startsWith('u:') ?? true;
          if (!isUtility && _mode == BenefitMode.freeUnits) _mode = BenefitMode.percent;
          return Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(b == null ? context.t.newBenefit : context.t.editBenefit, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: DropdownButtonFormField<String>(
                    initialValue: _target,
                    decoration: InputDecoration(labelText: context.t.chargeRequired, prefixIcon: const Icon(Icons.category_outlined)),
                    items: [
                      for (final u in utilities)
                        DropdownMenuItem(
                          value: 'u:${u.id}',
                          child: Row(children: [
                            Icon(utilityIcon(u.iconKey), size: 18, color: Color(u.colorValue)),
                            const SizedBox(width: 8),
                            Text(Labels.utilityName(u)),
                          ]),
                        ),
                      for (final s in services)
                        DropdownMenuItem(
                          value: 's:${s.id}',
                          child: Row(children: [
                            const Icon(Icons.local_parking_rounded, size: 18, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text(Labels.serviceName(s)),
                          ]),
                        ),
                    ],
                    onChanged: (v) => setState(() => _target = v),
                    validator: (v) => v == null ? context.t.chooseCharge : null,
                  ),
                ),
                SegmentedButton<BenefitMode>(
                  showSelectedIcon: false,
                  segments: [
                    const ButtonSegment(value: BenefitMode.percent, label: Text('%')),
                    if (isUtility) ButtonSegment(value: BenefitMode.freeUnits, label: Text(context.t.units)),
                    ButtonSegment(value: BenefitMode.fixedAmount, label: Text(context.t.amount)),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (s) => setState(() => _mode = s.first),
                ),
                const SizedBox(height: 6),
                Text(switch (_mode) {
                  BenefitMode.percent => context.t.percentHelp,
                  BenefitMode.freeUnits => context.t.unitsHelp,
                  BenefitMode.fixedAmount => context.t.fixedHelp,
                }, style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 14),
                if (_mode == BenefitMode.fixedAmount)
                  AmountField(_amount, context.t.amountPerMonthOff)
                else
                  Field(_value, _mode == BenefitMode.percent ? context.t.percentage : context.t.freeUnitsPerMonth,
                      suffix: _mode == BenefitMode.percent ? '%' : null,
                      keyboard: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final x = Num.parse(v ?? '');
                        if (x == null || x <= 0) return context.t.valueInvalid;
                        if (_mode == BenefitMode.percent && x > 100) return context.t.max100;
                        return null;
                      }),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final r in _reasons(context.t))
                    ActionChip(label: Text(r), onPressed: () => setState(() => _reason.text = r)),
                ]),
                const SizedBox(height: 10),
                Field(_reason, context.t.reason, icon: Icons.info_outline, hint: context.t.reasonHint),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final p = await pickMonth(context, _from ?? Period.current());
                        if (p != null) setState(() => _from = p);
                      },
                      child: Text(context.t.fromLabel(_from == null ? context.t.leaseStartLower : Period.label(_from!))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final p = await pickMonth(context, _to ?? Period.current());
                        if (p != null) setState(() => _to = p);
                      },
                      onLongPress: () => setState(() => _to = null),
                      child: Text(context.t.toLabel(_to == null ? context.t.noLimit : Period.label(_to!))),
                    ),
                  ),
                ]),
                if (_to != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: () => setState(() => _to = null), child: Text(context.t.noEndDate)),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    if (!_key.currentState!.validate()) return;
                    if (_from != null && _to != null && _to! < _from!) {
                      return toast(context, context.t.endAfterStart, error: true);
                    }
                    final isU = _target!.startsWith('u:');
                    final id = int.parse(_target!.substring(2));
                    final c = ContractBenefitsCompanion(
                      contractId: Value(widget.contractId),
                      utilityTypeId: Value(isU ? id : null),
                      serviceTypeId: Value(isU ? null : id),
                      mode: Value(_mode.index),
                      value: Value(_mode == BenefitMode.fixedAmount ? 0 : Num.parse(_value.text)!),
                      amount: Value(_mode == BenefitMode.fixedAmount ? Money.parse(_amount.text)! : 0),
                      reason: Value(emptyToNull(_reason.text)),
                      fromPeriod: Value(_from),
                      toPeriod: Value(_to),
                    );
                    if (b == null) {
                      await db.into(db.contractBenefits).insert(c);
                    } else {
                      await (db.update(db.contractBenefits)..where((x) => x.id.equals(b!.id))).write(c);
                    }
                    if (context.mounted) {
                      final messenger = ScaffoldMessenger.of(context);
                      final msg = context.t.benefitSaved;
                      Navigator.pop(context);
                      messenger.showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(msg),
                      ));
                    }
                  },
                  child: Text(context.t.save),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
