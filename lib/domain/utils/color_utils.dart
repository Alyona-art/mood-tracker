import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();
  
  static Color bilinearColor({
    required double x,
    required double y,
    required Color tl,
    required Color tr,
    required Color bl,
    required Color br,
  }) {
    final Color top = Color.lerp(tl, tr, x)!;
    final Color bottom = Color.lerp(bl, br, x)!;
    return Color.lerp(top, bottom, y)!;
  }
}
