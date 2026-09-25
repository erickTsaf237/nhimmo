import 'package:flutter/material.dart';

import '../core/i18n.dart';

import 'dashboard/dashboard_page.dart';
import 'finance/finance_page.dart';
import 'properties/properties_page.dart';
import 'readings/readings_page.dart';
import 'rentals/rentals_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static _HomeShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeShellState>();

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          DashboardPage(),
          PropertiesPage(),
          RentalsPage(),
          ReadingsPage(),
          FinancePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: goTo,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.space_dashboard_outlined), selectedIcon: const Icon(Icons.space_dashboard_rounded), label: context.t.navHome),
          NavigationDestination(icon: const Icon(Icons.apartment_outlined), selectedIcon: const Icon(Icons.apartment_rounded), label: context.t.navProperties),
          NavigationDestination(icon: const Icon(Icons.people_outline_rounded), selectedIcon: const Icon(Icons.people_rounded), label: context.t.navRentals),
          NavigationDestination(icon: const Icon(Icons.speed_outlined), selectedIcon: const Icon(Icons.speed_rounded), label: context.t.navReadings),
          NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), selectedIcon: const Icon(Icons.receipt_long_rounded), label: context.t.navFinance),
        ],
      ),
    );
  }
}
