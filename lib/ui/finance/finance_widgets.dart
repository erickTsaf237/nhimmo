import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/repo.dart';
import '../../services/pdf_service.dart';
import '../theme.dart';
import '../widgets.dart';
import '../../services/payment_service.dart';
import 'invoice_detail_page.dart';
import 'payment_form.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

/// Titre du reçu selon le type de versement.
String receiptTitle(BuildContext context, int kind) => switch (kind) {
      PaymentKind.refund => context.t.refundReceipt,
      PaymentKind.depositReceived => context.t.depositReceipt,
      _ => context.t.docReceipt,
    };

String payStatusLabel(BuildContext context, PayStatus s) => switch (s) {
      PayStatus.paid => context.t.payStatusPaid,
      PayStatus.partial => context.t.payStatusPartial,
      PayStatus.unpaid => context.t.payStatusUnpaid,
    };

Color payStatusColor(PayStatus s) => switch (s) {
      PayStatus.paid => AppColors.success,
      PayStatus.partial => AppColors.warning,
      PayStatus.unpaid => AppColors.danger,
    };

class InvoiceTile extends StatelessWidget {
  final InvoiceView v;
  final bool showTenant;
  const InvoiceTile(this.v, {super.key, this.showTenant = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = payStatusColor(v.status);
    return AppCard(
      onTap: () => push(context, InvoiceDetailPage(v.inv.id)),
      child: Row(children: [
        IconBadge(v.inv.kind == 1 ? Icons.logout_rounded : Icons.receipt_long_rounded, color, size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(showTenant ? v.cv.tenant.fullName : Period.label(v.inv.period),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(showTenant ? '${v.cv.place} · ${v.inv.number}' : v.inv.number,
                style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              StatusChip(payStatusLabel(context, v.status), color),
              if (v.overdue) ...[const SizedBox(width: 6), StatusChip(context.t.overdue, AppColors.danger, icon: Icons.schedule_rounded)],
              if (v.locked) ...[const SizedBox(width: 6), Icon(Icons.lock_rounded, size: 14, color: cs.outline)],
            ]),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(Money.format(v.inv.total), style: const TextStyle(fontWeight: FontWeight.w800)),
          if (v.status == PayStatus.partial)
            Text(context.t.remainingAmount(Money.format(v.remaining)), style: const TextStyle(fontSize: 11.5, color: AppColors.warning)),
        ]),
      ]),
    );
  }
}

class PaymentTile extends StatelessWidget {
  final PaymentView p;
  final bool showTenant;
  const PaymentTile(this.p, {super.key, this.showTenant = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pay = p.pay;
    final (icon, color, label) = switch (pay.kind) {
      PaymentKind.depositApplied => (Icons.shield_rounded, AppColors.info, context.t.depositApplied),
      PaymentKind.refund => (Icons.undo_rounded, AppColors.warning, context.t.refundKind),
      PaymentKind.depositReceived => (Icons.savings_rounded, AppColors.info, context.t.depositReceived),
      _ => (Icons.south_west_rounded, AppColors.success, Labels.method(context.t, pay.method)),
    };
    final outgoing = pay.kind == PaymentKind.refund;
    return AppCard(
      onTap: () => showPaymentActions(context, p),
      child: Row(children: [
        IconBadge(icon, color, size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(showTenant ? p.cv.tenant.fullName : label, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${Dates.d(pay.date)} · ${pay.receiptNumber}${showTenant ? ' · $label' : ''}',
                style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant), overflow: TextOverflow.ellipsis),
          ]),
        ),
        Text('${outgoing ? '−' : '+'} ${Money.format(pay.amount)}',
            style: TextStyle(fontWeight: FontWeight.w800, color: outgoing ? AppColors.warning : AppColors.success)),
      ]),
    );
  }
}

/// Actions sur un versement : reçu, modification et suppression (seulement le plus récent du contrat).
Future<void> showPaymentActions(BuildContext context, PaymentView pv) async {
  final pay = pv.pay;
  final editable = await PaymentService.canEdit(pay);
  if (!context.mounted) return;
  await showSheet(
    context: context,
    builder: (ctx) {
      final t = ctx.t;
      return SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            title: Text('${pay.receiptNumber} · ${Money.format(pay.amount)}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${pv.cv.tenant.fullName} · ${Dates.d(pay.date)}'),
          ),
          if (pay.kind != PaymentKind.depositApplied)
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded),
              title: Text(receiptTitle(ctx, pay.kind)),
              onTap: () {
                Navigator.pop(ctx);
                openPdf(context, receiptTitle(context, pay.kind), '${pay.receiptNumber}.pdf', () => PdfService.receipt(pay.id));
              },
            ),
          ListTile(
            enabled: editable,
            leading: const Icon(Icons.edit_outlined),
            title: Text(t.edit),
            onTap: () {
              Navigator.pop(ctx);
              push(context, PaymentForm(payment: pay));
            },
          ),
          ListTile(
            enabled: editable,
            leading: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            title: Text(t.delete),
            onTap: () async {
              Navigator.pop(ctx);
              if (await confirm(context, t.deletePaymentQ, t.deletePaymentHelp(pay.receiptNumber), ok: t.delete, danger: true)) {
                await PaymentService.delete(pay);
                if (context.mounted) toast(context, context.t.paymentDeleted);
              }
            },
          ),
          if (!editable)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                pay.kind == PaymentKind.depositApplied ? t.paymentAutoLocked : t.paymentLockedHelp,
                style: TextStyle(fontSize: 12.5, color: Theme.of(ctx).colorScheme.onSurfaceVariant),
              ),
            ),
        ]),
      );
    },
  );
}
