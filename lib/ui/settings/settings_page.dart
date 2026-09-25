import 'package:flutter/material.dart';

import '../../core/i18n.dart';
import '../../core/money.dart';
import '../../services/app_state.dart';
import '../../services/demo_service.dart';
import '../../services/signature_service.dart';
import '../theme.dart';
import '../widgets.dart';
import 'backup_page.dart';
import 'catalog_pages.dart';
import 'export_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    Widget tile(IconData icon, Color color, String title, String subtitle, Widget page) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            onTap: () => push(context, page),
            child: Row(children: [
              IconBadge(icon, color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ]),
              ),
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          tile(Icons.storefront_rounded, AppColors.primary, t.general, t.generalHelp, const GeneralSettingsPage()),
          tile(Icons.speed_rounded, AppColors.info, t.meterTypes, t.meterTypesTileHelp, const UtilityTypesPage()),
          tile(Icons.local_parking_rounded, AppColors.accent, t.services, t.servicesTileHelp, const ServiceTypesPage()),
          tile(Icons.ios_share_rounded, AppColors.success, t.exports, t.exportsTileHelp, const ExportPage()),
          tile(Icons.cloud_sync_rounded, AppColors.warning, t.backupRestore, t.backupRestoreHelp, const BackupPage()),
          FutureBuilder<bool>(
            future: DemoService.isEmpty(),
            builder: (context, s) => s.data != true
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      onTap: () async {
                        await DemoService.load();
                        if (context.mounted) {
                          toast(context, context.t.demoLoaded);
                          Navigator.pop(context);
                        }
                      },
                      child: Row(children: [
                        const IconBadge(Icons.auto_awesome_rounded, Colors.purple),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t.loadDemo, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(t.loadDemoHelp, style: const TextStyle(fontSize: 12.5)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<String>(
            future: SignatureService.fingerprint(),
            builder: (context, s) => Text(
              t.signatureKey(s.data ?? '…'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  final _key = GlobalKey<FormState>();
  final s = App.settings;
  late final _name = TextEditingController(text: s.businessName);
  late final _address = TextEditingController(text: s.address);
  late final _phone = TextEditingController(text: s.phone);
  late final _email = TextEditingController(text: s.email);
  late final _footer = TextEditingController(text: s.invoiceFooter);
  late final _symbol = TextEditingController(text: s.currencySymbol);
  late String _code = s.currencyCode;
  late bool _before = s.symbolBefore;
  late int _dueDay = s.dueDay;
  late String _language = s.appLanguage;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final sample = Money.format(150000, withSymbol: false);
    return FormPage(
      title: t.general,
      formKey: _key,
      onSave: () async {
        s
          ..businessName = _name.text.trim()
          ..address = _address.text.trim()
          ..phone = _phone.text.trim()
          ..email = _email.text.trim()
          ..invoiceFooter = _footer.text.trim()
          ..currencyCode = _code
          ..currencySymbol = _symbol.text.trim()
          ..symbolBefore = _before
          ..dueDay = _dueDay
          ..appLanguage = _language;
        if (context.mounted) Navigator.pop(context);
        await s.save();
      },
      children: [
        SectionHeader(t.appLanguage),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ChoiceChip(
            avatar: const Icon(Icons.phone_android_rounded, size: 18),
            label: Text(t.systemLanguage),
            selected: _language == 'system',
            onSelected: (_) => setState(() => _language = 'system'),
          ),
          for (final code in I18n.codes)
            ChoiceChip(
              label: Text(I18n.nativeName(code)),
              selected: _language == code,
              onSelected: (_) => setState(() => _language = code),
            ),
        ]),
        SectionHeader(t.managerHeader),
        Field(_name, t.businessName, icon: Icons.storefront_outlined, required: true),
        Field(_address, t.address, icon: Icons.place_outlined),
        Field(_phone, t.phone, icon: Icons.phone_outlined, keyboard: TextInputType.phone),
        Field(_email, t.email, icon: Icons.alternate_email, keyboard: TextInputType.emailAddress),
        Field(_footer, t.invoiceFooter, icon: Icons.short_text_rounded),
        SectionHeader(t.currency),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in Currency.presets)
            ChoiceChip(
              label: Text('${c.code} (${c.symbol})'),
              selected: _code == c.code && _symbol.text == c.symbol,
              onSelected: (_) => setState(() {
                _code = c.code;
                _symbol.text = c.symbol;
                _before = c.symbolBefore;
              }),
            ),
        ]),
        const SizedBox(height: 14),
        Field(_symbol, t.customSymbol, icon: Icons.currency_exchange_rounded, required: true,
            onChanged: (_) => setState(() => _code = _symbol.text.toUpperCase())),
        SwitchRow(
          title: t.symbolBefore,
          subtitle: t.preview(_before ? '${_symbol.text} $sample' : '$sample ${_symbol.text}'),
          value: _before,
          onChanged: (v) => setState(() => _before = v),
        ),
        SectionHeader(t.billing),
        AppCard(
          child: Row(children: [
            Expanded(child: Text(t.invoiceDueDay, style: const TextStyle(fontWeight: FontWeight.w600))),
            IconButton(onPressed: _dueDay > 1 ? () => setState(() => _dueDay--) : null, icon: const Icon(Icons.remove_circle_outline)),
            Text('$_dueDay', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            IconButton(onPressed: _dueDay < 28 ? () => setState(() => _dueDay++) : null, icon: const Icon(Icons.add_circle_outline)),
          ]),
        ),
      ],
    );
  }
}
