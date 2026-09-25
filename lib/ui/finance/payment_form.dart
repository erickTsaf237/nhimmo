import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/payment_service.dart';
import '../../services/pdf_service.dart';
import '../theme.dart';
import '../widgets.dart';
import 'finance_widgets.dart';

/// Valeurs enregistrées (clés stables), affichées traduites via [Labels.method].
const paymentMethods = Labels.methodKeys;

/// Versement : paiement du locataire, remboursement, ou complément de caution.
/// Avec [payment], modifie un versement existant (seulement le plus récent du contrat).
class PaymentForm extends StatefulWidget {
  final int? contractId;
  final int kind;
  final Payment? payment;
  const PaymentForm({super.key, this.contractId, this.kind = PaymentKind.payment, this.payment});

  const PaymentForm.refund({super.key, required this.contractId})
      : kind = PaymentKind.refund,
        payment = null;

  const PaymentForm.deposit({super.key, required this.contractId})
      : kind = PaymentKind.depositReceived,
        payment = null;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _key = GlobalKey<FormState>();
  late final Payment? p = widget.payment;
  late final int _kind = p?.kind ?? widget.kind;
  late int? _contractId = p?.contractId ?? widget.contractId;
  late DateTime _date = p?.date ?? Dates.dayOnly(DateTime.now());
  late String _method = p?.method ?? paymentMethods.first;
  late final _amount = TextEditingController(text: p == null ? '' : Money.toInput(p!.amount));
  late final _reference = TextEditingController(text: p?.reference);
  late final _note = TextEditingController(text: p?.note);
  late bool _prefilled = p != null;

  bool get _refund => _kind == PaymentKind.refund;
  bool get _deposit => _kind == PaymentKind.depositReceived;

  String _title(BuildContext context) {
    final t = context.t;
    if (p != null) return t.editPayment;
    return _refund ? t.refundKind : _deposit ? t.completeDeposit : t.collectPayment;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DbBuilder<List<ContractView>>(
      load: () async {
        final all = await Repo.contracts();
        return all.where((c) => c.active || c.balance != 0 || c.c.id == _contractId).toList();
      },
      builder: (context, contracts) {
        final cv = contracts.where((c) => c.c.id == _contractId).firstOrNull;
        if (cv != null && !_prefilled) {
          _prefilled = true;
          final due = _deposit ? cv.c.deposit - cv.c.depositPaid : _refund ? -cv.balance : cv.balance;
          if (due > 0) _amount.text = Money.toInput(due);
        }
        return FormPage(
          title: _title(context),
          formKey: _key,
          saveLabel: p != null ? t.save : _refund ? t.saveRefund : t.savePayment,
          onSave: () async {
            final id = await PaymentService.save(
              existing: p,
              contractId: _contractId!,
              kind: _kind,
              date: _date,
              amount: Money.parse(_amount.text)!,
              method: _method,
              reference: emptyToNull(_reference.text),
              note: emptyToNull(_note.text),
            );
            if (!context.mounted) return;
            if (p != null) {
              toast(context, context.t.paymentUpdated);
              Navigator.pop(context);
              return;
            }
            final saved = await Repo.payment(id);
            if (!context.mounted) return;
            final number = saved.pay.receiptNumber;
            final open = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                icon: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
                title: Text(_refund ? ctx.t.refundSaved : ctx.t.paymentSaved),
                content: Text(ctx.t.receiptNo(number)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.t.close)),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(ctx, true),
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: Text(_refund ? ctx.t.viewRefundReceipt : ctx.t.viewReceipt),
                  ),
                ],
              ),
            );
            if (!context.mounted) return;
            if (open == true) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => PdfViewerPage(receiptTitle(context, _kind), '$number.pdf', () => PdfService.receipt(id))));
            } else {
              Navigator.pop(context);
            }
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<int>(
                initialValue: _contractId,
                isExpanded: true,
                decoration: InputDecoration(labelText: t.tenantRequired, prefixIcon: const Icon(Icons.person_outline)),
                items: [
                  for (final c in contracts)
                    DropdownMenuItem(value: c.c.id, child: Text('${c.tenant.fullName} · ${c.apt.name}', overflow: TextOverflow.ellipsis)),
                ],
                onChanged: widget.contractId != null || p != null
                    ? null
                    : (v) => setState(() {
                          _contractId = v;
                          _prefilled = false;
                          _amount.clear();
                        }),
                validator: (v) => v == null ? t.chooseTenant : null,
              ),
            ),
            if (cv != null && _deposit)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  color: AppColors.warning.withValues(alpha: .08),
                  child: Column(children: [
                    InfoRow(t.depositRequired, Money.format(cv.c.deposit)),
                    InfoRow(t.depositPaidShort, Money.format(cv.c.depositPaid)),
                    InfoRow(t.depositMissing, Money.format(cv.c.deposit - cv.c.depositPaid), strong: true, color: AppColors.warning),
                  ]),
                ),
              )
            else if (cv != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  color: (cv.balance > 0 ? AppColors.danger : AppColors.success).withValues(alpha: .08),
                  child: InfoRow(
                    cv.balance > 0 ? t.balanceDue : cv.balance < 0 ? t.inTenantFavor : t.accountUpToDate,
                    Money.format(cv.balance.abs()),
                    strong: true,
                    color: cv.balance > 0 ? AppColors.danger : AppColors.success,
                  ),
                ),
              ),
            AmountField(_amount, _deposit ? t.depositAmountReceived : t.amountReceived),
            DateField(label: t.paymentDate, value: _date, onChanged: (v) => setState(() => _date = v)),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final m in paymentMethods)
                ChoiceChip(label: Text(Labels.method(t, m)), selected: _method == m, onSelected: (_) => setState(() => _method = m)),
            ]),
            const SizedBox(height: 14),
            Field(_reference, t.referenceHint, icon: Icons.tag),
            Field(_note, t.note, icon: Icons.notes, maxLines: 2),
          ],
        );
      },
    );
  }
}
