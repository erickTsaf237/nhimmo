import 'package:flutter/material.dart';

import '../../core/billing_calc.dart';
import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../l10n/app_localizations.dart';
import '../../data/repo.dart';
import '../../services/billing_service.dart';
import '../../services/pdf_service.dart';
import '../finance/finance_widgets.dart';
import '../finance/payment_form.dart';
import '../properties/apartment_detail_page.dart';
import '../theme.dart';
import '../widgets.dart';
import 'benefits_section.dart';
import 'contract_form.dart';
import 'exit_page.dart';
import 'inspection_page.dart';
import 'tenant_form.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

class _Data {
  final ContractView cv;
  final List<InvoiceView> invoices;
  final List<PaymentView> payments;
  final List<(ContractService, ServiceType)> services;
  _Data(this.cv, this.invoices, this.payments, this.services);
}

/// Tableau de bord spécifique d'un contrat / locataire.
class ContractDetailPage extends StatelessWidget {
  final int id;
  const ContractDetailPage(this.id, {super.key});

  Future<_Data> _load() async => _Data(
        await Repo.contract(id),
        await Repo.invoices(contractId: id),
        await Repo.payments(contractId: id),
        await BillingService.contractServices(id),
      );

  @override
  Widget build(BuildContext context) {
    return DbBuilder<_Data>(
      load: _load,
      builder: (context, d) {
        final cv = d.cv;
        final c = cv.c;
        final cs = Theme.of(context).colorScheme;
        final b = cv.balance;
        final paid = d.payments.where((p) => p.pay.kind == 0).fold<int>(0, (s, p) => s + p.pay.amount);
        final billed = d.invoices.fold<int>(0, (s, i) => s + i.inv.total);

        return Scaffold(
          appBar: AppBar(
            title: Text(cv.tenant.fullName),
            actions: [
              if (cv.active)
                IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => push(context, ContractForm(contract: c))),
              PopupMenuButton<String>(
                onSelected: (v) {
                  switch (v) {
                    case 'tenant':
                      push(context, TenantForm(tenant: cv.tenant));
                    case 'apt':
                      push(context, ApartmentDetailPage(cv.apt.id));
                    case 'entry':
                      push(context, InspectionPage(contractId: c.id, kind: 0));
                    case 'exitInsp':
                      push(context, InspectionPage(contractId: c.id, kind: 1));
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'tenant', child: Text(context.t.tenantSheet)),
                  PopupMenuItem(value: 'apt', child: Text(context.t.apartmentSheet)),
                  PopupMenuItem(value: 'entry', child: Text(context.t.entryInspection)),
                  if (!cv.active) PopupMenuItem(value: 'exitInsp', child: Text(context.t.exitInspection)),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: b > 0
                      ? const LinearGradient(colors: [Color(0xFFB83B3B), Color(0xFF8A2C3C)])
                      : AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(cv.place, style: const TextStyle(color: Colors.white70))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      child: Text(cv.active ? context.t.statusOngoingCaps : context.t.statusEndedCaps,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  Text(
                    b > 0 ? context.t.remainingToPay : b < 0 ? (cv.active ? context.t.tenantAdvance : context.t.refundToTenant) : context.t.accountUpToDate,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(Money.format(b.abs()), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                        onPressed: () => push(context, PaymentForm(contractId: c.id)),
                        icon: const Icon(Icons.add_card_rounded),
                        label: Text(context.t.actionCollect),
                      ),
                    ),
                    if (!cv.active && b < 0) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
                          onPressed: () => push(context, PaymentForm.refund(contractId: c.id)),
                          icon: const Icon(Icons.undo_rounded),
                          label: Text(context.t.refund),
                        ),
                      ),
                    ],
                  ]),
                ]),
              ),
              const SizedBox(height: 12),
              if (cv.active && c.depositPaid < c.deposit) ...[
                AppCard(
                  color: AppColors.warning.withValues(alpha: .10),
                  child: Row(children: [
                    const IconBadge(Icons.savings_rounded, AppColors.warning, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.t.depositIncomplete, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(context.t.depositIncompleteDetail(Money.format(c.depositPaid), Money.format(c.deposit)),
                            style: const TextStyle(fontSize: 12.5)),
                        Text(context.t.depositMissingAmount(Money.format(c.deposit - c.depositPaid)),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.warning)),
                      ]),
                    ),
                    FilledButton.tonal(
                      onPressed: () => push(context, PaymentForm.deposit(contractId: c.id)),
                      child: Text(context.t.complete),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
              ],
              if (cv.active)
                AppCard(
                  onTap: () => push(context, ExitPage(contractId: c.id)),
                  child: Row(children: [
                    const IconBadge(Icons.logout_rounded, AppColors.warning, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.t.endLease, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(context.t.endLeaseHelp, style: const TextStyle(fontSize: 12.5)),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ]),
                )
              else
                AppCard(
                  onTap: () => openPdf(context, context.t.docExit, 'decompte-${cv.tenant.fullName}.pdf',
                      () => PdfService.exitStatement(c.id)),
                  child: Row(children: [
                    const IconBadge(Icons.picture_as_pdf_rounded, AppColors.danger, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(context.t.exitDocument, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(context.t.exitDocumentHelp, style: const TextStyle(fontSize: 12.5)),
                      ]),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ]),
                ),
              SectionHeader(context.t.lease),
              AppCard(
                child: Column(children: [
                  InfoRow(context.t.moveIn, Dates.long(c.startDate)),
                  if (c.plannedEndDate != null) ..._term(context.t, c),
                  if (c.exitDate != null) InfoRow(context.t.moveOut, Dates.long(c.exitDate)),
                  InfoRow(context.t.monthlyRent, Money.format(c.rent)),
                  InfoRow(context.t.depositPaidShort, color: c.depositPaid < c.deposit ? AppColors.warning : null, '${Money.format(c.depositPaid)}${c.deposit != c.depositPaid ? ' / ${Money.format(c.deposit)}' : ''}'),
                  InfoRow(context.t.firstMonth, c.entryProrata ? context.t.prorated : context.t.fullMonth),
                  if (c.exitProrata != null) InfoRow(context.t.lastMonth, c.exitProrata! ? context.t.prorated : context.t.fullMonth),
                  if (c.damagesAmount > 0) InfoRow(context.t.damagesRetained, Money.format(c.damagesAmount), color: AppColors.danger),
                  for (final (s, t) in d.services)
                    InfoRow(Labels.serviceName(t), context.t.serviceLine('${s.quantity}', '${s.includedQuantity}', Money.format(s.unitPrice))),
                  const Divider(height: 20),
                  InfoRow(context.t.totalBilled, Money.format(billed)),
                  InfoRow(context.t.totalPaid, Money.format(paid), color: AppColors.success),
                  if (cv.tenant.phone != null) InfoRow(context.t.phone, cv.tenant.phone!),
                ]),
              ),
              BenefitsSection(contractId: c.id, editable: cv.active),
              SectionHeader(context.t.invoicesCount('${d.invoices.length}')),
              if (d.invoices.isEmpty)
                AppCard(child: Text(context.t.noInvoiceYet, style: TextStyle(color: cs.onSurfaceVariant))),
              for (final i in d.invoices) Padding(padding: const EdgeInsets.only(bottom: 8), child: InvoiceTile(i, showTenant: false)),
              SectionHeader(context.t.paymentsCount('${d.payments.length}')),
              if (d.payments.isEmpty)
                AppCard(child: Text(context.t.noPayment, style: TextStyle(color: cs.onSurfaceVariant))),
              for (final p in d.payments) Padding(padding: const EdgeInsets.only(bottom: 8), child: PaymentTile(p, showTenant: false)),
            ],
          ),
        );
      },
    );
  }
}

/// Échéance du bail : jamais d'arrêt automatique, reconduction tacite éventuelle.
List<Widget> _term(AppLocalizations t, Contract c) {
  final today = DateTime.now();
  if (c.status != 0) return [InfoRow(t.initialTermEnd, Dates.long(c.plannedEndDate))];
  final end = LeaseTerm.currentEnd(c.startDate, c.plannedEndDate, c.tacitRenewal, today)!;
  final n = LeaseTerm.renewals(c.startDate, c.plannedEndDate, c.tacitRenewal, today);
  final expired = !c.tacitRenewal && today.isAfter(c.plannedEndDate!);
  return [
    InfoRow(t.initialTermEnd, Dates.long(c.plannedEndDate)),
    InfoRow(t.renewal, c.tacitRenewal ? (n > 0 ? t.renewedTimes('$n') : t.renewalTacit) : t.no),
    if (c.tacitRenewal) InfoRow(t.nextDeadline, Dates.long(end)),
    if (expired)
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: StatusChip(t.leaseExpired, AppColors.warning),
      ),
  ];
}
