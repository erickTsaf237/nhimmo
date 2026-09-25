import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartSeries {
  final String name;
  final Color color;
  final List<double> values;
  const ChartSeries(this.name, this.color, this.values);
}

/// Histogramme groupé simple, lisible en clair et en sombre.
class GroupedBarChart extends StatelessWidget {
  final List<String> labels;
  final List<ChartSeries> series;
  final String Function(double) format;
  final double height;

  const GroupedBarChart({super.key, required this.labels, required this.series, required this.format, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxV = series.expand((s) => s.values).fold<double>(0, math.max);
    final top = maxV <= 0 ? 1.0 : maxV * 1.15;
    final barWidth = series.length > 1 ? 9.0 : 16.0;
    return Column(children: [
      if (series.length > 1)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Wrap(spacing: 16, children: [
            for (final s in series)
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 6),
                Text(s.name, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
              ]),
          ]),
        ),
      SizedBox(
        height: height,
        child: BarChart(
          BarChartData(
            maxY: top,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: top / 4,
              getDrawingHorizontalLine: (_) => FlLine(color: cs.outlineVariant.withValues(alpha: .35), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  interval: top / 4,
                  getTitlesWidget: (v, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(v == 0 ? '0' : format(v), style: TextStyle(fontSize: 9.5, color: cs.onSurfaceVariant)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 26,
                  getTitlesWidget: (v, meta) {
                    final i = v.toInt();
                    if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(labels[i], style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant)),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => cs.inverseSurface,
                getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                  '${series[ri].name}\n${format(rod.toY)}',
                  TextStyle(color: cs.onInverseSurface, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < labels.length; i++)
                BarChartGroupData(
                  x: i,
                  barsSpace: 3,
                  barRods: [
                    for (final s in series)
                      BarChartRodData(
                        toY: s.values[i],
                        color: s.color,
                        width: barWidth,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    ]);
  }
}
