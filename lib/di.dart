import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';
import 'data/data.dart';
import 'domain/use_case/days_use_case.dart';
import 'domain/use_case/moods_use_case.dart';

class DI {
  DI._();

  static DI? instance;

  late DaysRepository _daysRepository;
  late MoodsRepository _moodsRepository;
  late DaysUseCase daysUseCase;
  late MoodsUseCase moodsUseCase;

  static DI getInstance() {
    return instance ?? (instance = DI._());
  }

  Future<void> init() async {
    final Directory directory = await getApplicationSupportDirectory();
    Hive.init(directory.path);
    _daysRepository = DaysRepository(await Hive.openBox(Constants.dayBox));
    _moodsRepository = MoodsRepository(await Hive.openBox(Constants.moodBox));
    daysUseCase = DaysUseCase(_daysRepository);
    moodsUseCase = MoodsUseCase(_moodsRepository);
  }
}
