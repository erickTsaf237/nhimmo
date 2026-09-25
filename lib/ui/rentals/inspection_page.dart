import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/money.dart';
import '../../data/database.dart';
import '../../services/app_state.dart';
import '../../services/photo_service.dart';
import '../theme.dart';
import '../widgets.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

/// Valeurs enregistrées en français (clés stables), affichées traduites via [Labels].
const _rooms = Labels.roomKeys;
const _conditions = Labels.conditionKeys;

Color conditionColor(String c) => switch (c) {
      'Neuf' || 'Bon' => AppColors.success,
      'Usé' => AppColors.warning,
      _ => AppColors.danger,
    };

/// Récupère ou crée l'état des lieux d'un contrat.
Future<Inspection> ensureInspection(int contractId, int kind) async {
  final db = App.db;
  final existing = await (db.select(db.inspections)
        ..where((i) => i.contractId.equals(contractId) & i.kind.equals(kind))
        ..limit(1))
      .getSingleOrNull();
  if (existing != null) return existing;
  final id = await db.into(db.inspections).insert(
      InspectionsCompanion.insert(contractId: contractId, kind: kind, date: DateTime.now()));
  return (db.select(db.inspections)..where((i) => i.id.equals(id))).getSingle();
}

Future<int> inspectionDamages(int contractId) async {
  final db = App.db;
  final insp = await (db.select(db.inspections)
        ..where((i) => i.contractId.equals(contractId) & i.kind.equals(1))
        ..limit(1))
      .getSingleOrNull();
  if (insp == null) return 0;
  final items = await (db.select(db.inspectionItems)..where((x) => x.inspectionId.equals(insp.id))).get();
  return items.fold<int>(0, (s, i) => s + i.cost);
}

/// État des lieux (entrée : facultatif ; sortie : dégâts chiffrés).
class InspectionPage extends StatelessWidget {
  final int contractId;
  final int kind;
  const InspectionPage({super.key, required this.contractId, required this.kind});

  bool get isExit => kind == 1;

