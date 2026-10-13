part of 'mood_bloc.dart';

abstract class MoodEvent with EquatableMixin {
  const MoodEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadMoodEntries extends MoodEvent {}

class AddMoodEntry extends MoodEvent {
  const AddMoodEntry({
    required this.date,
    required this.audioPath,
    required this.text,
    required this.emotion,
    this.energy,
    this.pleasantness,
  });
  final DateTime date;
  final String audioPath;
  final String text;
  final String emotion;
  final int? energy;
  final int? pleasantness;

  @override
  List<Object?> get props => <Object?>[
    date,
    audioPath,
    text,
    emotion,
    energy,
    pleasantness,
  ];
}

class SelectDay extends MoodEvent {
  const SelectDay(this.day);
  final DateTime day;

  @override
  List<Object?> get props => <Object?>[day];
}

class DeleteMoodEntry extends MoodEvent {
  const DeleteMoodEntry(this.date);
  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}
