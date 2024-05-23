class MemoryCache {
  Map<String, Object> memoryMap = <String, Object>{};

  String? getString(String key) {
    return memoryMap[key] as String?;
  }

  bool putString(String key, String value) {
    memoryMap[key] = value;
    return true;
  }

  Future<bool> clearAll() {
    memoryMap.clear();

    return Future.value(true);
  }

  Future<bool> clearKey(String key) {
    final valueRemoved = memoryMap.remove(key);

    return Future.value(valueRemoved != null);
  }

  bool isKeyExists(String key) {
    return memoryMap.containsKey(key);
  }
}
