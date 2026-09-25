import 'dart:math';

import 'package:drift/drift.dart';

import '../core/dates.dart';
import '../data/database.dart';
import '../data/repo.dart';
import 'app_state.dart';
import 'billing_service.dart';

class _Lease {
  final String tenant;
  final String phone;
  final String apt;
  final int rent;
  final DateTime start;
  final int vehicles;
  final bool guard;

  /// 'normal', 'partial' (paie ~70 %), 'late' (n'a pas payé le dernier mois), 'advance'
  final String payer;
  final String method;
  _Lease(this.tenant, this.phone, this.apt, this.rent, this.start,
      {this.vehicles = 0, this.guard = true, this.payer = 'normal', this.method = 'Mobile Money'});
}

/// Jeu de données fictif mais réaliste : 2 propriétaires, 2 immeubles à Douala,
/// 8 appartements, 7 locations dont une terminée, 6 mois d'historique.
class DemoService {
  static Future<bool> isEmpty() async =>
      (await App.db.select(App.db.apartments).get()).isEmpty;

  static const _f = 100; // 1 FCFA = 100 centimes

  static Future<void> load() async {
    final db = App.db;
    final rnd = Random(42);
    final today = Dates.dayOnly(DateTime.now());
    final now = Period.current();
    final first = Period.add(now, -6);

    // ---------------------------------------------------------------- paramètres
    App.settings
      ..businessName = 'Immo Gestion Douala'
      ..address = 'Rue Njo-Njo, Bonapriso – Douala'
      ..phone = '+237 6 90 12 34 56'
      ..email = 'contact@immogestion.cm'
      ..currencyCode = 'XAF'
      ..currencySymbol = 'FCFA'
      ..symbolBefore = false
      ..dueDay = 5;
    await App.settings.save();

    final types = await db.select(db.utilityTypes).get();
    final water = types.firstWhere((t) => t.name == 'Eau');
    final elec = types.firstWhere((t) => t.name == 'Électricité');
    await (db.update(db.utilityTypes)..where((t) => t.id.equals(water.id))).write(
        const UtilityTypesCompanion(unitPrice: Value(400 * _f), fixedFee: Value(500 * _f)));
    await (db.update(db.utilityTypes)..where((t) => t.id.equals(elec.id))).write(const UtilityTypesCompanion(
        unitPrice: Value(99 * _f), fixedFee: Value(1000 * _f), vatRate: Value(19.25), vatMode: Value(2)));

    final parking = (await db.select(db.serviceTypes).get()).first;
    await (db.update(db.serviceTypes)..where((s) => s.id.equals(parking.id)))
        .write(const ServiceTypesCompanion(unitPrice: Value(10000 * _f)));
    final guardId = await db.into(db.serviceTypes).insert(ServiceTypesCompanion.insert(
        name: 'Gardiennage', unitPrice: 5000 * _f, unitLabel: const Value('mois'),
        translations: const Value('{"en":{"name":"Security guard","unit":"month"}}')));

    // ---------------------------------------------------------------- biens
    final o1 = await db.into(db.owners).insert(OwnersCompanion.insert(
        name: 'Paul Mbarga', phone: const Value('+237 6 99 45 12 08'), email: const Value('p.mbarga@gmail.com'),
        address: const Value('Bonapriso, Douala')));
    final o2 = await db.into(db.owners).insert(OwnersCompanion.insert(
        name: 'Jeanne Ekotto', phone: const Value('+237 6 77 83 20 41'), address: const Value('Bonanjo, Douala')));
    final b1 = await db.into(db.buildings).insert(BuildingsCompanion.insert(
        ownerId: o1, name: 'Résidence Les Palmiers', address: const Value('Rue Koloko, Bonapriso – Douala')));
    final b2 = await db.into(db.buildings).insert(BuildingsCompanion.insert(
        ownerId: o2, name: 'Immeuble Ekotto', address: const Value('Boulevard de la Liberté, Akwa – Douala')));

    final aptSpecs = [
      (b1, 'A1', 'RDC', 'Studio meublé, douche, kitchenette', 85000),
      (b1, 'A2', 'RDC', '1 chambre, salon, cuisine', 120000),
      (b1, 'B1', '1er', '2 chambres, salon, cuisine, balcon', 150000),
      (b1, 'B2', '1er', '2 chambres, salon, cuisine', 150000),
      (b2, 'Appt 101', '1er', '3 chambres, 2 douches, salon', 220000),
      (b2, 'Appt 102', '1er', '2 chambres, salon, cuisine', 175000),
      (b2, 'Appt 201', '2e', '2 chambres, salon, terrasse', 180000),
      (b2, 'Studio 202', '2e', 'Studio, douche, cuisine américaine', 90000),
    ];
    final aptIds = <String, int>{};
    final meterIds = <int, List<(int, bool)>>{}; // apt -> [(meterId, isWater)]
    final indexes = <int, double>{}; // meterId -> index courant
    for (final (b, name, floor, desc, rent) in aptSpecs) {
      final id = await db.into(db.apartments).insert(ApartmentsCompanion.insert(
          buildingId: b, name: name, floor: Value(floor), description: Value(desc),
          rent: Value(rent * _f), deposit: Value(rent * 2 * _f)));
      aptIds[name] = id;
      final w0 = 100.0 + rnd.nextInt(400);
      final e0 = 2000.0 + rnd.nextInt(8000);
      final w = await db.into(db.meters).insert(MetersCompanion.insert(
          apartmentId: id, utilityTypeId: water.id, serial: Value('CW-${40000 + rnd.nextInt(9999)}'), initialIndex: Value(w0)));
      final e = await db.into(db.meters).insert(MetersCompanion.insert(
          apartmentId: id, utilityTypeId: elec.id, serial: Value('EN-${700000 + rnd.nextInt(99999)}'), initialIndex: Value(e0)));
      meterIds[id] = [(w, true), (e, false)];
      indexes[w] = w0;
      indexes[e] = e0;
    }

    // ---------------------------------------------------------------- locations
    DateTime startOf(int p, int day) => DateTime(Period.year(p), Period.month(p), day);
    final leases = [
      _Lease('Aïcha Nguema', '+237 6 77 11 22 33', 'A1', 85000, startOf(Period.add(now, -14), 1), guard: false),
      _Lease('Serge Kamdem', '+237 6 55 44 33 22', 'A2', 120000, startOf(Period.add(now, -9), 1), vehicles: 1, method: 'Espèces'),
      _Lease('Mireille Fotso', '+237 6 94 20 15 87', 'B1', 150000, startOf(Period.add(now, -20), 1), vehicles: 2, method: 'Mobile Money'),
      _Lease('Hervé Nkoulou', '+237 6 70 36 58 12', 'B2', 150000, startOf(Period.add(now, -18), 1), vehicles: 1),
      _Lease('Brice Tchoupo', '+237 6 96 02 71 44', 'Appt 101', 220000, startOf(Period.add(now, -11), 1),
          vehicles: 3, method: 'Virement', payer: 'advance'),
      _Lease('Laure Abena', '+237 6 51 88 09 63', 'Appt 102', 175000, startOf(Period.add(now, -3), 15), vehicles: 1, payer: 'partial'),
      _Lease('Ibrahim Moussa', '+237 6 99 73 40 25', 'Appt 201', 180000, startOf(Period.add(now, -7), 1), vehicles: 1, payer: 'late', method: 'Espèces'),
    ];
    // Studio 202 reste libre.

    final contracts = <String, int>{};
    for (final l in leases) {
      final tenantId = await db.into(db.tenants).insert(TenantsCompanion.insert(
          fullName: l.tenant, phone: Value(l.phone),
          // Locataire anglophone : ses documents sont produits en anglais.
          language: Value(l.tenant == 'Brice Tchoupo' ? 'en' : null),
          idNumber: Value('CNI ${100000000 + rnd.nextInt(899999999)}')));
      final aptId = aptIds[l.apt]!;
      final cid = await db.into(db.contracts).insert(ContractsCompanion.insert(
          apartmentId: aptId, tenantId: tenantId, startDate: l.start, rent: l.rent * _f,
          deposit: Value(l.rent * 2 * _f),
          // Laure n'a versé qu'une partie de sa caution.
          depositPaid: Value(l.tenant == 'Laure Abena' ? 200000 * _f : l.rent * 2 * _f), entryProrata: const Value(true),
          // Bail d'un an, reconduit tacitement.
          plannedEndDate: Value(DateTime(l.start.year + 1, l.start.month, l.start.day))));
      contracts[l.tenant] = cid;
      if (l.tenant == 'Serge Kamdem') {
        await db.into(db.contractBenefits).insert(ContractBenefitsCompanion.insert(
            contractId: cid, utilityTypeId: Value(elec.id), value: const Value(100), reason: const Value('Employé ENEO')));
      }
      if (l.vehicles > 0) {
        await db.into(db.contractServices).insert(ContractServicesCompanion.insert(
            contractId: cid, serviceTypeId: parking.id, quantity: Value(l.vehicles),
            includedQuantity: const Value(1), unitPrice: 10000 * _f));
      }
      if (l.guard) {
        await db.into(db.contractServices).insert(ContractServicesCompanion.insert(
            contractId: cid, serviceTypeId: guardId, unitPrice: 5000 * _f));
      }
      // Entrée pendant la période d'historique : index d'entrée relevé.
      if (Period.of(l.start) >= first) {
        for (final (m, _) in meterIds[aptId]!) {
          await db.into(db.readings).insert(ReadingsCompanion.insert(
              meterId: m, contractId: Value(cid), kind: const Value(1), date: l.start, value: indexes[m]!));
        }
        await _entryInspection(cid, l.start);
      }
    }

    // ---------------------------------------------------------------- historique
    final herveId = contracts['Hervé Nkoulou']!;
    final herveExit = startOf(Period.add(now, -1), 20);

    Future<void> monthlyReadings(int p, {double share = 1}) async {
      for (final l in leases) {
        if (Period.of(l.start) > p) continue;
        if (l.tenant == 'Hervé Nkoulou' && p >= Period.of(herveExit)) continue;
        final aptId = aptIds[l.apt]!;
        final big = l.rent >= 150000;
        for (final (m, isWater) in meterIds[aptId]!) {
          if (share < 1 && rnd.nextDouble() > share) continue;
          final cons = isWater
              ? (big ? 8 : 4) + rnd.nextInt(big ? 9 : 5) + rnd.nextInt(10) / 10
              : (big ? 180 : 70) + rnd.nextInt(big ? 170 : 90).toDouble();
          indexes[m] = double.parse((indexes[m]! + cons).toStringAsFixed(1));
          final day = 24 + rnd.nextInt(4);
          final d = DateTime(Period.year(p), Period.month(p), day, 8 + rnd.nextInt(9), rnd.nextInt(60));
          await db.into(db.readings).insert(ReadingsCompanion.insert(
              meterId: m, period: Value(p), date: d.isAfter(DateTime.now()) ? DateTime.now() : d, value: indexes[m]!,
              note: Value(rnd.nextInt(12) == 0 ? 'Compteur difficile d\'accès' : null)));
        }
      }
    }

    for (var p = first; p < now; p = Period.add(p, 1)) {
      if (p == Period.of(herveExit)) {
        // Sortie d'Hervé le 20 : dégâts constatés, caution de 300 000.
        final c = (await Repo.contract(herveId)).c;
        final exitIdx = <int, double>{};
        for (final (m, isWater) in meterIds[aptIds['B2']!]!) {
          indexes[m] = indexes[m]! + (isWater ? 6.4 : 142);
          exitIdx[m] = double.parse(indexes[m]!.toStringAsFixed(1));
        }
        final insp = await db.into(db.inspections).insert(InspectionsCompanion.insert(
            contractId: herveId, kind: 1, date: herveExit, notes: const Value('Clés rendues : 3/3')));
        final damages = [
          ('Salon', 'Peinture murale', 'Dégradé', 'Traces et trous de fixation', 45000),
          ('Cuisine', 'Robinet évier', 'Hors service', 'Fuite permanente, à remplacer', 18000),
          ('Chambre', 'Porte', 'Dégradé', 'Serrure forcée', 25000),
          ('Salle de bain', 'Carrelage', 'Bon', null, 0),
        ];
        for (final (room, el, cond, com, cost) in damages) {
          await db.into(db.inspectionItems).insert(InspectionItemsCompanion.insert(
              inspectionId: insp, room: room, element: el, condition: Value(cond), comment: Value(com), cost: Value(cost * _f)));
        }
        await BillingService.closeContract(c, ExitInput(
          exitDate: herveExit,
          prorata: true,
          exitIndexes: exitIdx,
          damages: 88000 * _f,
          notes: 'Appartement rendu propre, dégâts listés dans l\'état des lieux.',
        ));
      }
      await monthlyReadings(p);
      await BillingService.generateMonth(p);
    }

    // Mois en cours : relevés partiellement faits.
    await monthlyReadings(now, share: .6);

    // Dates d'émission réalistes : le 1er du mois suivant.
    for (final inv in await (db.select(db.invoices)..where((i) => i.kind.equals(0))).get()) {
      final issue = Period.lastDay(inv.period).add(const Duration(days: 1));
      await (db.update(db.invoices)..where((i) => i.id.equals(inv.id))).write(InvoicesCompanion(
          issueDate: Value(issue.isAfter(today) ? today : issue),
          dueDate: Value(DateTime(issue.year, issue.month, App.settings.dueDay))));
    }

    // ---------------------------------------------------------------- paiements
    final lastPeriod = Period.add(now, -1);
    for (final l in leases) {
      final cid = contracts[l.tenant]!;
      final invs = await (db.select(db.invoices)
            ..where((i) => i.contractId.equals(cid))
            ..orderBy([(i) => OrderingTerm.asc(i.period)]))
          .get();
      for (final inv in invs) {
        if (l.payer == 'late' && inv.period == lastPeriod) continue;
        var amount = inv.total;
        if (inv.kind == 1) {
          continue; // solde de sortie traité à part
        }
        if (l.payer == 'partial' && inv.period >= Period.add(now, -2)) {
          amount = (inv.total * .7 / 100000).round() * 100000; // arrondi aux 1 000 FCFA
        }
        if (l.payer == 'advance' && inv.period == lastPeriod) {
          amount = inv.total + 100000 * _f; // avance sur le mois suivant
        }
        final nextMonth = Period.add(inv.period, 1);
        var date = DateTime(Period.year(nextMonth), Period.month(nextMonth), 2 + rnd.nextInt(l.payer == 'late' ? 12 : 6));
        if (date.isAfter(today)) date = today;
        await db.into(db.payments).insert(PaymentsCompanion.insert(
            contractId: cid, date: date, amount: amount, method: Value(l.method),
            reference: Value(l.method == 'Mobile Money'
                ? 'MP${date.millisecondsSinceEpoch ~/ 1000 % 1000000000}'
                : l.method == 'Virement' ? 'VIR-${1000 + rnd.nextInt(8999)}' : null),
            receiptNumber: await Repo.nextReceiptNumber(date)));
      }
    }

    // Hervé : la caution couvre les dégâts, le reliquat lui est remboursé.
    final herve = await Repo.contract(herveId);
    if (herve.balance < 0) {
      final d = herveExit.add(const Duration(days: 4));
      await db.into(db.payments).insert(PaymentsCompanion.insert(
          contractId: herveId, date: d.isAfter(today) ? today : d, amount: -herve.balance, kind: const Value(2),
          method: const Value('Mobile Money'), note: const Value('Remboursement du solde de caution'),
          receiptNumber: await Repo.nextReceiptNumber(d, prefix: 'R')));
    }
  }

  static Future<void> _entryInspection(int contractId, DateTime date) async {
    final db = App.db;
    final id = await db.into(db.inspections).insert(InspectionsCompanion.insert(
        contractId: contractId, kind: 0, date: date, notes: const Value('Remise de 2 jeux de clés')));
    for (final (room, el, cond) in [
      ('Salon', 'Peinture', 'Neuf'),
      ('Salon', 'Prises électriques', 'Bon'),
      ('Cuisine', 'Évier et robinet', 'Bon'),
      ('Chambre', 'Porte et serrure', 'Bon'),
      ('Salle de bain', 'Chasse d\'eau', 'Usé'),
    ]) {
      await db.into(db.inspectionItems).insert(InspectionItemsCompanion.insert(
          inspectionId: id, room: room, element: el, condition: Value(cond)));
    }
  }
}
