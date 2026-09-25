import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../services/app_state.dart';
import '../widgets.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

AppDatabase get _db => App.db;

// ---------------------------------------------------------------- propriétaire

class OwnerForm extends StatefulWidget {
  final Owner? owner;
  const OwnerForm({super.key, this.owner});

  @override
  State<OwnerForm> createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.owner?.name);
  late final _phone = TextEditingController(text: widget.owner?.phone);
  late final _email = TextEditingController(text: widget.owner?.email);
  late final _address = TextEditingController(text: widget.owner?.address);
  late final _notes = TextEditingController(text: widget.owner?.notes);

  @override
  Widget build(BuildContext context) {
    final o = widget.owner;
    return FormPage(
      title: o == null ? context.t.newOwner : context.t.editOwner,
      formKey: _key,
      actions: [
        if (o != null)
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final used = await (_db.select(_db.buildings)..where((b) => b.ownerId.equals(o.id))).get();
              if (!context.mounted) return;
              if (used.isNotEmpty) return toast(context, context.t.ownerHasBuildings, error: true);
              if (await confirm(context, context.t.deleteQ, o.name, danger: true, ok: context.t.delete)) {
                await (_db.delete(_db.owners)..where((x) => x.id.equals(o.id))).go();
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
      ],
      onSave: () async {
        final c = OwnersCompanion(
          name: Value(_name.text.trim()),
          phone: Value(emptyToNull(_phone.text)),
          email: Value(emptyToNull(_email.text)),
          address: Value(emptyToNull(_address.text)),
          notes: Value(emptyToNull(_notes.text)),
        );
        if (o == null) {
          await _db.into(_db.owners).insert(c);
        } else {
          await (_db.update(_db.owners)..where((x) => x.id.equals(o.id))).write(c);
        }
        if (context.mounted) Navigator.pop(context);
      },
      children: [
        Field(_name, context.t.fullName, icon: Icons.person_outline, required: true),
        Field(_phone, context.t.phone, icon: Icons.phone_outlined, keyboard: TextInputType.phone),
        Field(_email, context.t.email, icon: Icons.alternate_email, keyboard: TextInputType.emailAddress),
        Field(_address, context.t.address, icon: Icons.place_outlined),
        Field(_notes, context.t.notes, icon: Icons.notes, maxLines: 3),
      ],
    );
  }
}

// ---------------------------------------------------------------- immeuble

class BuildingForm extends StatefulWidget {
  final Building? building;
  const BuildingForm({super.key, this.building});

  @override
  State<BuildingForm> createState() => _BuildingFormState();
}

