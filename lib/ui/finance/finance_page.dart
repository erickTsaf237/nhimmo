import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/repo.dart';
import '../../services/pdf_service.dart';
import '../theme.dart';
import '../widgets.dart';
import 'finance_widgets.dart';
import 'payment_form.dart';
import '../../core/i18n.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  int _period = Period.current();
  /// 0 = toutes, 1 = impayées, 2 = payées.
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.t.navFinance),
          bottom: TabBar(tabs: [Tab(text: context.t.invoices), Tab(text: context.t.payments)]),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: MonthSwitcher(period: _period, onChanged: (p) => setState(() => _period = p)),
          ),
          Expanded(child: TabBarView(children: [_invoices(), _payments()])),
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => push(context, const PaymentForm()),
          icon: const Icon(Icons.add_card_rounded),
          label: Text(context.t.actionCollect),
        ),
      ),
    );
  }

  Widget _invoices() {
    return DbBuilder<List<InvoiceView>>(
      load: () => Repo.invoices(period: _period),
      deps: [_period],
      builder: (context, all) {
        if (all.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_rounded,
            title: context.t.noInvoiceThisMonth,
            message: context.t.noInvoiceThisMonthHelp,
          );
        }
        final list = switch (_filter) {
          1 => all.where((v) => v.status != PayStatus.paid).toList(),
          2 => all.where((v) => v.status == PayStatus.paid).toList(),
          _ => all,
        };
        final total = all.fold<int>(0, (s, v) => s + v.inv.total);
        final remaining = all.fold<int>(0, (s, v) => s + v.remaining);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            AppCard(
              child: Row(children: [
                Expanded(child: _Metric(context.t.billed, Money.compact(total), AppColors.primary)),
                Expanded(child: _Metric(context.t.collected, Money.compact(total - remaining), AppColors.success)),
                Expanded(child: _Metric(context.t.remaining, Money.compact(remaining), AppColors.danger)),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              for (final (i, f) in [context.t.filterAll, context.t.filterUnpaid, context.t.filterPaid].indexed)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(label: Text(f), selected: _filter == i, onSelected: (_) => setState(() => _filter = i)),
                ),
              const Spacer(),
              IconButton.filledTonal(
                tooltip: context.t.downloadAllInvoices,
                onPressed: () => openPdf(context, context.t.invoicesOfMonth(Period.label(_period)), 'factures-$_period.pdf',
                    () => PdfService.invoices(list)),
                icon: const Icon(Icons.download_rounded),
              ),
            ]),
            const SizedBox(height: 8),
            for (final v in list) Padding(padding: const EdgeInsets.only(bottom: 8), child: InvoiceTile(v)),
          ],
        );
      },
    );
  }

  Widget _payments() {
    return DbBuilder<List<PaymentView>>(
      load: () => Repo.payments(from: Period.firstDay(_period), to: Period.lastDay(_period).add(const Duration(days: 1))),
      deps: [_period],
      builder: (context, list) {
        if (list.isEmpty) {
          return EmptyState(icon: Icons.savings_rounded, title: context.t.noPaymentThisMonth);
        }
        final total = list.where((p) => p.pay.kind == 0).fold<int>(0, (s, p) => s + p.pay.amount);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            AppCard(child: InfoRow(context.t.totalCollected, Money.format(total), strong: true, color: AppColors.success)),
            const SizedBox(height: 12),
            for (final p in list) Padding(padding: const EdgeInsets.only(bottom: 8), child: PaymentTile(p)),
          ],
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Metric(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
        FittedBox(child: Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color))),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]);
}
