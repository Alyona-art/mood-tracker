import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final MoodsCubit moodsCubit = BlocProvider.of<MoodsCubit>(context);

    return BlocBuilder<MoodsCubit, List<Mood>>(
      bloc: moodsCubit,
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
                      border: selectedId == mood.id ? Border.all() : null,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            shape: BoxShape.circle,
                            color: Color(mood.color),
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
