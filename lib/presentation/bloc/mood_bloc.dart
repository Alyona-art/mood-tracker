import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/mood_repository.dart';
import '../../domain/models/mood_day.dart';

part 'mood_event.dart';
part 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc(this.repository) : super(MoodInitial()) {
    on<LoadMoodEntries>((LoadMoodEntries event, Emitter<MoodState> emit) async {
      emit(MoodLoading());
      try {
        final List<MoodDay> entries = await repository.getAllEntries();
        final Map<DateTime, String> moodsByDay = <DateTime, String>{
          for (final MoodDay e in entries)
            DateTime(e.date.year, e.date.month, e.date.day): e.emotion,
        };
        emit(MoodLoaded(moodsByDay: moodsByDay, entries: entries));
      } catch (e) {
        emit(MoodError(e.toString()));
      }
    });

    on<AddMoodEntry>((AddMoodEntry event, Emitter<MoodState> emit) async {
      try {
        final MoodDay entry = MoodDay(
          date: event.date,
          audioPath: event.audioPath,
          text: event.text,
          emotion: event.emotion,
          energy: event.energy,
          pleasantness: event.pleasantness,
          shapeRounding: event.shapeRounding,
          shapeRayDepth: event.shapeRayDepth,
          shapeTwist: event.shapeTwist,
          shapeVariance: event.shapeVariance,
          adviceSuggestion: event.adviceSuggestion,
        );
        await repository.upsertEntryByDate(entry);
        add(LoadMoodEntries());
      } catch (e) {
        emit(MoodError(e.toString()));
      }
    });

    on<DeleteMoodEntry>((DeleteMoodEntry event, Emitter<MoodState> emit) async {
      try {
        await repository.deleteEntryByDate(event.date);
        add(LoadMoodEntries());
      } catch (e) {
        emit(MoodError(e.toString()));
      }
    });
  }
  final MoodRepository repository;
}
