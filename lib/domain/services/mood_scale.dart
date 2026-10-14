/// Continuous mood scale helpers (0–100) with migration from the old 1–6 grid.
class MoodScale {
  MoodScale._();

  static const int minPercent = 0;
  static const int maxPercent = 100;
  static const int defaultPercent = 50;

  /// Old discrete grid used values 1–6 (and sometimes 1–5 on the slider).
  static bool isLegacyDiscrete(int? value) =>
      value != null && value >= 1 && value <= 6;

  /// Normalize stored value to 0–100. Legacy 1–6 maps to 0,20,40,60,80,100.
  static int toPercent(int? value) {
    if (value == null) {
      return defaultPercent;
    }
    if (isLegacyDiscrete(value)) {
      return (((value - 1) / 5) * 100).round().clamp(minPercent, maxPercent);
    }
    return value.clamp(minPercent, maxPercent);
  }

  /// Map 0–100 back to the old 1–6 grid (for nearest emotion chips).
  static int toDiscrete(int percent) {
    final int p = percent.clamp(minPercent, maxPercent);
    return ((p / 100) * 5).round() + 1;
  }

  static double toUnit(int percent) =>
      percent.clamp(minPercent, maxPercent) / 100.0;
}
