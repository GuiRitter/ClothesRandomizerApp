V getFromMapConstructIfNull<K, V>({
  required K key,
  required Map<K, V> map,
  required V Function() constructor,
}) {
  var value = map[key];

  if (value == null) {
    value = constructor();
    map[key] = value as V;
  }

  return value as V;
}
