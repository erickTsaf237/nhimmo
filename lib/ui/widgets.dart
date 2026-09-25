import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../core/dates.dart';
import '../core/i18n.dart';
import '../core/money.dart';
import '../services/app_state.dart';
import '../services/photo_service.dart';
import 'theme.dart';

// ---------------------------------------------------------------------------
// Chargement réactif : recharge dès qu'une table change.
// ---------------------------------------------------------------------------

class DbBuilder<T> extends StatefulWidget {
  final Future<T> Function() load;
  final Widget Function(BuildContext context, T data) builder;
  final List<Object?> deps;

  const DbBuilder({super.key, required this.load, required this.builder, this.deps = const []});

  @override
  State<DbBuilder<T>> createState() => _DbBuilderState<T>();
}

class _DbBuilderState<T> extends State<DbBuilder<T>> {
  T? _data;
  Object? _error;
  StreamSubscription? _sub;
  Timer? _debounce;
  int _token = 0;

  @override
  void initState() {
    super.initState();
    _reload();
    _sub = App.db.tableUpdates().listen((_) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 120), _reload);
    });
  }

  @override
  void didUpdateWidget(covariant DbBuilder<T> old) {
    super.didUpdateWidget(old);
    if (!_sameDeps(old.deps, widget.deps)) _reload();
  }

  bool _sameDeps(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _reload() async {
    final t = ++_token;
    try {
      final d = await widget.load();
      if (mounted && t == _token) {
        setState(() {
          _data = d;
          _error = null;
        });
      }
    } catch (e, st) {
      debugPrint('DbBuilder: $e\n$st');
      if (mounted && t == _token) setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && _data == null) {
      return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(context.t.errorWith('$_error'))));
    }
    if (_data == null) return const Center(child: CircularProgressIndicator());
    return widget.builder(context, _data as T);
  }
}

// ---------------------------------------------------------------------------
// Éléments visuels
// ---------------------------------------------------------------------------

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  const EmptyState({super.key, required this.icon, required this.title, this.message, this.action});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: cs.primary.withValues(alpha: .08), shape: BoxShape.circle),
            child: Icon(icon, size: 44, color: cs.primary),
          ),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(message!, textAlign: TextAlign.center, style: TextStyle(color: cs.onSurfaceVariant)),
          ],
          if (action != null) ...[const SizedBox(height: 18), action!],
        ]),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
        child: Row(children: [
          Expanded(
            child: Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ),
          if (trailing != null) trailing!,
        ]),
      );
}

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  const AppCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16), this.color});

  @override
  Widget build(BuildContext context) => Card(
        color: color,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      );
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? caption;
  final VoidCallback? onTap;
  const StatCard({super.key, required this.label, required this.value, required this.icon, required this.color, this.caption, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 12),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -.3)),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (caption != null)
          Text(caption!, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const StatusChip(this.label, this.color, {super.key, this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 13, color: color), const SizedBox(width: 4)],
          Text(label, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
        ]),
      );
}

class Initials extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  const Initials(this.name, {super.key, this.size = 44, this.color});

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    final txt = parts.isEmpty
        ? '?'
        : (parts.first[0] + (parts.length > 1 ? parts.last[0] : '')).toUpperCase();
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.withValues(alpha: .14), borderRadius: BorderRadius.circular(size * .32)),
      child: Text(txt, style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: size * .36)),
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const IconBadge(this.icon, this.color, {super.key, this.size = 44});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color.withValues(alpha: .13), borderRadius: BorderRadius.circular(size * .32)),
        child: Icon(icon, color: color, size: size * .5),
      );
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;
  final Color? color;
  const InfoRow(this.label, this.value, {super.key, this.strong = false, this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: strong ? FontWeight.w800 : FontWeight.w600, color: color, fontSize: strong ? 16 : null)),
          ),
        ]),
      );
}

class MonthSwitcher extends StatelessWidget {
  final int period;
  final ValueChanged<int> onChanged;
  const MonthSwitcher({super.key, required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: cs.primary.withValues(alpha: .08), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        IconButton(onPressed: () => onChanged(Period.add(period, -1)), icon: const Icon(Icons.chevron_left_rounded)),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final p = await pickMonth(context, period);
              if (p != null) onChanged(p);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.calendar_month_rounded, size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Text(Period.label(period), style: TextStyle(fontWeight: FontWeight.w700, color: cs.primary)),
              ]),
            ),
          ),
        ),
        IconButton(onPressed: () => onChanged(Period.add(period, 1)), icon: const Icon(Icons.chevron_right_rounded)),
      ]),
    );
  }
}

Future<int?> pickMonth(BuildContext context, int initial) {
  var year = Period.year(initial);
  return showDialog<int>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx, set) {
      return AlertDialog(
        title: Row(children: [
          IconButton(onPressed: () => set(() => year--), icon: const Icon(Icons.chevron_left)),
          Expanded(child: Text('$year', textAlign: TextAlign.center)),
          IconButton(onPressed: () => set(() => year++), icon: const Icon(Icons.chevron_right)),
        ]),
        content: SizedBox(
          width: 300,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(12, (i) {
              final p = year * 100 + i + 1;
              final sel = p == initial;
              final label = Period.short(p).split(' ').first;
              return sel
                  ? FilledButton(onPressed: () => Navigator.pop(ctx, p), style: FilledButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero), child: Text(label))
                  : OutlinedButton(onPressed: () => Navigator.pop(ctx, p), style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero), child: Text(label));
            }),
          ),
        ),
      );
    }),
  );
}

// ---------------------------------------------------------------------------
// Formulaires
// ---------------------------------------------------------------------------

class Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool required;
  final TextInputType? keyboard;
  final int maxLines;
  final String? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const Field(this.controller, this.label,
      {super.key, this.hint, this.icon, this.required = false, this.keyboard, this.maxLines = 1, this.suffix, this.validator, this.onChanged, this.autofocus = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          autofocus: autofocus,
          keyboardType: keyboard,
          maxLines: maxLines,
          onChanged: onChanged,
          textCapitalization: keyboard == null ? TextCapitalization.sentences : TextCapitalization.none,
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            hintText: hint,
            prefixIcon: icon == null ? null : Icon(icon),
            suffixText: suffix,
          ),
          validator: validator ??
              (required ? (v) => (v == null || v.trim().isEmpty) ? context.t.requiredField : null : null),
        ),
      );
}

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final ValueChanged<String>? onChanged;
  final String? helper;
  const AmountField(this.controller, this.label, {super.key, this.required = true, this.onChanged, this.helper});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.\s-]'))],
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            prefixIcon: const Icon(Icons.payments_outlined),
            suffixText: Money.currency.symbol,
            helperText: helper,
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return required ? context.t.amountRequired : null;
            return Money.parse(v) == null ? context.t.amountInvalid : null;
          },
        ),
      );
}

class DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool clearable;
  final VoidCallback? onClear;
  const DateField({super.key, required this.label, required this.value, required this.onChanged, this.clearable = false, this.onClear});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (d != null) onChanged(d);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: const Icon(Icons.event_outlined),
              suffixIcon: clearable && value != null
                  ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
                  : null,
            ),
            child: Text(value == null ? '—' : Dates.long(value)),
          ),
        ),
      );
}

class SwitchRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SwitchRow({super.key, required this.title, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          child: SwitchListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: subtitle == null ? null : Text(subtitle!),
            value: value,
            onChanged: onChanged,
          ),
        ),
      );
}

class FormPage extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final Future<void> Function() onSave;
  final String? saveLabel;
  final List<Widget>? actions;

  const FormPage({super.key, required this.title, required this.formKey, required this.children, required this.onSave, this.saveLabel, this.actions});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
        body: Form(
          key: formKey,
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), children: children),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: _SaveButton(label: saveLabel ?? context.t.save, onSave: () async {
              if (!formKey.currentState!.validate()) return;
              await onSave();
            }),
          ),
        ),
      );
}

class _SaveButton extends StatefulWidget {
  final String label;
  final Future<void> Function() onSave;
  const _SaveButton({required this.label, required this.onSave});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: _busy
            ? null
            : () async {
                setState(() => _busy = true);
                try {
                  await widget.onSave();
                } catch (e) {
                  if (context.mounted) toast(context, context.t.errorWith('$e'), error: true);
                } finally {
                  if (mounted) setState(() => _busy = false);
                }
              },
        icon: _busy
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.check_rounded),
        label: Text(widget.label),
      );
}

// ---------------------------------------------------------------------------
// Photos
// ---------------------------------------------------------------------------

class PhotoThumb extends StatelessWidget {
  final String? name;
  final double size;
  const PhotoThumb(this.name, {super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    final f = PhotoService.file(name);
    if (f == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
          body: Center(child: InteractiveViewer(child: Image.file(f))),
        ),
      )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(f, width: size, height: size, fit: BoxFit.cover, cacheWidth: (size * 3).toInt()),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Utilitaires
// ---------------------------------------------------------------------------

void toast(BuildContext context, String msg, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? AppColors.danger : null,
    ));
}

Future<bool> confirm(BuildContext context, String title, String message,
    {String? ok, bool danger = false}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(ctx.t.cancel)),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: AppColors.danger) : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ok ?? ctx.t.confirm),
        ),
      ],
    ),
  );
  return r ?? false;
}

Future<void> shareFile(File f, {String? text}) =>
    SharePlus.instance.share(ShareParams(files: [XFile(f.path)], text: text));

/// Aperçu d'un PDF avec impression et partage.
Future<void> openPdf(BuildContext context, String title, String fileName, Future<Uint8List> Function() build) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => PdfViewerPage(title, fileName, build)));
}

class PdfViewerPage extends StatelessWidget {
  final String title;
  final String fileName;
  final Future<Uint8List> Function() loader;
  const PdfViewerPage(this.title, this.fileName, this.loader, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: PdfPreview(
          build: (_) => loader(),
          pdfFileName: fileName,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          loadingWidget: const CircularProgressIndicator(),
        ),
      );
}

Future<T?> push<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));

String? emptyToNull(String s) => s.trim().isEmpty ? null : s.trim();

/// Icônes proposées pour les types de compteurs.
const utilityIcons = <String, IconData>{
  'water': Icons.water_drop_rounded,
  'bolt': Icons.bolt_rounded,
  'gas': Icons.local_fire_department_rounded,
  'heat': Icons.thermostat_rounded,
  'wifi': Icons.wifi_rounded,
  'other': Icons.speed_rounded,
};

IconData utilityIcon(String key) => utilityIcons[key] ?? Icons.speed_rounded;

/// Grille de cartes statistiques à hauteur fixe (robuste aux tailles de police).
class StatGrid extends StatelessWidget {
  final List<Widget> children;
  const StatGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 128 + 36 * scale,
      ),
      children: children,
    );
  }
}

/// Fenêtre du bas qui laisse toujours ses boutons au-dessus de la barre de navigation
/// Android (boutons retour/accueil) et du clavier.
Future<T?> showSheet<T>({required BuildContext context, required WidgetBuilder builder, bool isScrollControlled = true}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: (ctx) => SafeArea(top: false, child: builder(ctx)),
  );
}
