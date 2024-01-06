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
