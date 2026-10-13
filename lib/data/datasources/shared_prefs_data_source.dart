import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPrefsDataSource {
  SharedPrefsDataSource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  bool? readBool({required String key}) {
    if (!_sharedPreferences.containsKey(key)) {
      return null;
    }
    return _sharedPreferences.getBool(key);
  }

  String? readString({required String key}) {
    if (!_sharedPreferences.containsKey(key)) {
      return null;
    }
    return _sharedPreferences.getString(key);
  }

  int? readInt({required String key}) {
    if (!_sharedPreferences.containsKey(key)) {
      return null;
    }
    return _sharedPreferences.getInt(key);
  }

  double? readDouble({required String key}) {
    if (!_sharedPreferences.containsKey(key)) {
      return null;
    }
    return _sharedPreferences.getDouble(key);
  }

  Future<bool> writeBool({required String key, required bool value}) {
    return _sharedPreferences.setBool(key, value);
  }

  Future<bool> writeString({required String key, required String value}) {
    return _sharedPreferences.setString(key, value);
  }

  Future<bool> writeInt({required String key, required int value}) {
    return _sharedPreferences.setInt(key, value);
  }

  Future<bool> writeDouble({required String key, required double value}) {
    return _sharedPreferences.setDouble(key, value);
  }

  Future<bool> delete({required String key}) {
    return _sharedPreferences.remove(key);
  }

  Future<bool> clear() => _sharedPreferences.clear();

  bool containsKey({required String key}) {
    return _sharedPreferences.containsKey(key);
  }
}
