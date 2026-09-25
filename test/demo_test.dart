import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myimmo/core/money.dart';
import 'package:myimmo/data/database.dart';
import 'package:myimmo/data/repo.dart';
import 'package:myimmo/services/app_state.dart';
import 'package:myimmo/services/demo_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Données de démonstration réalistes', () async {
    await initializeDateFormatting('fr_FR');
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    App.db = AppDatabase(NativeDatabase.memory());
    await App.settings.load();
    await DemoService.load();

    final apts = await Repo.apartments();
    expect(apts.length, 8);
    expect(apts.where((a) => a.occupied).length, 6);
    final contracts = await Repo.contracts();
    expect(contracts.length, 7);
    final invoices = await Repo.invoices();
    expect(invoices.length, greaterThan(30));

    for (final c in contracts) {
      // ignore: avoid_print
      print('${c.tenant.fullName.padRight(16)} ${c.active ? 'actif  ' : 'terminé'} solde ${Money.format(c.balance)}');
    }
    final herve = contracts.firstWhere((c) => c.tenant.fullName == 'Hervé Nkoulou');
    expect(herve.active, isFalse);
    expect(herve.balance, 0); // remboursé
    expect(contracts.firstWhere((c) => c.tenant.fullName == 'Ibrahim Moussa').balance, greaterThan(0));
    expect(contracts.firstWhere((c) => c.tenant.fullName == 'Laure Abena').balance, greaterThan(0));
    expect(contracts.firstWhere((c) => c.tenant.fullName == 'Brice Tchoupo').balance, lessThan(0));
    expect(contracts.firstWhere((c) => c.tenant.fullName == 'Aïcha Nguema').balance, 0);
    final inv = invoices.first;
    // ignore: avoid_print
    for (final l in await Repo.lines(inv.inv.id)) print('  ${l.label}: ${Money.format(l.ttc)}  ${l.details ?? ''}');
  });
}