class _BuildingFormState extends State<BuildingForm> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.building?.name);
  late final _address = TextEditingController(text: widget.building?.address);
  late final _notes = TextEditingController(text: widget.building?.notes);
  late int? _ownerId = widget.building?.ownerId;

  @override
  Widget build(BuildContext context) {
    final b = widget.building;
    return DbBuilder<List<Owner>>(
      load: () => _db.select(_db.owners).get(),
      builder: (context, owners) {
        if (owners.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(context.t.newBuilding)),
            body: EmptyState(
              icon: Icons.badge_rounded,
              title: context.t.noOwner,
              message: context.t.createOwnerFirst,
              action: FilledButton.icon(
                onPressed: () => push(context, const OwnerForm()),
                icon: const Icon(Icons.add),
                label: Text(context.t.createOwner),
              ),
            ),
          );
        }
        _ownerId ??= owners.length == 1 ? owners.first.id : null;
        return FormPage(
          title: b == null ? context.t.newBuilding : context.t.editBuilding,
          formKey: _key,
          actions: [
            if (b != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () async {
                  final used = await (_db.select(_db.apartments)..where((a) => a.buildingId.equals(b.id))).get();
                  if (!context.mounted) return;
                  if (used.isNotEmpty) return toast(context, context.t.buildingHasApts, error: true);
                  if (await confirm(context, context.t.deleteQ, b.name, danger: true, ok: context.t.delete)) {
                    await (_db.delete(_db.buildings)..where((x) => x.id.equals(b.id))).go();
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
          ],
          onSave: () async {
            final c = BuildingsCompanion(
              ownerId: Value(_ownerId!),
              name: Value(_name.text.trim()),
              address: Value(emptyToNull(_address.text)),
              notes: Value(emptyToNull(_notes.text)),
            );
            if (b == null) {
              await _db.into(_db.buildings).insert(c);
            } else {
              await (_db.update(_db.buildings)..where((x) => x.id.equals(b.id))).write(c);
            }
            if (context.mounted) Navigator.pop(context);
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<int>(
                initialValue: _ownerId,
                decoration: InputDecoration(labelText: context.t.ownerRequired, prefixIcon: const Icon(Icons.badge_outlined)),
                items: [for (final o in owners) DropdownMenuItem(value: o.id, child: Text(o.name))],
                onChanged: (v) => setState(() => _ownerId = v),
                validator: (v) => v == null ? context.t.chooseOwner : null,
              ),
            ),
            Field(_name, context.t.buildingName, icon: Icons.location_city_outlined, required: true, hint: context.t.buildingNameHint),
            Field(_address, context.t.address, icon: Icons.place_outlined),
            Field(_notes, context.t.notes, icon: Icons.notes, maxLines: 3),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------- appartement

class ApartmentForm extends StatefulWidget {
  final Apartment? apartment;
  const ApartmentForm({super.key, this.apartment});

  @override
  State<ApartmentForm> createState() => _ApartmentFormState();
}

class _ApartmentFormState extends State<ApartmentForm> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.apartment?.name);
  late final _floor = TextEditingController(text: widget.apartment?.floor);
  late final _desc = TextEditingController(text: widget.apartment?.description);
  late final _rent = TextEditingController(text: widget.apartment == null ? '' : Money.toInput(widget.apartment!.rent));
  late final _deposit = TextEditingController(text: widget.apartment == null ? '' : Money.toInput(widget.apartment!.deposit));
  late int? _buildingId = widget.apartment?.buildingId;
  final _withMeters = <int>{};

  @override
  Widget build(BuildContext context) {
    final a = widget.apartment;
    return DbBuilder<(List<Building>, List<UtilityType>)>(
      load: () async => (
        await _db.select(_db.buildings).get(),
        await (_db.select(_db.utilityTypes)..where((t) => t.active.equals(true))).get(),
      ),
      builder: (context, data) {
        final (buildings, types) = data;
        if (buildings.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(context.t.newApartment)),
            body: EmptyState(
              icon: Icons.location_city_rounded,
              title: context.t.noBuilding,
              message: context.t.aptNeedsBuilding,
              action: FilledButton.icon(
                onPressed: () => push(context, const BuildingForm()),
                icon: const Icon(Icons.add),
                label: Text(context.t.createBuilding),
              ),
            ),
          );
        }
        _buildingId ??= buildings.length == 1 ? buildings.first.id : null;
        return FormPage(
          title: a == null ? context.t.newApartment : context.t.editApartment,
          formKey: _key,
          onSave: () async {
            final c = ApartmentsCompanion(
              buildingId: Value(_buildingId!),
              name: Value(_name.text.trim()),
              floor: Value(emptyToNull(_floor.text)),
              description: Value(emptyToNull(_desc.text)),
              rent: Value(Money.parse(_rent.text) ?? 0),
              deposit: Value(Money.parse(_deposit.text) ?? 0),
            );
            if (a == null) {
              await _db.transaction(() async {
                final id = await _db.into(_db.apartments).insert(c);
                for (final t in _withMeters) {
                  await _db.into(_db.meters).insert(MetersCompanion.insert(apartmentId: id, utilityTypeId: t));
                }
              });
            } else {
              await (_db.update(_db.apartments)..where((x) => x.id.equals(a.id))).write(c);
            }
            if (context.mounted) Navigator.pop(context);
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<int>(
                initialValue: _buildingId,
                decoration: InputDecoration(labelText: context.t.buildingRequired, prefixIcon: const Icon(Icons.location_city_outlined)),
                items: [for (final b in buildings) DropdownMenuItem(value: b.id, child: Text(b.name))],
                onChanged: (v) => setState(() => _buildingId = v),
                validator: (v) => v == null ? context.t.chooseBuilding : null,
              ),
            ),
            Field(_name, context.t.aptName, icon: Icons.door_front_door_outlined, required: true, hint: context.t.aptNameHint),
            Field(_floor, context.t.floor, icon: Icons.stairs_outlined),
            Field(_desc, context.t.description, icon: Icons.notes, maxLines: 2, hint: context.t.aptDescHint),
            AmountField(_rent, context.t.defaultRent, required: false),
            AmountField(_deposit, context.t.defaultDeposit, required: false),
            if (a == null && types.isNotEmpty) ...[
              SectionHeader(context.t.metersToCreate),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final t in types)
                  FilterChip(
                    avatar: Icon(utilityIcon(t.iconKey), size: 18, color: Color(t.colorValue)),
                    label: Text(Labels.utilityName(t)),
                    selected: _withMeters.contains(t.id),
                    onSelected: (s) => setState(() => s ? _withMeters.add(t.id) : _withMeters.remove(t.id)),
                  ),
              ]),
            ],
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------- compteur

Future<void> showMeterSheet(BuildContext context, int apartmentId, {Meter? meter}) {
  return showSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _MeterSheet(apartmentId, meter),
  );
}

class _MeterSheet extends StatefulWidget {
  final int apartmentId;
  final Meter? meter;
  const _MeterSheet(this.apartmentId, this.meter);

  @override
  State<_MeterSheet> createState() => _MeterSheetState();
}

class _MeterSheetState extends State<_MeterSheet> {
  final _key = GlobalKey<FormState>();
  late final _serial = TextEditingController(text: widget.meter?.serial);
  late final _initial = TextEditingController(text: widget.meter == null ? '0' : Num.format(widget.meter!.initialIndex));
  late int? _typeId = widget.meter?.utilityTypeId;

  @override
  Widget build(BuildContext context) {
    final m = widget.meter;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: DbBuilder<List<UtilityType>>(
        load: () => (_db.select(_db.utilityTypes)..where((t) => t.active.equals(true))).get(),
        builder: (context, types) => Form(
          key: _key,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(m == null ? context.t.newMeter : context.t.editMeter, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DropdownButtonFormField<int>(
                initialValue: _typeId,
                decoration: InputDecoration(labelText: context.t.typeRequired, prefixIcon: const Icon(Icons.speed_outlined)),
                items: [
                  for (final t in types)
                    DropdownMenuItem(
                      value: t.id,
                      child: Row(children: [
                        Icon(utilityIcon(t.iconKey), color: Color(t.colorValue), size: 18),
                        const SizedBox(width: 8),
                        Text('${Labels.utilityName(t)} (${t.unit})'),
                      ]),
                    ),
                ],
                onChanged: m == null ? (v) => setState(() => _typeId = v) : null,
                validator: (v) => v == null ? context.t.chooseType : null,
              ),
            ),
            Field(_serial, context.t.serialNumber, icon: Icons.tag),
            Field(_initial, context.t.initialIndex, icon: Icons.pin_outlined,
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => Num.parse(v ?? '') == null ? context.t.indexInvalid : null),
            Row(children: [
              if (m != null)
                TextButton.icon(
                  onPressed: () async {
                    await (_db.update(_db.meters)..where((x) => x.id.equals(m.id))).write(const MetersCompanion(active: Value(false)));
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.power_settings_new_rounded),
                  label: Text(context.t.deactivate),
                ),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  if (!_key.currentState!.validate()) return;
                  final c = MetersCompanion(
                    apartmentId: Value(widget.apartmentId),
                    utilityTypeId: Value(_typeId!),
                    serial: Value(emptyToNull(_serial.text)),
                    initialIndex: Value(Num.parse(_initial.text)!),
                  );
                  if (m == null) {
                    await _db.into(_db.meters).insert(c);
                  } else {
                    await (_db.update(_db.meters)..where((x) => x.id.equals(m.id))).write(c);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(context.t.save),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
