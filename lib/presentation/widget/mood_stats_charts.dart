import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/services/mood_stats.dart';

class MoodTrendChart extends StatelessWidget {
  const MoodTrendChart({
    super.key,
    required this.points,
    required this.range,
  });

  final List<MoodSeriesPoint> points;
  final MoodDateRange range;

  static final Color energyColor = Colors.orange.shade300;
  static final Color pleasantnessColor = Colors.purple.shade300;

  @override
  Widget build(BuildContext context) {
    final String locale = Localizations.localeOf(context).languageCode;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (points.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Нет записей за этот период',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 220,
          child: CustomPaint(
            painter: _MoodTrendPainter(
              points: points,
              range: range,
              energyColor: energyColor,
              pleasantnessColor: pleasantnessColor,
              gridColor: scheme.outlineVariant.withValues(alpha: 0.5),
              labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              locale: locale,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _Legend(color: energyColor, label: 'энергия'),
            const SizedBox(width: 20),
            _Legend(color: pleasantnessColor, label: 'приятность'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 14,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _MoodTrendPainter extends CustomPainter {
  _MoodTrendPainter({
    required this.points,
    required this.range,
    required this.energyColor,
    required this.pleasantnessColor,
    required this.gridColor,
    required this.labelStyle,
    required this.locale,
  });

  final List<MoodSeriesPoint> points;
  final MoodDateRange range;
  final Color energyColor;
  final Color pleasantnessColor;
  final Color gridColor;
  final TextStyle labelStyle;
  final String locale;

  static const double _left = 28;
  static const double _right = 8;
  static const double _top = 12;
  static const double _bottom = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect plot = Rect.fromLTRB(
      _left,
      _top,
      size.width - _right,
      size.height - _bottom,
    );

    final DateTime start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final DateTime end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    );
    final int spanDays = math.max(1, end.difference(start).inDays);

    double xFor(DateTime d) {
      final int day = DateTime(d.year, d.month, d.day).difference(start).inDays;
      return plot.left + (day / spanDays) * plot.width;
    }

    double yFor(double value) {
      return plot.bottom - (value.clamp(0, 100) / 100) * plot.height;
    }

    final Paint gridPaint =
        Paint()
          ..color = gridColor
          ..strokeWidth = 1;

    for (final int tick in <int>[0, 25, 50, 75, 100]) {
      final double y = yFor(tick.toDouble());
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final ui.ParagraphBuilder pb =
          ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.right))
            ..pushStyle(
              ui.TextStyle(
                color: labelStyle.color,
                fontSize: labelStyle.fontSize,
                fontFamily: labelStyle.fontFamily,
              ),
            )
            ..addText('$tick');
      final ui.Paragraph paragraph =
          pb.build()..layout(const ui.ParagraphConstraints(width: _left - 4));
      canvas.drawParagraph(paragraph, Offset(0, y - paragraph.height / 2));
    }

    final List<Offset> energyPts = <Offset>[
      for (final MoodSeriesPoint p in points)
        Offset(xFor(p.date), yFor(p.energy)),
    ];
    final List<Offset> pleasantPts = <Offset>[
      for (final MoodSeriesPoint p in points)
        Offset(xFor(p.date), yFor(p.pleasantness)),
    ];

    _drawCurve(canvas, energyPts, energyColor);
    _drawCurve(canvas, pleasantPts, pleasantnessColor);

    final Paint dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < points.length; i++) {
      dotPaint.color = energyColor;
      canvas.drawCircle(energyPts[i], 3.2, dotPaint);
      dotPaint.color = pleasantnessColor;
      canvas.drawCircle(pleasantPts[i], 3.2, dotPaint);
    }

    final DateFormat fmt = _labelFormat(spanDays);
    final List<DateTime> xLabels = _xLabels(start, end, spanDays);
    for (final DateTime d in xLabels) {
      final double x = xFor(d);
      final String text = fmt.format(d);
      final ui.ParagraphBuilder pb =
          ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.center))
            ..pushStyle(
              ui.TextStyle(
                color: labelStyle.color,
                fontSize: labelStyle.fontSize,
                fontFamily: labelStyle.fontFamily,
              ),
            )
            ..addText(text);
      final ui.Paragraph paragraph =
          pb.build()..layout(const ui.ParagraphConstraints(width: 48));
      canvas.drawParagraph(paragraph, Offset(x - 24, plot.bottom + 6));
    }
  }

  DateFormat _labelFormat(int spanDays) {
    if (spanDays <= 14) {
      return DateFormat('E', locale);
    }
    if (spanDays <= 45) {
      return DateFormat('d MMM', locale);
    }
    return DateFormat('MMM', locale);
  }

  List<DateTime> _xLabels(DateTime start, DateTime end, int spanDays) {
    if (spanDays <= 7) {
      return List<DateTime>.generate(
        spanDays + 1,
        (int i) => start.add(Duration(days: i)),
      );
    }
    if (spanDays <= 45) {
      final int step = (spanDays / 5).ceil().clamp(1, 14);
      final List<DateTime> labels = <DateTime>[];
      for (int i = 0; i <= spanDays; i += step) {
        labels.add(start.add(Duration(days: i)));
      }
      if (labels.last != end) {
        labels.add(end);
      }
      return labels;
    }
    final List<DateTime> months = <DateTime>[];
    DateTime cursor = DateTime(start.year, start.month);
    while (!cursor.isAfter(end)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return months;
  }

  void _drawCurve(Canvas canvas, List<Offset> pts, Color color) {
    if (pts.isEmpty) {
      return;
    }
    final Path path = Path()..moveTo(pts.first.dx, pts.first.dy);
    if (pts.length == 2) {
      path.lineTo(pts[1].dx, pts[1].dy);
    } else if (pts.length > 2) {
      for (int i = 0; i < pts.length - 1; i++) {
        final Offset p0 = pts[i];
        final Offset p1 = pts[i + 1];
        final double dx = (p1.dx - p0.dx) / 3;
        path.cubicTo(p0.dx + dx, p0.dy, p1.dx - dx, p1.dy, p1.dx, p1.dy);
      }
    }
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MoodTrendPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.range != range ||
        oldDelegate.energyColor != energyColor ||
        oldDelegate.pleasantnessColor != pleasantnessColor;
  }
}
