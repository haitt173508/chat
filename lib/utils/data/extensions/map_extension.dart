extension MapExt<K, V> on Map<K, V> {
  Map<K, V> insertAtTop(K key, V value) {
    var keys = this.keys.toList();
    var newMap = {key: value};
    for (int i = 0; i < this.keys.length; i++) {
      K _key = keys[i];
      newMap[keys[i]] = this[_key]!;
    }

    return newMap;
  }
}
