import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'contract_detail_page.dart';
import 'contract_form.dart';
import 'tenant_form.dart';
import '../../core/i18n.dart';

class RentalsPage extends StatelessWidget {
  const RentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.t.navRentals),
            bottom: TabBar(tabs: [Tab(text: context.t.tabOngoing), Tab(text: context.t.tabEnded), Tab(text: context.t.tenants)]),
          ),
          body: const TabBarView(children: [
            _ContractsTab(status: 0),
            _ContractsTab(status: 1),
            _TenantsTab(),
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              final i = DefaultTabController.of(context).index;
              push(context, i == 2 ? const TenantForm() : const ContractForm());
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(context.t.newItem),
          ),
        );
      }),
    );
  }
}

class _ContractsTab extends StatelessWidget {
  final int status;
  const _ContractsTab({required this.status});

  @override
  Widget build(BuildContext context) {
    return DbBuilder<List<ContractView>>(
      load: () => Repo.contracts(status: status),
      builder: (context, list) {
        if (list.isEmpty) {
          return EmptyState(
            icon: status == 0 ? Icons.key_rounded : Icons.history_rounded,
            title: status == 0 ? context.t.noActiveLease : context.t.noEndedLease,
            message: status == 0 ? context.t.noActiveLeaseHelp : null,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => ContractTile(list[i]),
        );
      },
    );
  }
}

class ContractTile extends StatelessWidget {
  final ContractView cv;
  const ContractTile(this.cv, {super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final b = cv.balance;
    return AppCard(
      onTap: () => push(context, ContractDetailPage(cv.c.id)),
      child: Row(children: [
        Initials(cv.tenant.fullName, color: cv.active ? AppColors.primary : cs.outline),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cv.tenant.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5)),
            const SizedBox(height: 2),
            Text(cv.place, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            Text(cv.active ? context.t.sinceDate(Dates.d(cv.c.startDate)) : context.t.leftOn(Dates.d(cv.c.exitDate)),
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(Money.compact(cv.c.rent), style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          if (cv.active && cv.c.depositPaid < cv.c.deposit)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: StatusChip(context.t.depositIncompleteShort, AppColors.warning, icon: Icons.savings_rounded),
            ),
          if (b > 0)
            StatusChip(context.t.dueAmount(Money.compact(b)), AppColors.danger)
          else if (b < 0)
            StatusChip(cv.active ? context.t.advanceAmount(Money.compact(-b)) : context.t.toRefund, AppColors.info)
          else
            StatusChip(context.t.upToDate, AppColors.success),
        ]),
      ]),
    );
  }
}

class _TenantsTab extends StatelessWidget {
  const _TenantsTab();

  @override
  Widget build(BuildContext context) {
    return DbBuilder<(List<Tenant>, List<ContractView>)>(
      load: () async => (
        await (App.db.select(App.db.tenants)..orderBy([(t) => OrderingTerm.asc(t.fullName)])).get(),
        await Repo.contracts(status: 0),
      ),
      builder: (context, data) {
        final (tenants, active) = data;
        if (tenants.isEmpty) {
          return EmptyState(icon: Icons.people_rounded, title: context.t.noTenant);
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: tenants.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final t = tenants[i];
            final c = active.where((c) => c.tenant.id == t.id).firstOrNull;
            return AppCard(
              onTap: () => push(context, TenantForm(tenant: t)),
              child: Row(children: [
                Initials(t.fullName),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(t.phone ?? t.email ?? '—', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                  ]),
                ),
                if (c != null) StatusChip(c.apt.name, AppColors.success, icon: Icons.home_rounded),
              ]),
            );
          },
        );
      },
    );
  }
}
