import 'package:hive_flutter/hive_flutter.dart';

import '../../utils/utils.dart';

class LocalCache {
  final Box<Object> _box;

  LocalCache._(this._box);

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static Future<LocalCache> getInstance() async {
    final box = await Hive.openBox<Object>(AppStrings.preferencesBox);
    return LocalCache._(box);
  }

  Future<void> putValue<T>(String key, T value) {
    return _box.put(key, value!);
  }

  T? getValue<T>(String key) {
    return _box.get(key) as T?;
  }

  Future<int> clearAll() {
    return _box.clear();
  }

  Future<void> clearKey(String key) {
    return _box.delete(key);
  }

  bool isKeyExists(String key) {
    return _box.get(key) != null;
  }
}
