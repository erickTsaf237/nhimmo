import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ---------------------------------------------------------------------------
// Référentiel
// ---------------------------------------------------------------------------

class Owners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
}

class Buildings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerId => integer().references(Owners, #id)();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
}

class Apartments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get buildingId => integer().references(Buildings, #id)();
  TextColumn get name => text()();
  TextColumn get floor => text().nullable()();
  TextColumn get description => text().nullable()();

  /// Loyer et caution proposés par défaut (centimes).
  IntColumn get rent => integer().withDefault(const Constant(0))();
  IntColumn get deposit => integer().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

class Tenants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get idNumber => text().nullable()();
  TextColumn get emergencyContact => text().nullable()();

  /// Langue des documents du locataire (null = langue de l'application).
  TextColumn get language => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Type de compteur générique : eau, électricité, gaz... même calcul pour tous.
class UtilityTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  IntColumn get unitPrice => integer()();
  IntColumn get fixedFee => integer().withDefault(const Constant(0))();
  RealColumn get vatRate => real().withDefault(const Constant(0))();

  /// Index de [VatMode].
  IntColumn get vatMode => integer().withDefault(const Constant(0))();
  BoolColumn get vatOnFixedFee =>
      boolean().withDefault(const Constant(false))();
  TextColumn get iconKey => text().withDefault(const Constant('bolt'))();

  /// Noms dans les autres langues, JSON : {"en": "Water"}.
  TextColumn get translations => text().nullable()();
  IntColumn get colorValue => integer().withDefault(const Constant(0xFF0E7C7B))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class Meters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get apartmentId => integer().references(Apartments, #id)();
  IntColumn get utilityTypeId => integer().references(UtilityTypes, #id)();
  TextColumn get serial => text().nullable()();
  RealColumn get initialIndex => real().withDefault(const Constant(0))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

/// Services tiers : parking, gardiennage...
class ServiceTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get unitPrice => integer()();
  TextColumn get unitLabel => text().withDefault(const Constant('unité'))();

  /// Noms / unités dans les autres langues, JSON : {"en": {"name": "Parking", "unit": "vehicle"}}.
  TextColumn get translations => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

// ---------------------------------------------------------------------------
// Locations
// ---------------------------------------------------------------------------

class Contracts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get apartmentId => integer().references(Apartments, #id)();
  IntColumn get tenantId => integer().references(Tenants, #id)();
  DateTimeColumn get startDate => dateTime()();
  /// Fin de la période initiale du bail (le bail n'est jamais arrêté automatiquement).
  DateTimeColumn get plannedEndDate => dateTime().nullable()();

  /// Reconduction tacite : à l'échéance, le bail est prolongé d'une période de même durée.
  BoolColumn get tacitRenewal => boolean().withDefault(const Constant(true))();
  IntColumn get rent => integer()();
  IntColumn get deposit => integer().withDefault(const Constant(0))();
  IntColumn get depositPaid => integer().withDefault(const Constant(0))();

  /// Mois d'entrée : au prorata des jours (true) ou mois complet (false).
  BoolColumn get entryProrata => boolean().withDefault(const Constant(true))();

  /// 0 = actif, 1 = terminé.
  IntColumn get status => integer().withDefault(const Constant(0))();
  DateTimeColumn get exitDate => dateTime().nullable()();
  BoolColumn get exitProrata => boolean().nullable()();
  IntColumn get damagesAmount => integer().withDefault(const Constant(0))();
  TextColumn get exitNotes => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Services souscrits : quantité, franchise incluse (ex. 1 véhicule gratuit) et prix unitaire.
class ContractServices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contractId => integer().references(Contracts, #id)();
  IntColumn get serviceTypeId => integer().references(ServiceTypes, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  IntColumn get includedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get unitPrice => integer()();
}

/// Avantage accordé à un locataire sur une charge (compteur ou service).
/// mode : 0 = réduction en % (100 = exonération), 1 = unités gratuites par mois, 2 = montant fixe déduit par mois.
class ContractBenefits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contractId => integer().references(Contracts, #id)();
  IntColumn get utilityTypeId => integer().nullable().references(UtilityTypes, #id)();
  IntColumn get serviceTypeId => integer().nullable().references(ServiceTypes, #id)();
  IntColumn get mode => integer().withDefault(const Constant(0))();
  RealColumn get value => real().withDefault(const Constant(0))();
  IntColumn get amount => integer().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();
  IntColumn get fromPeriod => integer().nullable()();
  IntColumn get toPeriod => integer().nullable()();
}

/// Relevé d'index. kind : 0 = mensuel, 1 = entrée, 2 = sortie.
class Readings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get meterId => integer().references(Meters, #id)();
  IntColumn get contractId => integer().nullable().references(Contracts, #id)();
  IntColumn get period => integer().nullable()();
  IntColumn get kind => integer().withDefault(const Constant(0))();
  DateTimeColumn get date => dateTime()();
  RealColumn get value => real()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get note => text().nullable()();
}

// ---------------------------------------------------------------------------
// Facturation et paiements
// ---------------------------------------------------------------------------

/// kind : 0 = mensuelle, 1 = fin de contrat.
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  IntColumn get contractId => integer().references(Contracts, #id)();
  IntColumn get period => integer()();
  IntColumn get kind => integer().withDefault(const Constant(0))();
  DateTimeColumn get issueDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get total => integer()();
  TextColumn get notes => text().nullable()();
}

/// kind : 0 loyer, 1 compteur, 2 service, 3 dégâts, 4 ajustement, 5 avantage.
class InvoiceLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get kind => integer()();
  TextColumn get label => text()();
  TextColumn get details => text().nullable()();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  TextColumn get unit => text().nullable()();
  IntColumn get unitPrice => integer().withDefault(const Constant(0))();
  IntColumn get ht => integer()();
  IntColumn get vat => integer().withDefault(const Constant(0))();
  IntColumn get ttc => integer()();
  IntColumn get meterId => integer().nullable()();
  IntColumn get utilityTypeId => integer().nullable()();
  RealColumn get startIndex => real().nullable()();
  RealColumn get endIndex => real().nullable()();

  /// Données structurées (JSON) pour reconstruire le libellé dans la langue du document.
  TextColumn get meta => text().nullable()();
}

/// kind : 0 = paiement du locataire, 1 = caution imputée, 2 = remboursement au locataire,
/// 3 = caution reçue (complément de caution, hors compte locatif).
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contractId => integer().references(Contracts, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  IntColumn get kind => integer().withDefault(const Constant(0))();
  TextColumn get method => text().withDefault(const Constant('Espèces'))();
  TextColumn get reference => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get receiptNumber => text()();
}

/// État des lieux. kind : 0 = entrée, 1 = sortie.
class Inspections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contractId => integer().references(Contracts, #id)();
  IntColumn get kind => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
}

class InspectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get inspectionId => integer().references(Inspections, #id)();
  TextColumn get room => text()();
  TextColumn get element => text()();
  TextColumn get condition => text().withDefault(const Constant('Bon'))();
  TextColumn get comment => text().nullable()();
  IntColumn get cost => integer().withDefault(const Constant(0))();
  TextColumn get photoPath => text().nullable()();
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  Owners,
  Buildings,
  Apartments,
  Tenants,
  UtilityTypes,
  Meters,
  ServiceTypes,
  Contracts,
  ContractServices,
  ContractBenefits,
  Readings,
  Invoices,
  InvoiceLines,
  Payments,
  Inspections,
  InspectionItems,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static const fileName = 'myimmo.sqlite';

  static Future<File> file() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, fileName));
  }

  static Future<AppDatabase> open() async {
    final f = await file();
    return AppDatabase(NativeDatabase.createInBackground(f));
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seed();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(contractBenefits);
            await m.addColumn(contracts, contracts.tacitRenewal);
          }
          if (from < 3) {
            await m.addColumn(tenants, tenants.language);
            await m.addColumn(utilityTypes, utilityTypes.translations);
            await m.addColumn(serviceTypes, serviceTypes.translations);
            await m.addColumn(invoiceLines, invoiceLines.meta);
            await _translateSeeds();
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _seed() async {
    await into(utilityTypes).insert(UtilityTypesCompanion.insert(
      name: 'Eau',
      unit: 'm³',
      unitPrice: 50000,
      iconKey: const Value('water'),
      colorValue: const Value(0xFF1E88E5),
      translations: const Value('{"en":"Water"}'),
    ));
    await into(utilityTypes).insert(UtilityTypesCompanion.insert(
      name: 'Électricité',
      unit: 'kWh',
      unitPrice: 10000,
      iconKey: const Value('bolt'),
      colorValue: const Value(0xFFF9A825),
      translations: const Value('{"en":"Electricity"}'),
    ));
    await into(serviceTypes).insert(ServiceTypesCompanion.insert(
      name: 'Parking',
      unitPrice: 500000,
      unitLabel: const Value('véhicule'),
      translations: const Value('{"en":{"name":"Parking","unit":"vehicle"}}'),
    ));
  }

  /// Traductions des éléments créés par défaut (bases existantes).
  Future<void> _translateSeeds() async {
    const utilities = {'Eau': '{"en":"Water"}', 'Électricité': '{"en":"Electricity"}', 'Gaz': '{"en":"Gas"}'};
    for (final e in utilities.entries) {
      await (update(utilityTypes)..where((t) => t.name.equals(e.key) & t.translations.isNull()))
          .write(UtilityTypesCompanion(translations: Value(e.value)));
    }
    const services = {
      'Parking': '{"en":{"name":"Parking","unit":"vehicle"}}',
      'Gardiennage': '{"en":{"name":"Security guard","unit":"month"}}',
    };
    for (final e in services.entries) {
      await (update(serviceTypes)..where((t) => t.name.equals(e.key) & t.translations.isNull()))
          .write(ServiceTypesCompanion(translations: Value(e.value)));
    }
  }

  /// Copie cohérente de la base (utilisée par la sauvegarde).
  Future<void> exportTo(String path) async {
    final f = File(path);
    if (await f.exists()) await f.delete();
    await customStatement('VACUUM INTO ?', [path]);
  }
}
