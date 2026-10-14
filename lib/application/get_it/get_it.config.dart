// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mood_tracker/application/get_it/shared_preferences_module.dart'
    as _i375;
import 'package:mood_tracker/data/datasources/shared_prefs_data_source.dart'
    as _i447;
import 'package:mood_tracker/data/repositories/emotion_repository.dart'
    as _i504;
import 'package:mood_tracker/data/repositories/mood_repository.dart' as _i748;
import 'package:mood_tracker/data/repositories/settings_repository.dart'
    as _i558;
import 'package:mood_tracker/data/services/mood_grid_color_service.dart'
    as _i610;
import 'package:mood_tracker/domain/usecases/get_entry_by_day.dart' as _i13;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i748.MoodRepository>(() => _i748.MoodRepository());
    gh.singleton<_i610.MoodGridColorService>(
        () => _i610.MoodGridColorService());
    gh.factory<_i13.GetEntryByDayUseCase>(
        () => _i13.GetEntryByDayUseCase(gh<_i748.MoodRepository>()));
    gh.singleton<_i447.SharedPrefsDataSource>(
        () => _i447.SharedPrefsDataSource(gh<_i460.SharedPreferences>()));
    gh.singleton<_i504.EmotionRepository>(
        () => _i504.EmotionRepository(gh<_i610.MoodGridColorService>()));
    gh.singleton<_i558.SettingsRepository>(
        () => _i558.SettingsRepository(gh<_i447.SharedPrefsDataSource>()));
    return this;
  }
}

class _$SharedPreferencesModule extends _i375.SharedPreferencesModule {}
