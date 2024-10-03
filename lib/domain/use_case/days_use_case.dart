import '../../data/data.dart';
import '../domain.dart';

class DaysUseCase {
  DaysUseCase(this._daysRepository);

  final DaysRepository _daysRepository;

  Day? getDayById(int id) => _daysRepository.getDay(id);

  Future<void> saveDay(int id, DateTime date, int moodId) =>
      _daysRepository.saveDay(
          id,
          Day(
            date: date,
            moodId: moodId,
          ));
}
