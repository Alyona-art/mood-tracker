import 'package:flutter/material.dart';

extension StringColorExtension on String {
  Color? toColor() {
    if (isEmpty) {
      return null;
    }

    String hex = this;
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    if (hex.length == 8) {
      try {
        return Color(int.parse(hex, radix: 16));
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}
