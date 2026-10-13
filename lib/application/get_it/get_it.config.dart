// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mood_tracker/application/get_it/shared_preferences_module.dart'
    as _i152;
import 'package:mood_tracker/data/datasources/shared_prefs_data_source.dart'
    as _i479;
import 'package:mood_tracker/data/repositories/emotion_repository.dart' as _i212;
import 'package:mood_tracker/data/repositories/mood_repository.dart' as _i968;
import 'package:mood_tracker/data/repositories/settings_repository.dart' as _i953;
import 'package:mood_tracker/data/services/mood_grid_color_service.dart' as _i386;
import 'package:mood_tracker/domain/usecases/get_entry_by_day.dart' as _i493;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
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
    gh.singleton<_i968.MoodRepository>(() => _i968.MoodRepository());
    gh.singleton<_i386.MoodGridColorService>(
        () => _i386.MoodGridColorService());
    gh.singleton<_i479.SharedPrefsDataSource>(
        () => _i479.SharedPrefsDataSource(gh<_i460.SharedPreferences>()));
    gh.singleton<_i953.SettingsRepository>(
        () => _i953.SettingsRepository(gh<_i479.SharedPrefsDataSource>()));
    gh.factory<_i493.GetEntryByDayUseCase>(
        () => _i493.GetEntryByDayUseCase(gh<_i968.MoodRepository>()));
    gh.singleton<_i212.EmotionRepository>(
        () => _i212.EmotionRepository(gh<_i386.MoodGridColorService>()));
    return this;
  }
}

class _$SharedPreferencesModule extends _i152.SharedPreferencesModule {}
