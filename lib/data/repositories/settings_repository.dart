import 'package:injectable/injectable.dart';

import '../datasources/shared_prefs_data_source.dart';

@singleton
class SettingsRepository {
  SettingsRepository(this._dataSource);

  final SharedPrefsDataSource _dataSource;

  static const String _showAdviceKey = 'showAdvice';
  static const String _showEnglishTranslationsKey = 'showEnglishTranslations';
  static const String _onboardingCompletedKey = 'onboardingCompleted';
  static const String _allowShapeEditingKey = 'allowShapeEditing';

  Future<bool> getShowAdvice() async {
    return _dataSource.readBool(key: _showAdviceKey) ?? true;
  }

  Future<void> setShowAdvice(bool value) async {
    await _dataSource.writeBool(key: _showAdviceKey, value: value);
  }

  Future<bool> getShowEnglishTranslations() async {
    return _dataSource.readBool(key: _showEnglishTranslationsKey) ?? false;
  }

  Future<void> setShowEnglishTranslations(bool value) async {
    await _dataSource.writeBool(key: _showEnglishTranslationsKey, value: value);
  }

  Future<bool> isOnboardingCompleted() async {
    return _dataSource.readBool(key: _onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _dataSource.writeBool(key: _onboardingCompletedKey, value: value);
  }

  /// When false, shape is always derived from energy/pleasantness (no tweak UI).
  Future<bool> getAllowShapeEditing() async {
    return _dataSource.readBool(key: _allowShapeEditingKey) ?? true;
  }

  Future<void> setAllowShapeEditing(bool value) async {
    await _dataSource.writeBool(key: _allowShapeEditingKey, value: value);
  }
}
