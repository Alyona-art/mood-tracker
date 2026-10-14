import 'dart:math' as math;
import 'dart:ui';

/// Procedural uneven 9-point mood star.
///
/// Defaults from energy / pleasantness (0–100):
/// - higher pleasantness → more outer-corner rounding (stays a star)
/// - higher energy → deeper rays and more twist
/// - [variance] → per-ray radius jitter within a safe range
class MoodShapeParams {
  const MoodShapeParams({
    required this.cornerRounding,
    required this.rayDepth,
    required this.twist,
    this.variance = 0.35,
    this.seed = 0,
    this.points = 9,
  });

  factory MoodShapeParams.fromMood({
    required int energyPercent,
    required int pleasantnessPercent,
    double? cornerRoundingOverride,
    double? rayDepthOverride,
    double? twistOverride,
    double? varianceOverride,
    int? seed,
  }) {
    final double e = energyPercent.clamp(0, 100) / 100.0;
    final double p = pleasantnessPercent.clamp(0, 100) / 100.0;

    return MoodShapeParams(
      // p=0 → sharp tips; p=1 → soft outer corners (still a star)
      cornerRounding: cornerRoundingOverride ?? (p * 0.9),
      rayDepth: rayDepthOverride ?? (0.22 + e * 0.68),
      twist: twistOverride ?? (e * 0.5),
      variance: varianceOverride ?? (0.2 + e * 0.35),
      seed: seed ?? (energyPercent * 9176 + pleasantnessPercent * 433),
    );
  }

  /// 0 = sharp tips, 1 = soft outer tips (inner valleys stay sharper).
  final double cornerRounding;

  /// 0 = shallow rays, 1 = deep star rays.
  final double rayDepth;

  /// 0 = symmetric, 1 = strong swirl.
  final double twist;

  /// 0 = even rays, 1 = stronger per-ray radius differences (still bounded).
  final double variance;

  /// Stable seed so the same mood looks the same across rebuilds.
  final int seed;

  final int points;

  MoodShapeParams copyWith({
    double? cornerRounding,
    double? rayDepth,
    double? twist,
    double? variance,
    int? seed,
    int? points,
  }) {
    return MoodShapeParams(
      cornerRounding: cornerRounding ?? this.cornerRounding,
      rayDepth: rayDepth ?? this.rayDepth,
      twist: twist ?? this.twist,
      variance: variance ?? this.variance,
      seed: seed ?? this.seed,
      points: points ?? this.points,
    );
  }
}

class MoodShapeGeometry {
  MoodShapeGeometry._();

  /// [starAmount] 0 → circle, 1 → full star (used for empty-day morph).
  static Path buildPath(
    Size size,
    MoodShapeParams params, {
    double starAmount = 1,
  }) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2 * 0.9;
    final double amount = starAmount.clamp(0.0, 1.0);

    if (amount < 0.02) {
      return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    }

    final double rounding = params.cornerRounding.clamp(0.0, 1.0);
    final double depth = params.rayDepth.clamp(0.0, 1.0) * amount;
    final double twist = params.twist.clamp(0.0, 1.0) * amount;
    final double variance = params.variance.clamp(0.0, 1.0) * amount;
    final int n = params.points.clamp(3, 12);

    // Soften rays a bit with rounding; low [amount] approaches a circle.
    final double minDepth = 0.18 * amount;
    final double effectiveDepth = (depth * (1.0 - rounding * 0.28)).clamp(
      minDepth,
      1.0,
    );
    final double innerRatio = (1.0 - effectiveDepth * 0.72).clamp(0.28, 0.82);
    final double baseOuter = radius;
    final double baseInner = radius * innerRatio;

    // Bounded per-ray scale: about ±8% … ±28% depending on variance.
    final double spread = 0.08 + variance * 0.2;
    final math.Random rng = math.Random(params.seed);

    final List<double> outerScales = List<double>.generate(n, (int i) {
      final double noise = (rng.nextDouble() * 2 - 1) * spread;
      return (1.0 + noise).clamp(1.0 - spread, 1.0 + spread);
    });
    final List<double> innerScales = List<double>.generate(n, (int i) {
      final double noise = (rng.nextDouble() * 2 - 1) * spread * 0.7;
      return (1.0 + noise).clamp(1.0 - spread * 0.7, 1.0 + spread * 0.7);
    });

    final List<Offset> vertices = <Offset>[];
    for (int i = 0; i < n * 2; i++) {
      final bool outer = i.isEven;
      final int ray = i ~/ 2;
      final double base = -math.pi / 2 + (i * math.pi / n);
      final double swirl = twist * 0.48 * (outer ? 1 : -0.55);
      final double wobble =
          twist * 0.1 * math.sin(i * 1.9 + twist * 3.2) * (outer ? 1 : 0.55);
      final double angle = base + swirl + wobble;
      final double scale = outer ? outerScales[ray % n] : innerScales[ray % n];
      final double r = (outer ? baseOuter : baseInner) * scale;
      vertices.add(
        Offset(
          center.dx + math.cos(angle) * r,
          center.dy + math.sin(angle) * r,
        ),
      );
    }

    if (rounding < 0.04) {
      final Path sharp = Path()..moveTo(vertices.first.dx, vertices.first.dy);
      for (int i = 1; i < vertices.length; i++) {
        sharp.lineTo(vertices[i].dx, vertices[i].dy);
      }
      sharp.close();
      return sharp;
    }

    // Outer tips round more; inner valleys stay sharper → star at max rounding.
    final double outerT = (0.18 + rounding * 0.52).clamp(0.14, 0.7);
    final double innerT = (0.04 + rounding * 0.16).clamp(0.03, 0.24);

    final Path path = Path();
    for (int i = 0; i < vertices.length; i++) {
      final bool outer = i.isEven;
      final double t = outer ? outerT : innerT;
      final Offset prev = vertices[(i - 1 + vertices.length) % vertices.length];
      final Offset curr = vertices[i];
      final Offset next = vertices[(i + 1) % vertices.length];
      final Offset p1 = Offset.lerp(curr, prev, t)!;
      final Offset p2 = Offset.lerp(curr, next, t)!;
      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
    }
    path.close();
    return path;
  }
}
