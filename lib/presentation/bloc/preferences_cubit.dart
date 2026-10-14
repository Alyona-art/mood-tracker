import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/settings_repository.dart';

class PreferencesState {
  const PreferencesState({
    required this.showAdvice,
    required this.showEnglishTranslations,
    required this.allowShapeEditing,
  });

  final bool showAdvice;
  final bool showEnglishTranslations;
  final bool allowShapeEditing;
}

class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(this._settingsRepository)
    : super(
        const PreferencesState(
          showAdvice: true,
          showEnglishTranslations: false,
          allowShapeEditing: true,
        ),
      ) {
    _loadPreferences();
  }

  final SettingsRepository _settingsRepository;

  Future<void> _loadPreferences() async {
    final bool showAdvice = await _settingsRepository.getShowAdvice();
    final bool showEnglishTranslations =
        await _settingsRepository.getShowEnglishTranslations();
    final bool allowShapeEditing =
        await _settingsRepository.getAllowShapeEditing();
    emit(
      PreferencesState(
        showAdvice: showAdvice,
        showEnglishTranslations: showEnglishTranslations,
        allowShapeEditing: allowShapeEditing,
      ),
    );
  }

  Future<void> setShowAdvice(bool value) async {
    await _settingsRepository.setShowAdvice(value);
    emit(
      PreferencesState(
        showAdvice: value,
        showEnglishTranslations: state.showEnglishTranslations,
        allowShapeEditing: state.allowShapeEditing,
      ),
    );
  }

  Future<void> setShowEnglishTranslations(bool value) async {
    await _settingsRepository.setShowEnglishTranslations(value);
    emit(
      PreferencesState(
        showAdvice: state.showAdvice,
        showEnglishTranslations: value,
        allowShapeEditing: state.allowShapeEditing,
      ),
    );
  }

  Future<void> setAllowShapeEditing(bool value) async {
    await _settingsRepository.setAllowShapeEditing(value);
    emit(
      PreferencesState(
        showAdvice: state.showAdvice,
        showEnglishTranslations: state.showEnglishTranslations,
        allowShapeEditing: value,
      ),
    );
  }
}
