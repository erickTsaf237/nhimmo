import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/repo.dart';
import '../../services/billing_service.dart';
import '../../services/pdf_service.dart';
import '../../services/photo_service.dart';
import '../theme.dart';
import '../widgets.dart';
import 'inspection_page.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

/// Fin de contrat : index de sortie, dégâts, calcul du solde et clôture.
class ExitPage extends StatefulWidget {
  final int contractId;
  const ExitPage({super.key, required this.contractId});

  @override
  State<ExitPage> createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  final _key = GlobalKey<FormState>();
  DateTime _date = Dates.dayOnly(DateTime.now());
  bool _prorata = true;
  final _indexes = <int, TextEditingController>{};
  final _photos = <int, String?>{};
  final _damages = TextEditingController();
  final _notes = TextEditingController();
  ContractView? _cv;
  List<MeterView> _meters = [];
  Map<int, double> _previous = {};
  ExitPreview? _preview;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cv = await Repo.contract(widget.contractId);
    final meters = await Repo.activeMeters(apartmentId: cv.apt.id);
    final prev = <int, double>{};
    for (final m in meters) {
      prev[m.meter.id] = await BillingService.startIndex(cv.c, m.meter);
      _indexes[m.meter.id] = TextEditingController();
    }
    final dmg = await inspectionDamages(widget.contractId);
    if (dmg > 0) _damages.text = Money.toInput(dmg);
    setState(() {
      _cv = cv;
      _meters = meters;
      _previous = prev;
    });
  }

  ExitInput _input() => ExitInput(
        exitDate: _date,
        prorata: _prorata,
        exitIndexes: {
          for (final e in _indexes.entries)
            if (Num.parse(e.value.text) != null) e.key: Num.parse(e.value.text)!,
        },
        exitPhotos: _photos,
        damages: Money.parse(_damages.text) ?? 0,
        notes: emptyToNull(_notes.text),
      );

  Future<void> _compute() async {
    if (!_key.currentState!.validate()) return;
    final p = await BillingService.previewExit(_cv!.c, _input());
    setState(() => _preview = p);
  }

  Future<void> _close() async {
    final ok = await confirm(context, context.t.closeLeaseQ, context.t.closeLeaseHelp,
        ok: context.t.closeAction, danger: true);
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      await BillingService.closeContract(_cv!.c, _input());
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => PdfViewerPage(context.t.docExit, 'decompte-sortie.pdf',
              () => PdfService.exitStatement(widget.contractId))));
    } catch (e) {
      if (mounted) toast(context, context.t.errorWith('$e'), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cv = _cv;
    if (cv == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final p = _preview;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.endOfLease)),
      body: Form(
        key: _key,
        onChanged: () {
          if (_preview != null) setState(() => _preview = null);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
          children: [
            AppCard(
              child: Row(children: [
                Initials(cv.tenant.fullName),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(cv.tenant.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(context.t.placeSince(cv.place, Dates.d(cv.c.startDate)), style: const TextStyle(fontSize: 12.5)),
                  ]),
                ),
              ]),
            ),
            SectionHeader(context.t.exit),
            DateField(label: context.t.exitDate, value: _date, onChanged: (v) => setState(() {
                  _date = v;
                  _preview = null;
                })),
            SwitchRow(
              title: context.t.lastMonthProrata,
              subtitle: _prorata
                  ? context.t.lastMonthProrataOn('${_date.day}')
                  : context.t.lastMonthProrataOff,
              value: _prorata,
              onChanged: (v) => setState(() {
                _prorata = v;
                _preview = null;
              }),
            ),
            if (_meters.isNotEmpty) SectionHeader(context.t.exitReadings),
            for (final m in _meters)
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Field(_indexes[m.meter.id]!, '${Labels.utilityName(m.type)} (${m.type.unit})',
                      icon: utilityIcon(m.type.iconKey),
                      required: true,
                      hint: context.t.lastBilledHint(Num.format(_previous[m.meter.id] ?? 0)),
                      keyboard: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final x = Num.parse(v ?? '');
                        if (x == null) return context.t.indexRequired;
                        if (x < (_previous[m.meter.id] ?? 0)) return context.t.lowerThanLast(Num.format(_previous[m.meter.id]!));
                        return null;
                      }),
                ),
                const SizedBox(width: 8),
                _photos[m.meter.id] == null
                    ? IconButton.filledTonal(
                        onPressed: () async {
                          final ph = await PhotoService.take();
                          if (ph != null) setState(() => _photos[m.meter.id] = ph);
                        },
                        icon: const Icon(Icons.photo_camera_rounded),
                      )
                    : PhotoThumb(_photos[m.meter.id], size: 50),
              ]),
            SectionHeader(context.t.inspectionAndDamages),
            AppCard(
              onTap: () async {
                await push(context, InspectionPage(contractId: widget.contractId, kind: 1));
                final dmg = await inspectionDamages(widget.contractId);
                if (dmg > 0) {
                  setState(() {
                    _damages.text = Money.toInput(dmg);
                    _preview = null;
                  });
                }
              },
              child: Row(children: [
                const IconBadge(Icons.fact_check_rounded, AppColors.info, size: 40),
                const SizedBox(width: 12),
                Expanded(child: Text(context.t.roomByRoomOptional, style: const TextStyle(fontWeight: FontWeight.w600))),
                const Icon(Icons.chevron_right_rounded),
              ]),
            ),
            const SizedBox(height: 12),
            AmountField(_damages, context.t.totalDamages, required: false,
                helper: context.t.deductedFromDeposit(Money.format(cv.c.depositPaid))),
            Field(_notes, context.t.observations, icon: Icons.notes, maxLines: 3),
            if (p != null) ...[
              SectionHeader(context.t.statement),
              if (p.warnings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    color: AppColors.warning.withValues(alpha: .1),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      for (final w in p.warnings) Text('⚠ $w'),
                    ]),
                  ),
                ),
              AppCard(
                child: Column(children: [
                  for (final l in p.lines) InfoRow(l.label, Money.format(l.ttc)),
                  const Divider(height: 20),
                  InfoRow(context.t.exitInvoiceTotal, Money.format(p.exitTotal), strong: true),
                  InfoRow(context.t.previousBalance, Money.format(p.previousBalance)),
                  InfoRow(context.t.depositPaidShort, '− ${Money.format(p.depositPaid)}', color: AppColors.success),
                  const Divider(height: 20),
                  InfoRow(
                    p.finalBalance > 0 ? context.t.tenantStillOwes : p.finalBalance < 0 ? context.t.refundToTenant : context.t.accountSettled,
                    Money.format(p.finalBalance.abs()),
                    strong: true,
                    color: p.finalBalance > 0 ? AppColors.danger : AppColors.success,
                  ),
                  if (p.finalBalance > 0 && p.depositPaid > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(context.t.depositInsufficient,
                          style: const TextStyle(fontSize: 12.5, color: AppColors.danger)),
                    ),
                ]),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: p == null
              ? FilledButton.icon(onPressed: _compute, icon: const Icon(Icons.calculate_rounded), label: Text(context.t.computeStatement))
              : FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
                  onPressed: _busy ? null : _close,
                  icon: const Icon(Icons.lock_rounded),
                  label: Text(context.t.closeLease),
                ),
        ),
      ),
    );
  }
}
