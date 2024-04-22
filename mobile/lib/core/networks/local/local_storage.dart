import 'package:shared_preferences/shared_preferences.dart';

// locale -- key lưu locale hiện tại

abstract class ILocalStorage {
  Future<bool> putString(String key, String value);

  String? getString(String key);

  bool isKeyExists(String key);

  Future<bool> clearKey(String key);

  Future<bool> clearAll();
}

class LocalCache extends ILocalStorage {
  final SharedPreferences _prefs;

  LocalCache({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  @override
  Future<bool> putString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  @override
  Future<bool> clearKey(String key) {
    return _prefs.remove(key);
  }

  @override
  bool isKeyExists(String key) {
    return _prefs.containsKey(key);
  }
}

class MemoryCache extends ILocalStorage {
  Map<String, Object> memoryMap = <String, Object>{};

  @override
  String? getString(String key) {
    return memoryMap[key] as String?;
  }

  @override
  Future<bool> putString(String key, String value) async {
    memoryMap[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> clearAll() {
    memoryMap.clear();

    return Future.value(true);
  }

  @override
  Future<bool> clearKey(String key) {
    final valueRemoved = memoryMap.remove(key);

    return Future.value(valueRemoved != null);
  }

  @override
  bool isKeyExists(String key) {
    return memoryMap.containsKey(key);
  }
}
