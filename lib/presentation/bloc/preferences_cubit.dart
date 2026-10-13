import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/settings_repository.dart';

class PreferencesState {
  const PreferencesState({
    required this.showAdvice,
    required this.showEnglishTranslations,
  });

  final bool showAdvice;
  final bool showEnglishTranslations;
}

class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(this._settingsRepository)
    : super(
        const PreferencesState(
          showAdvice: true,
          showEnglishTranslations: false,
        ),
      ) {
    _loadPreferences();
  }

  final SettingsRepository _settingsRepository;

  Future<void> _loadPreferences() async {
    final bool showAdvice = await _settingsRepository.getShowAdvice();
    final bool showEnglishTranslations =
        await _settingsRepository.getShowEnglishTranslations();
    emit(
      PreferencesState(
        showAdvice: showAdvice,
        showEnglishTranslations: showEnglishTranslations,
      ),
    );
  }

  Future<void> setShowAdvice(bool value) async {
    await _settingsRepository.setShowAdvice(value);
    emit(
      PreferencesState(
        showAdvice: value,
        showEnglishTranslations: state.showEnglishTranslations,
      ),
    );
  }

  Future<void> setShowEnglishTranslations(bool value) async {
    await _settingsRepository.setShowEnglishTranslations(value);
    emit(
      PreferencesState(
        showAdvice: state.showAdvice,
        showEnglishTranslations: value,
      ),
    );
  }
}
