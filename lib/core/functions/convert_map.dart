Map<String, dynamic> convertMap(Map<Object?, Object?> originalMap) {
  Map<String, dynamic> convertedMap = {};
  originalMap.forEach((key, value) {
    if (key is String) {
      convertedMap[key] = value;
    } else if (key != null) {
      convertedMap[key.toString()] = value;
    }
  });

  return convertedMap;
}

Map<String, Map<Object?, Object?>> castMap(Map<Object?, Object?> inputMap) {
  return inputMap.map((key, value) {
    if (key is String && value is Map<Object?, Object?>) {
      // Key is already a String, and value is already a Map<Object?, Object?>
      return MapEntry<String, Map<Object?, Object?>>(key, value);
    } else {
      // Convert key to String, and value to Map<Object?, Object?>
      return MapEntry<String, Map<Object?, Object?>>(
        key.toString(),
        value is Map<Object?, Object?> ? castMap(value) : {value.runtimeType: value},
      );
    }
  });
}

