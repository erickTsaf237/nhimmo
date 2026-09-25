import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/money.dart';
import '../../services/app_state.dart';
import '../../services/pdf_service.dart';
import '../../services/signature_service.dart';
import '../finance/invoice_detail_page.dart';
import '../rentals/contract_detail_page.dart';
import '../theme.dart';
import '../widgets.dart';
import '../../core/i18n.dart';

/// Scanne le QR code d'un document imprimé, vérifie la signature et l'ouvre.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode]);
  bool _handling = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    final raw = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
    if (raw == null) return;
    _handling = true;
    await _controller.stop();
    final payload = SignatureService.parse(raw);
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => _ResultPage(payload)));
    _handling = false;
    if (mounted) await _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(context.t.scanTitle, style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.flash_on_rounded), onPressed: () => _controller.toggleTorch()),
        ],
      ),
      body: Stack(children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent, width: 3),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 48,
          child: Text(
            context.t.scanHelp,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ]),
    );
  }
}

class _Check {
  final bool signatureOk;
  final bool found;
  final bool matches;
  final String? title;
  final String? subtitle;
  _Check(this.signatureOk, this.found, this.matches, this.title, this.subtitle);
}

class _ResultPage extends StatelessWidget {
  final QrPayload? payload;
  const _ResultPage(this.payload);

  Future<_Check> _check() async {
    final p = payload!;
    final ok = await SignatureService.verify(p);
    final db = App.db;
    switch (p.type) {
      case DocType.invoice:
        final inv = await (db.select(db.invoices)..where((i) => i.id.equals(p.id))).getSingleOrNull();
        return _Check(ok, inv != null, inv != null && inv.number == p.number && inv.total == p.amount,
            p.number, Money.format(p.amount));
      case DocType.receipt:
        final pay = await (db.select(db.payments)..where((x) => x.id.equals(p.id))).getSingleOrNull();
        return _Check(ok, pay != null, pay != null && pay.receiptNumber == p.number && pay.amount == p.amount,
            p.number, Money.format(p.amount));
      case DocType.exit:
        final c = await (db.select(db.contracts)..where((x) => x.id.equals(p.id))).getSingleOrNull();
        return _Check(ok, c != null, c != null, p.number, Money.format(p.amount));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (payload == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.t.result)),
        body: EmptyState(
          icon: Icons.qr_code_2_rounded,
          title: context.t.qrUnknown,
          message: context.t.qrUnknownHelp,
        ),
      );
    }
    final p = payload!;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.verification)),
      body: FutureBuilder<_Check>(
        future: _check(),
        builder: (context, s) {
          if (!s.hasData) return const Center(child: CircularProgressIndicator());
          final c = s.data!;
          final valid = c.signatureOk && (c.matches || !c.found);
          final color = !c.signatureOk ? AppColors.danger : (c.found && !c.matches) ? AppColors.warning : AppColors.success;
          final title = !c.signatureOk
              ? context.t.signatureInvalid
              : !c.found
                  ? context.t.signatureValid
                  : c.matches
                      ? context.t.documentAuthentic
                      : context.t.documentChanged;
          final message = !c.signatureOk
              ? context.t.signatureInvalidHelp
              : !c.found
                  ? context.t.signatureValidHelp
                  : c.matches
                      ? context.t.documentAuthenticHelp
                      : context.t.documentChangedHelp;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: color.withValues(alpha: .12), shape: BoxShape.circle),
                  child: Icon(valid ? Icons.verified_rounded : Icons.gpp_bad_rounded, size: 64, color: color),
                ),
              ),
              const SizedBox(height: 18),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              AppCard(
                child: Column(children: [
                  InfoRow(context.t.type, switch (p.type) {
                    DocType.invoice => context.t.docInvoice,
                    DocType.receipt => context.t.docReceipt,
                    DocType.exit => context.t.docExit,
                  }),
                  InfoRow(context.t.numberLabel, p.number),
                  InfoRow(context.t.amount, Money.format(p.amount), strong: true),
                ]),
              ),
              const SizedBox(height: 20),
              if (c.found && c.signatureOk)
                FilledButton.icon(
                  onPressed: () {
                    switch (p.type) {
                      case DocType.invoice:
                        push(context, InvoiceDetailPage(p.id));
                      case DocType.receipt:
                        openPdf(context, context.t.docReceipt, '${p.number}.pdf', () => PdfService.receipt(p.id));
                      case DocType.exit:
                        push(context, ContractDetailPage(p.id));
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(context.t.openDocument),
                ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(context.t.scanAnother),
              ),
            ],
          );
        },
      ),
    );
  }
}
