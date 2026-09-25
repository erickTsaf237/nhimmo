import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../widgets.dart';
import 'rentals_page.dart';
import '../../core/i18n.dart';

/// Création / modification d'un locataire. Renvoie l'id créé via Navigator.pop.
class TenantForm extends StatefulWidget {
  final Tenant? tenant;
  const TenantForm({super.key, this.tenant});

  @override
  State<TenantForm> createState() => _TenantFormState();
}

class _TenantFormState extends State<TenantForm> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.tenant?.fullName);
  late final _phone = TextEditingController(text: widget.tenant?.phone);
  late final _email = TextEditingController(text: widget.tenant?.email);
  late final _idNumber = TextEditingController(text: widget.tenant?.idNumber);
  late final _emergency = TextEditingController(text: widget.tenant?.emergencyContact);
  late final _notes = TextEditingController(text: widget.tenant?.notes);
  late String? _language = widget.tenant?.language;

  @override
  Widget build(BuildContext context) {
    final t = widget.tenant;
    final db = App.db;
    return FormPage(
      title: t == null ? context.t.newTenant : t.fullName,
      formKey: _key,
      actions: [
        if (t != null)
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final used = await (db.select(db.contracts)..where((c) => c.tenantId.equals(t.id))).get();
              if (!context.mounted) return;
              if (used.isNotEmpty) return toast(context, context.t.tenantHasLeases, error: true);
              if (await confirm(context, context.t.deleteQ, t.fullName, danger: true, ok: context.t.delete)) {
                await (db.delete(db.tenants)..where((x) => x.id.equals(t.id))).go();
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
      ],
      onSave: () async {
        final c = TenantsCompanion(
          fullName: Value(_name.text.trim()),
          phone: Value(emptyToNull(_phone.text)),
          email: Value(emptyToNull(_email.text)),
          idNumber: Value(emptyToNull(_idNumber.text)),
          emergencyContact: Value(emptyToNull(_emergency.text)),
          notes: Value(emptyToNull(_notes.text)),
          language: Value(_language),
        );
        int id;
        if (t == null) {
          id = await db.into(db.tenants).insert(c);
        } else {
          id = t.id;
          await (db.update(db.tenants)..where((x) => x.id.equals(t.id))).write(c);
        }
        if (context.mounted) Navigator.pop(context, id);
      },
      children: [
        Field(_name, context.t.fullName, icon: Icons.person_outline, required: true),
        Field(_phone, context.t.phone, icon: Icons.phone_outlined, keyboard: TextInputType.phone),
        Field(_email, context.t.email, icon: Icons.alternate_email, keyboard: TextInputType.emailAddress),
        Field(_idNumber, context.t.idNumber, icon: Icons.badge_outlined),
        Field(_emergency, context.t.emergencyContact, icon: Icons.contact_emergency_outlined),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: DropdownButtonFormField<String?>(
            initialValue: _language,
            decoration: InputDecoration(
              labelText: context.t.documentLanguage,
              helperText: context.t.documentLanguageHelp,
              helperMaxLines: 2,
              prefixIcon: const Icon(Icons.translate_rounded),
            ),
            items: [
              DropdownMenuItem(value: null, child: Text(context.t.sameAsApp(I18n.nativeName(I18n.lang)))),
              for (final code in I18n.codes) DropdownMenuItem(value: code, child: Text(I18n.nativeName(code))),
            ],
            onChanged: (v) => setState(() => _language = v),
          ),
        ),
        Field(_notes, context.t.notes, icon: Icons.notes, maxLines: 3),
        if (t != null) ...[
          SectionHeader(context.t.leases),
          DbBuilder<List<ContractView>>(
            load: () => Repo.contracts(tenantId: t.id),
            builder: (context, list) => Column(children: [
              if (list.isEmpty) AppCard(child: Text(context.t.noLease)),
              for (final c in list) Padding(padding: const EdgeInsets.only(bottom: 8), child: ContractTile(c)),
            ]),
          ),
        ],
      ],
    );
  }
}
