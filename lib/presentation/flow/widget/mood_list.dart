import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../domain/domain.dart';
import '../../presentation.dart';

class MoodList extends StatelessWidget {
  const MoodList({
    super.key,
    required this.onTap,
    required this.selectedId,
  });

  final Function(Mood) onTap;
  final int selectedId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodsCubit, List<Mood>>(
      builder: (BuildContext context, List<Mood> state) {
        return Wrap(
          spacing: 32,
          runSpacing: 12,
          children: state
              .map(
                (Mood mood) => InkWell(
                  onTap: () {
                    onTap(mood);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: selectedId == mood.id
                          ? Border.all(
                              color: Theme.of(context).dividerColor,
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            shape: BoxShape.circle,
                            color: mood.color.toColor(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(mood.name),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
