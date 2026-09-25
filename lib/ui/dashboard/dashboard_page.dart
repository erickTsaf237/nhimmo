import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../charts.dart';
import '../finance/payment_form.dart';
import '../rentals/contract_detail_page.dart';
import '../scanner/scanner_page.dart';
import '../settings/export_page.dart';
import '../settings/settings_page.dart';
import '../shell.dart';
import '../theme.dart';
import '../widgets.dart';

class _Dash {
  int apartments = 0;
  int occupied = 0;
  int billedMonth = 0;
  int billPeriod = 0;
  int collectedMonth = 0;
  int outstanding = 0;
  int overdue = 0;
  int meters = 0;
  int readings = 0;
  final periods = <int>[];
  final billed = <double>[];
  final collected = <double>[];
  final consumption = <(UtilityType, double)>[];
  final debtors = <ContractView>[];
  final incompleteDeposits = <ContractView>[];
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<_Dash> _load() async {
    final db = App.db;
    final d = _Dash();
    final now = Period.current();
    final apts = await Repo.apartments();
    d.apartments = apts.length;
    d.occupied = apts.where((a) => a.occupied).length;
    d.meters = apts.fold(0, (s, a) => s + a.meters.length);
    d.readings = (await (db.select(db.readings)..where((r) => r.period.equals(now) & r.kind.equals(0))).get()).length;

    final contracts = await Repo.contracts();
    d.outstanding = contracts.fold(0, (s, c) => s + (c.balance > 0 ? c.balance : 0));
    d.debtors.addAll(contracts.where((c) => c.balance > 0).toList()..sort((a, b) => b.balance.compareTo(a.balance)));
    d.incompleteDeposits.addAll(contracts.where((c) => c.active && c.c.depositPaid < c.c.deposit));

    final unpaid = await Repo.invoices(from: Period.add(now, -24), to: now);
    d.overdue = unpaid.where((v) => v.overdue).length;

    d.periods.addAll(Period.range(Period.add(now, -5), now));
    final invs = await (db.select(db.invoices)..where((i) => i.period.isBiggerOrEqualValue(d.periods.first))).get();
    final pays = await (db.select(db.payments)
          ..where((p) => p.kind.equals(0) & p.date.isBiggerOrEqualValue(Period.firstDay(d.periods.first))))
        .get();
    for (final p in d.periods) {
      d.billed.add(invs.where((i) => i.period == p).fold<int>(0, (s, i) => s + i.total) / 100);
      d.collected.add(pays.where((x) => Period.of(x.date) == p).fold<int>(0, (s, x) => s + x.amount) / 100);
    }
    // Dernière période facturée (les factures de M sont réglées en M+1).
    final billedPeriods = invs.where((i) => i.kind == 0 && i.period <= now).map((i) => i.period);
    d.billPeriod = billedPeriods.isEmpty ? Period.add(now, -1) : billedPeriods.reduce((a, b) => a > b ? a : b);
    d.billedMonth = invs.where((i) => i.period == d.billPeriod).fold<int>(0, (s, i) => s + i.total);
    d.collectedMonth = (d.collected.last * 100).round();

    final types = await (db.select(db.utilityTypes)..where((t) => t.active.equals(true))).get();
    final lines = await (db.select(db.invoiceLines).join([
      innerJoin(db.invoices, db.invoices.id.equalsExp(db.invoiceLines.invoiceId)),
    ])
          ..where(db.invoices.period.equals(d.billPeriod) & db.invoiceLines.kind.equals(1)))
        .get();
    for (final t in types) {
      final q = lines
          .map((r) => r.readTable(db.invoiceLines))
          .where((l) => l.utilityTypeId == t.id)
          .fold<double>(0, (s, l) => s + l.quantity);
      d.consumption.add((t, q));
    }
    return d;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: App.settings,
          builder: (_, __) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(context.t.hello, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant, fontWeight: FontWeight.w500)),
            Text(App.settings.businessName, overflow: TextOverflow.ellipsis),
          ]),
        ),
        toolbarHeight: 70,
        actions: [
          IconButton(tooltip: context.t.scanDocument, icon: const Icon(Icons.qr_code_scanner_rounded), onPressed: () => push(context, const ScannerPage())),
          IconButton(tooltip: context.t.settings, icon: const Icon(Icons.settings_outlined), onPressed: () => push(context, const SettingsPage())),
        ],
      ),
      body: DbBuilder<_Dash>(
        load: _load,
        builder: (context, d) {
          final rate = d.apartments == 0 ? 0 : (d.occupied * 100 / d.apartments).round();
          final shell = HomeShell.of(context);
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .25), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(Period.label(Period.current()), style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text(context.t.collectedThisMonth, style: TextStyle(color: Colors.white, fontSize: 13)),
                    Text(Money.format(d.collectedMonth),
                        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -.5)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: d.billedMonth == 0 ? 0 : (d.collectedMonth / d.billedMonth).clamp(0, 1).toDouble(),
                        minHeight: 7,
                        backgroundColor: Colors.white24,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(context.t.forBilledIn(Money.format(d.billedMonth), Period.inline(d.billPeriod)), style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                  ]),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  _Quick(Icons.speed_rounded, context.t.actionRead, AppColors.info, () => shell?.goTo(3)),
                  _Quick(Icons.add_card_rounded, context.t.actionCollect, AppColors.success, () => push(context, const PaymentForm())),
                  _Quick(Icons.qr_code_scanner_rounded, context.t.actionScan, AppColors.accent, () => push(context, const ScannerPage())),
                  _Quick(Icons.ios_share_rounded, context.t.actionExport, AppColors.primary, () => push(context, const ExportPage())),
                ]),
                const SizedBox(height: 14),
                StatGrid(
                  children: [
                    StatCard(
                      label: context.t.occupancy,
                      value: '$rate %',
                      caption: context.t.apartmentsCount('${d.occupied}', '${d.apartments}'),
                      icon: Icons.apartment_rounded,
                      color: AppColors.primary,
                      onTap: () => shell?.goTo(1),
                    ),
                    StatCard(
                      label: context.t.unpaid,
                      value: Money.compact(d.outstanding),
                      caption: d.overdue > 0 ? context.t.lateInvoices('${d.overdue}') : context.t.noDelay,
                      icon: Icons.warning_amber_rounded,
                      color: d.outstanding > 0 ? AppColors.danger : AppColors.success,
                      onTap: () => shell?.goTo(4),
                    ),
                    StatCard(
                      label: context.t.readingsOfMonth,
                      value: '${d.readings} / ${d.meters}',
                      caption: d.meters > 0 && d.readings >= d.meters ? context.t.done : context.t.toComplete,
                      icon: Icons.speed_rounded,
                      color: AppColors.info,
                      onTap: () => shell?.goTo(3),
                    ),
                    StatCard(
                      label: context.t.lastBilling,
                      value: Money.compact(d.billedMonth),
                      caption: Period.label(d.billPeriod),
                      icon: Icons.receipt_long_rounded,
                      color: AppColors.accent,
                      onTap: () => shell?.goTo(4),
                    ),
                  ],
                ),
                SectionHeader(context.t.billedVsCollected),
                AppCard(
                  child: GroupedBarChart(
                    labels: d.periods.map(Period.short).toList(),
                    series: [
                      ChartSeries(context.t.billed, AppColors.primary, d.billed),
                      ChartSeries(context.t.collected, AppColors.accent, d.collected),
                    ],
                    format: (v) => Money.compact((v * 100).round()),
                  ),
                ),
                if (d.consumption.isNotEmpty) ...[
                  SectionHeader(context.t.consumptionOf(Period.label(d.billPeriod))),
                  Row(children: [
                    for (final (t, q) in d.consumption)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AppCard(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Icon(utilityIcon(t.iconKey), color: Color(t.colorValue)),
                              const SizedBox(height: 8),
                              FittedBox(child: Text('${Num.format(q, maxDecimals: 1)} ${t.unit}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
                              Text(Labels.utilityName(t), style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                            ]),
                          ),
                        ),
                      ),
                  ]),
                ],
                if (d.debtors.isNotEmpty) ...[
                  SectionHeader(context.t.balancesToRecover),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(children: [
                      for (final c in d.debtors.take(5))
                        ListTile(
                          onTap: () => push(context, ContractDetailPage(c.c.id)),
                          leading: Initials(c.tenant.fullName, size: 38, color: AppColors.danger),
                          title: Text(c.tenant.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(c.place),
                          trailing: Text(Money.format(c.balance), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.danger)),
                        ),
                    ]),
                  ),
                ],
                if (d.incompleteDeposits.isNotEmpty) ...[
                  SectionHeader(context.t.incompleteDeposits),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(children: [
                      for (final c in d.incompleteDeposits)
                        ListTile(
                          onTap: () => push(context, ContractDetailPage(c.c.id)),
                          leading: Initials(c.tenant.fullName, size: 38, color: AppColors.warning),
                          title: Text(c.tenant.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(context.t.depositIncompleteDetail(Money.format(c.c.depositPaid), Money.format(c.c.deposit))),
                          trailing: Text(Money.format(c.c.deposit - c.c.depositPaid),
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.warning)),
                        ),
                    ]),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Quick(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(18)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      );
}
