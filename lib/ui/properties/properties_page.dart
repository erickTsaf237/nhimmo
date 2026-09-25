import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'apartment_detail_page.dart';
import 'owner_detail_page.dart';
import 'property_forms.dart';
import '../../core/i18n.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.navProperties),
            bottom: TabBar(tabs: [
              Tab(text: context.t.apartments),
              Tab(text: context.t.buildings),
              Tab(text: context.t.owners),
            ]),
          ),
          body: const TabBarView(children: [_ApartmentsTab(), _BuildingsTab(), _OwnersTab()]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              final i = DefaultTabController.of(context).index;
              push(context, [const ApartmentForm(), const BuildingForm(), const OwnerForm()][i]);
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(context.t.add),
          ),
        );
      }),
    );
  }
}

class _ApartmentsTab extends StatelessWidget {
  const _ApartmentsTab();

  @override
  Widget build(BuildContext context) {
    return DbBuilder<List<ApartmentView>>(
      load: () => Repo.apartments(),
      builder: (context, list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: Icons.apartment_rounded,
            title: context.t.noApartment,
            message: context.t.noApartmentHelp,
          );
        }
        final occupied = list.where((a) => a.occupied).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Row(children: [
              Expanded(child: _Pill('${list.length}', context.t.pillApartments, AppColors.primary)),
              const SizedBox(width: 10),
              Expanded(child: _Pill('$occupied', context.t.pillOccupied, AppColors.success)),
              const SizedBox(width: 10),
              Expanded(child: _Pill('${list.length - occupied}', context.t.pillFree, AppColors.warning)),
            ]),
            const SizedBox(height: 12),
            for (final a in list)
              Padding(padding: const EdgeInsets.only(bottom: 10), child: ApartmentTile(a)),
          ],
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _Pill(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ]),
      );
}

class ApartmentTile extends StatelessWidget {
  final ApartmentView a;
  const ApartmentTile(this.a, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      onTap: () => push(context, ApartmentDetailPage(a.apt.id)),
      child: Row(children: [
        IconBadge(Icons.door_front_door_rounded, a.occupied ? AppColors.success : AppColors.warning),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.apt.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
            const SizedBox(height: 2),
            Text('${a.building.name}${a.apt.floor == null ? '' : ' · ${context.t.floorN(a.apt.floor!)}'}',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 6),
            Row(children: [
              StatusChip(a.occupied ? a.tenant!.fullName : context.t.free,
                  a.occupied ? AppColors.success : AppColors.warning,
                  icon: a.occupied ? Icons.person_rounded : Icons.key_rounded),
              const SizedBox(width: 6),
              for (final m in a.meters)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(utilityIcon(m.type.iconKey), size: 16, color: Color(m.type.colorValue)),
                ),
            ]),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(Money.compact(a.contract?.rent ?? a.apt.rent), style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(context.t.perMonth, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
        ]),
      ]),
    );
  }
}

class _BuildingsTab extends StatelessWidget {
  const _BuildingsTab();

  @override
  Widget build(BuildContext context) {
    return DbBuilder<(List<(Building, Owner)>, List<ApartmentView>)>(
      load: () async {
        final db = App.db;
        final rows = await (db.select(db.buildings).join([
          innerJoin(db.owners, db.owners.id.equalsExp(db.buildings.ownerId)),
        ])
              ..orderBy([OrderingTerm.asc(db.buildings.name)]))
            .get();
        return (
          rows.map((r) => (r.readTable(db.buildings), r.readTable(db.owners))).toList(),
          await Repo.apartments()
        );
      },
      builder: (context, data) {
        final (buildings, apts) = data;
        if (buildings.isEmpty) {
          return EmptyState(icon: Icons.location_city_rounded, title: context.t.noBuilding, message: context.t.noBuildingHelp);
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            for (final (b, o) in buildings)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => push(context, BuildingForm(building: b)),
                  child: Row(children: [
                    const IconBadge(Icons.location_city_rounded, AppColors.info),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(b.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                        Text(b.address ?? context.t.addressUnknown, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(context.t.ownerIs(o.name), style: const TextStyle(fontSize: 12.5)),
                      ]),
                    ),
                    Builder(builder: (_) {
                      final list = apts.where((a) => a.building.id == b.id);
                      final occ = list.where((a) => a.occupied).length;
                      return StatusChip(context.t.occupiedRatio('$occ', '${list.length}'), AppColors.primary);
                    }),
                  ]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OwnersTab extends StatelessWidget {
  const _OwnersTab();

  @override
  Widget build(BuildContext context) {
    return DbBuilder<(List<Owner>, List<ApartmentView>)>(
      load: () async => (
        await (App.db.select(App.db.owners)..orderBy([(o) => OrderingTerm.asc(o.name)])).get(),
        await Repo.apartments()
      ),
      builder: (context, data) {
        final (owners, apts) = data;
        if (owners.isEmpty) {
          return EmptyState(icon: Icons.badge_rounded, title: context.t.noOwner, message: context.t.noOwnerHelp);
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            for (final o in owners)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => push(context, OwnerDetailPage(o.id)),
                  child: Row(children: [
                    Initials(o.name),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(o.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
                        Text(o.phone ?? o.email ?? '—', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                      ]),
                    ),
                    StatusChip(context.t.aptCount('${apts.where((a) => a.owner.id == o.id).length}'), AppColors.primary),
                    const Icon(Icons.chevron_right_rounded),
                  ]),
                ),
              ),
          ],
        );
      },
    );
  }
}
