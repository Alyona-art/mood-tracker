import 'package:flutter/material.dart';

import '../../../../data/services/mood_grid_color_service.dart';
import '../../../widget/axis_grid_view.dart';

class SimpleMoodGrid extends StatelessWidget {
  const SimpleMoodGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const double size = 300;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AxisGridView(
          size: size,
          topLeftColor: MoodGridColorService.defaultTopLeftColor,
          bottomLeftColor: MoodGridColorService.defaultBottomLeftColor,
          bottomRightColor: MoodGridColorService.defaultBottomRightColor,
          grid: Image.asset(
            'assets/images/onboarding-1.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return Container(
                width: size,
                height: size,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
      ],
    );
  }
}
