part of 'mood_bloc.dart';

abstract class MoodState with EquatableMixin {
  const MoodState();

  @override
  List<Object?> get props => <Object?>[];
}

class MoodInitial extends MoodState {}

class MoodLoading extends MoodState {}

class MoodLoaded extends MoodState {
  const MoodLoaded({required this.moodsByDay, required this.entries});
  final Map<DateTime, String> moodsByDay; // дата -> эмоция
  final List<MoodDay> entries;

  @override
  List<Object?> get props => <Object?>[moodsByDay, entries];
}

class MoodError extends MoodState {
  const MoodError(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class DaySelected extends MoodState {
  const DaySelected(this.entry);
  final MoodDay entry;

  @override
  List<Object?> get props => <Object?>[entry];
}