  @override
  Widget build(BuildContext context) {
    final db = App.db;
    return DbBuilder<(Inspection, List<InspectionItem>)>(
      load: () async {
        final insp = await ensureInspection(contractId, kind);
        final items = await (db.select(db.inspectionItems)
              ..where((x) => x.inspectionId.equals(insp.id))
              ..orderBy([(x) => OrderingTerm.asc(x.room), (x) => OrderingTerm.asc(x.id)]))
            .get();
        return (insp, items);
      },
      builder: (context, data) {
        final (insp, items) = data;
        final total = items.fold<int>(0, (s, i) => s + i.cost);
        final rooms = items.map((i) => i.room).toSet().toList();
        return Scaffold(
          appBar: AppBar(title: Text(isExit ? context.t.exitInspection : context.t.entryInspection)),
          body: items.isEmpty
              ? EmptyState(
                  icon: Icons.fact_check_rounded,
                  title: context.t.noItem,
                  message: isExit
                      ? context.t.exitInspectionHelp
                      : context.t.entryInspectionHelp,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                  children: [
                    if (isExit)
                      AppCard(
                        color: AppColors.danger.withValues(alpha: .08),
                        child: InfoRow(context.t.damagesTotal, Money.format(total), strong: true, color: AppColors.danger),
                      ),
                    for (final r in rooms) ...[
                      SectionHeader(Labels.room(context.t, r)),
                      for (final it in items.where((i) => i.room == r))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppCard(
                            onTap: () => _edit(context, insp.id, it),
                            child: Row(children: [
                              if (it.photoPath != null) ...[PhotoThumb(it.photoPath, size: 48), const SizedBox(width: 12)],
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(it.element, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  if (it.comment != null) Text(it.comment!, style: const TextStyle(fontSize: 12.5)),
                                  const SizedBox(height: 4),
                                  StatusChip(Labels.condition(context.t, it.condition), conditionColor(it.condition)),
                                ]),
                              ),
                              if (it.cost > 0) Text(Money.format(it.cost), style: const TextStyle(fontWeight: FontWeight.w800)),
                            ]),
                          ),
                        ),
                    ],
                  ],
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _edit(context, insp.id, null),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.t.item),
          ),
        );
      },
    );
  }

  Future<void> _edit(BuildContext context, int inspectionId, InspectionItem? it) async {
    final db = App.db;
    // Pièces déjà utilisées dans cet état des lieux (et, en sortie, celles de l'entrée).
    final used = await (db.select(db.inspectionItems)..where((x) => x.inspectionId.equals(inspectionId))).get();
    var entryItems = <InspectionItem>[];
    if (isExit) {
      final entry = await (db.select(db.inspections)
            ..where((i) => i.contractId.equals(contractId) & i.kind.equals(0))
            ..limit(1))
          .getSingleOrNull();
      if (entry != null) {
        entryItems = await (db.select(db.inspectionItems)..where((x) => x.inspectionId.equals(entry.id))).get();
      }
    }
    final rooms = <String>{..._rooms, ...used.map((u) => u.room), ...entryItems.map((u) => u.room)}.toList();
    String? room = it?.room;
    if (!context.mounted) return;
    final element = TextEditingController(text: it?.element);
    final comment = TextEditingController(text: it?.comment);
    final cost = TextEditingController(text: it == null || it.cost == 0 ? '' : Money.toInput(it.cost));
    var condition = it?.condition ?? (isExit ? 'Dégradé' : 'Bon');
    var photo = it?.photoPath;
    final key = GlobalKey<FormState>();

    await showSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(it == null ? ctx.t.newItemInspection : ctx.t.edit, style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(ctx.t.whichRoom, style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                FormField<String>(
                  validator: (_) => room == null ? ctx.t.chooseRoom : null,
                  builder: (f) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final r in rooms)
                        ChoiceChip(label: Text(Labels.room(ctx.t, r)), selected: room == r, onSelected: (_) => set(() => room = r)),
                      ActionChip(
                        avatar: const Icon(Icons.add_rounded, size: 18),
                        label: Text(ctx.t.otherRoom),
                        onPressed: () async {
                          final name = await _askRoom(ctx);
                          if (name != null) {
                            set(() {
                              if (!rooms.contains(name)) rooms.add(name);
                              room = name;
                            });
                          }
                        },
                      ),
                    ]),
                    if (f.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(f.errorText!, style: TextStyle(color: Theme.of(ctx).colorScheme.error, fontSize: 12)),
                      ),
                  ]),
                ),
                const SizedBox(height: 16),
                Text(ctx.t.whichItem, style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                if (entryItems.any((e) => e.room == room))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final e in entryItems.where((e) => e.room == room))
                        ActionChip(
                          avatar: const Icon(Icons.history_rounded, size: 16),
                          label: Text(ctx.t.entryWas(e.element, Labels.condition(ctx.t, e.condition))),
                          onPressed: () => set(() => element.text = e.element),
                        ),
                    ]),
                  ),
                Field(element, ctx.t.itemName, required: true, icon: Icons.label_outline,
                    hint: ctx.t.itemNameHint),
                Text(ctx.t.conditionNoted, style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final c in _conditions)
                    ChoiceChip(
                      label: Text(Labels.condition(ctx.t, c)),
                      selected: condition == c,
                      selectedColor: conditionColor(c).withValues(alpha: .2),
                      onSelected: (_) => set(() => condition = c),
                    ),
                ]),
                const SizedBox(height: 14),
                Field(comment, ctx.t.comment, maxLines: 2),
                if (isExit) AmountField(cost, ctx.t.repairCost, required: false),
                Row(children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final p = await PhotoService.take();
                      if (p != null) set(() => photo = p);
                    },
                    icon: const Icon(Icons.photo_camera_rounded),
                    label: Text(photo == null ? ctx.t.photo : ctx.t.retake),
                  ),
                  const SizedBox(width: 10),
                  if (photo != null) PhotoThumb(photo, size: 50),
                  const Spacer(),
                  if (it != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                      onPressed: () async {
                        await (db.delete(db.inspectionItems)..where((x) => x.id.equals(it.id))).go();
                        await PhotoService.delete(it.photoPath);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                ]),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    if (!key.currentState!.validate()) return;
                    final c = InspectionItemsCompanion(
                      inspectionId: Value(inspectionId),
                      room: Value(room!),
                      element: Value(element.text.trim()),
                      condition: Value(condition),
                      comment: Value(emptyToNull(comment.text)),
                      cost: Value(Money.parse(cost.text) ?? 0),
                      photoPath: Value(photo),
                    );
                    if (it == null) {
                      await db.into(db.inspectionItems).insert(c);
                    } else {
                      await (db.update(db.inspectionItems)..where((x) => x.id.equals(it.id))).write(c);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: Text(ctx.t.save),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> _askRoom(BuildContext context) {
  final ctrl = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.t.newRoom),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: ctx.t.newRoomHint),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.t.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim().isEmpty ? null : ctrl.text.trim()),
          child: Text(ctx.t.add),
        ),
      ],
    ),
  );
}
