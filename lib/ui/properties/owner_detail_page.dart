import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'properties_page.dart';
import 'property_forms.dart';
import '../../core/i18n.dart';

class _Data {
  final Owner owner;
  final List<Building> buildings;
  final List<ApartmentView> apts;
  final int billedYear;
  final int collectedYear;
  final int outstanding;
  _Data(this.owner, this.buildings, this.apts, this.billedYear, this.collectedYear, this.outstanding);
}

/// Tableau de bord spécifique d'un propriétaire.
class OwnerDetailPage extends StatelessWidget {
  final int id;
  const OwnerDetailPage(this.id, {super.key});

  Future<_Data> _load() async {
    final db = App.db;
    final owner = await (db.select(db.owners)..where((o) => o.id.equals(id))).getSingle();
    final buildings = await (db.select(db.buildings)..where((b) => b.ownerId.equals(id))).get();
    final apts = await Repo.apartments(ownerId: id, includeArchived: true);
    final aptIds = apts.map((a) => a.apt.id).toSet();
    final contracts = (await Repo.contracts()).where((c) => aptIds.contains(c.apt.id)).toList();
    final cIds = contracts.map((c) => c.c.id).toList();
    final year = DateTime.now().year;

    var billed = 0, collected = 0;
    if (cIds.isNotEmpty) {
      final inv = await (db.select(db.invoices)
            ..where((i) => i.contractId.isIn(cIds) & i.period.isBetweenValues(year * 100 + 1, year * 100 + 12)))
          .get();
      billed = inv.fold(0, (s, i) => s + i.total);
      final pays = await (db.select(db.payments)
            ..where((p) => p.contractId.isIn(cIds) & p.kind.equals(0) & p.date.isBiggerOrEqualValue(DateTime(year))))
          .get();
      collected = pays.fold(0, (s, p) => s + p.amount);
    }
    final outstanding = contracts.fold<int>(0, (s, c) => s + (c.balance > 0 ? c.balance : 0));
    return _Data(owner, buildings, apts, billed, collected, outstanding);
  }

  @override
  Widget build(BuildContext context) {
    return DbBuilder<_Data>(
      load: _load,
      builder: (context, d) {
        final occupied = d.apts.where((a) => a.occupied).length;
        final monthlyRent = d.apts.where((a) => a.occupied).fold<int>(0, (s, a) => s + a.contract!.rent);
        return Scaffold(
          appBar: AppBar(
            title: Text(d.owner.name),
            actions: [IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => push(context, OwnerForm(owner: d.owner)))],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
            children: [
              AppCard(
                child: Column(children: [
                  if (d.owner.phone != null) InfoRow(context.t.phone, d.owner.phone!),
                  if (d.owner.email != null) InfoRow(context.t.email, d.owner.email!),
                  if (d.owner.address != null) InfoRow(context.t.address, d.owner.address!),
                  InfoRow(context.t.buildings, '${d.buildings.length}'),
                ]),
              ),
              const SizedBox(height: 12),
              StatGrid(
                  children: [
                  StatCard(label: context.t.occupancy, value: '$occupied / ${d.apts.length}', icon: Icons.door_front_door_rounded, color: AppColors.primary,
                      caption: d.apts.isEmpty ? null : '${(occupied * 100 / d.apts.length).round()} %'),
                  StatCard(label: context.t.monthlyRents, value: Money.compact(monthlyRent), icon: Icons.home_work_rounded, color: AppColors.info),
                  StatCard(label: context.t.billedYear('${DateTime.now().year}'), value: Money.compact(d.billedYear), icon: Icons.receipt_long_rounded, color: AppColors.accent),
                  StatCard(label: context.t.collectedYear('${DateTime.now().year}'), value: Money.compact(d.collectedYear), icon: Icons.savings_rounded, color: AppColors.success,
                      caption: d.outstanding > 0 ? context.t.unpaidAmount(Money.compact(d.outstanding)) : null),
                ],
              ),
              for (final b in d.buildings) ...[
                SectionHeader(b.name),
                for (final a in d.apts.where((a) => a.building.id == b.id))
                  Padding(padding: const EdgeInsets.only(bottom: 10), child: ApartmentTile(a)),
              ],
            ],
          ),
        );
      },
    );
  }
}
