import 'package:injectable/injectable.dart';
import '../../data/repositories/mood_repository.dart';
import '../models/mood_day.dart';

@injectable
class GetEntryByDayUseCase {
  GetEntryByDayUseCase(this.repository);
  final MoodRepository repository;

  Future<MoodDay?> execute(DateTime date) async {
    return repository.getEntryByDate(date);
  }
}
