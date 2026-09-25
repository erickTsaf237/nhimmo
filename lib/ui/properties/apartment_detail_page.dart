import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../charts.dart';
import '../rentals/contract_detail_page.dart';
import '../rentals/contract_form.dart';
import '../theme.dart';
import '../widgets.dart';
import 'property_forms.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

class _MeterStats {
  final MeterView mv;
  final Reading? last;
  final Map<int, double> consumption;
  _MeterStats(this.mv, this.last, this.consumption);
}

class _Data {
  final ApartmentView a;
  final List<ContractView> history;
  final List<_MeterStats> meters;
  final List<int> periods;
  _Data(this.a, this.history, this.meters, this.periods);
}

class ApartmentDetailPage extends StatelessWidget {
  final int id;
  const ApartmentDetailPage(this.id, {super.key});

  Future<_Data> _load() async {
    final db = App.db;
    final a = await Repo.apartment(id);
    final history = await Repo.contracts(apartmentId: id);
    final now = Period.current();
    final periods = Period.range(Period.add(now, -5), now);
    final meters = <_MeterStats>[];
    for (final mv in a.meters) {
      final last = await (db.select(db.readings)
            ..where((r) => r.meterId.equals(mv.meter.id))
            ..orderBy([(r) => OrderingTerm.desc(r.date)])
            ..limit(1))
          .getSingleOrNull();
      final rows = await (db.select(db.invoiceLines).join([
        innerJoin(db.invoices, db.invoices.id.equalsExp(db.invoiceLines.invoiceId)),
      ])
            ..where(db.invoiceLines.meterId.equals(mv.meter.id) & db.invoices.period.isBiggerOrEqualValue(periods.first)))
          .get();
      final cons = <int, double>{};
      for (final r in rows) {
        final p = r.readTable(db.invoices).period;
        cons[p] = (cons[p] ?? 0) + r.readTable(db.invoiceLines).quantity;
      }
      meters.add(_MeterStats(mv, last, cons));
    }
    return _Data(a, history, meters, periods);
  }

  @override
  Widget build(BuildContext context) {
    return DbBuilder<_Data>(
      load: _load,
      builder: (context, d) {
        final a = d.a;
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(a.apt.name),
            actions: [
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => push(context, ApartmentForm(apartment: a.apt))),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'archive') {
                    if (a.occupied) return toast(context, context.t.endContractFirst, error: true);
                    if (await confirm(context, a.apt.archived ? context.t.reactivateQ : context.t.archiveQ,
                        a.apt.archived ? context.t.aptWillReappear : context.t.aptWillDisappear)) {
                      await (App.db.update(App.db.apartments)..where((x) => x.id.equals(a.apt.id)))
                          .write(ApartmentsCompanion(archived: Value(!a.apt.archived)));
                    }
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'archive', child: Text(a.apt.archived ? context.t.reactivate : context.t.archive)),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(24)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.location_city_rounded, color: Colors.white70, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text('${a.building.name} · ${a.owner.name}', style: const TextStyle(color: Colors.white70))),
                  ]),
                  const SizedBox(height: 10),
                  Text(a.apt.name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                  if (a.apt.description != null)
                    Text(a.apt.description!, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  Row(children: [
                    _HeroValue(context.t.rent, Money.format(a.contract?.rent ?? a.apt.rent)),
                    const SizedBox(width: 24),
                    _HeroValue(context.t.deposit, Money.format(a.contract?.deposit ?? a.apt.deposit)),
                  ]),
                ]),
              ),
              SectionHeader(context.t.occupancy),
              if (a.occupied)
                AppCard(
                  onTap: () => push(context, ContractDetailPage(a.contract!.id)),
                  child: Row(children: [
                    Initials(a.tenant!.fullName),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a.tenant!.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(context.t.sinceDate(Dates.d(a.contract!.startDate)), style: TextStyle(color: cs.onSurfaceVariant)),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ]),
                )
              else
                AppCard(
                  child: Row(children: [
                    const IconBadge(Icons.key_rounded, AppColors.warning),
                    const SizedBox(width: 14),
                    Expanded(child: Text(context.t.aptFree, style: const TextStyle(fontWeight: FontWeight.w700))),
                    FilledButton.tonal(
                      onPressed: () => push(context, ContractForm(apartmentId: a.apt.id)),
                      child: Text(context.t.rentOut),
                    ),
                  ]),
                ),
              SectionHeader(context.t.meters,
                  trailing: TextButton.icon(
                    onPressed: () => showMeterSheet(context, a.apt.id),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(context.t.add),
                  )),
              if (d.meters.isEmpty)
                AppCard(child: Text(context.t.noMeters)),
              for (final m in d.meters)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () => showMeterSheet(context, a.apt.id, meter: m.mv.meter),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        IconBadge(utilityIcon(m.mv.type.iconKey), Color(m.mv.type.colorValue), size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(Labels.utilityName(m.mv.type), style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(m.mv.meter.serial == null ? context.t.serialUnknown : context.t.serialNo(m.mv.meter.serial!),
                                style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
                          ]),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text('${Num.format(m.last?.value ?? m.mv.meter.initialIndex)} ${m.mv.type.unit}',
                              style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(m.last == null ? context.t.initialIndex : context.t.readOn(Dates.d(m.last!.date)),
                              style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant)),
                        ]),
                      ]),
                      if (m.consumption.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        GroupedBarChart(
                          height: 130,
                          labels: d.periods.map(Period.short).toList(),
                          series: [
                            ChartSeries(context.t.consumption, Color(m.mv.type.colorValue),
                                d.periods.map((p) => m.consumption[p] ?? 0).toList()),
                          ],
                          format: (v) => '${Num.format(v, maxDecimals: 1)} ${m.mv.type.unit}',
                        ),
                      ],
                    ]),
                  ),
                ),
              if (d.history.isNotEmpty) ...[
                SectionHeader(context.t.leaseHistory),
                for (final c in d.history)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppCard(
                      onTap: () => push(context, ContractDetailPage(c.c.id)),
                      child: Row(children: [
                        Initials(c.tenant.fullName, size: 38, color: c.active ? AppColors.success : cs.outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c.tenant.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('${Dates.d(c.c.startDate)} → ${c.active ? context.t.ongoing : Dates.d(c.c.exitDate)}',
                                style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
                          ]),
                        ),
                        if (c.balance != 0)
                          StatusChip(Money.compact(c.balance), c.balance > 0 ? AppColors.danger : AppColors.success),
                      ]),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _HeroValue extends StatelessWidget {
  final String label;
  final String value;
  const _HeroValue(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
      ]);
}
