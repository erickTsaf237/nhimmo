import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../services/app_state.dart';
import '../../data/repo.dart';
import '../../services/billing_service.dart';
import '../../services/pdf_service.dart';
import '../rentals/contract_detail_page.dart';
import '../theme.dart';
import '../widgets.dart';
import 'finance_widgets.dart';
import 'payment_form.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

class InvoiceDetailPage extends StatelessWidget {
  final int id;
  const InvoiceDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return DbBuilder<(InvoiceView, List<InvoiceLine>, LineText)?>(
      load: () async {
        try {
          final v = await Repo.invoice(id);
          return (v, await Repo.lines(id), LineText(await NameBook.load(App.db), I18n.lang));
        } on StateError {
          return null; // facture supprimée
        }
      },
      builder: (context, data) {
        if (data == null) return Scaffold(body: EmptyState(icon: Icons.receipt_long, title: context.t.invoiceNotFound));
        final (v, lines, text) = data;
        final cs = Theme.of(context).colorScheme;
        final color = payStatusColor(v.status);
        final vat = lines.fold<int>(0, (s, l) => s + l.vat);
        return Scaffold(
          appBar: AppBar(
            title: Text(v.inv.number),
            actions: [
              if (!v.locked)
                IconButton(
                  tooltip: context.t.recalculate,
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () async {
                    final r = await BillingService.generateMonth(v.inv.period);
                    if (context.mounted) {
                      toast(context, r.warnings.isEmpty ? context.t.invoiceRecalculated : context.t.recalculatedWarnings('${r.warnings.length}'));
                    }
                  },
                ),
              if (!v.locked && v.inv.kind == 0)
                IconButton(
                  tooltip: context.t.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () async {
                    if (await confirm(context, context.t.deleteInvoiceQ, v.inv.number, danger: true, ok: context.t.delete)) {
                      await BillingService.deleteInvoice(v.inv.id);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
            children: [
              AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    StatusChip(payStatusLabel(context, v.status), color),
                    const SizedBox(width: 6),
                    if (v.overdue) StatusChip(context.t.overdue, AppColors.danger),
                    const Spacer(),
                    StatusChip(v.locked ? context.t.locked : context.t.editable, v.locked ? cs.outline : AppColors.info,
                        icon: v.locked ? Icons.lock_rounded : Icons.lock_open_rounded),
                  ]),
                  const SizedBox(height: 14),
                  Text(Money.format(v.inv.total), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                  if (v.status == PayStatus.partial)
                    Text(context.t.remainingToPayAmount(Money.format(v.remaining)), style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  InfoRow(context.t.period, Period.label(v.inv.period)),
                  InfoRow(context.t.type, v.inv.kind == 1 ? context.t.exitInvoice : context.t.monthly),
                  InfoRow(context.t.issuedOn, Dates.d(v.inv.issueDate)),
                  InfoRow(context.t.dueDate, Dates.d(v.inv.dueDate)),
                ]),
              ),
              const SizedBox(height: 10),
              AppCard(
                onTap: () => push(context, ContractDetailPage(v.cv.c.id)),
                child: Row(children: [
                  Initials(v.cv.tenant.fullName, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(v.cv.tenant.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(v.cv.place, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12.5)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ]),
              ),
              SectionHeader(context.t.detail),
              AppCard(
                child: Column(children: [
                  for (final l in lines)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(text.label(l), style: const TextStyle(fontWeight: FontWeight.w600)),
                            if (text.details(l) != null)
                              Text(text.details(l)!, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                          ]),
                        ),
                        const SizedBox(width: 12),
                        Text(Money.format(l.ttc), style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  const Divider(height: 20),
                  if (vat != 0) InfoRow(context.t.ofWhichVat, Money.format(vat)),
                  InfoRow(context.t.total, Money.format(v.inv.total), strong: true),
                ]),
              ),
              if (v.alloc.showSettlement) ...[
                SectionHeader(context.t.creditSettlement),
                AppCard(
                  color: AppColors.info.withValues(alpha: .07),
                  child: Column(children: [
                    InfoRow(context.t.creditAvailable, Money.format(v.alloc.creditBefore)),
                    InfoRow(context.t.creditApplied, '− ${Money.format(v.alloc.applied)}', color: AppColors.success),
                    const Divider(height: 20),
                    InfoRow(context.t.remainingToPay, Money.format(v.remaining), strong: true,
                        color: v.remaining > 0 ? AppColors.danger : AppColors.success),
                    if (v.alloc.creditAfter > 0) InfoRow(context.t.creditRemaining, Money.format(v.alloc.creditAfter)),
                  ]),
                ),
              ],
              if (v.locked)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    v.inv.kind == 1
                        ? context.t.exitInvoiceFinal
                        : context.t.laterMonthBilled,
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12.5),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => openPdf(context, v.inv.number, '${v.inv.number}.pdf', () => PdfService.invoice(v.inv.id)),
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: Text(context.t.pdf),
                  ),
                ),
                if (v.status != PayStatus.paid) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => push(context, PaymentForm(contractId: v.cv.c.id)),
                      icon: const Icon(Icons.add_card_rounded),
                      label: Text(context.t.actionCollect),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        );
      },
    );
  }
}
