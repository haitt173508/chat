mixin SearchableMixin {
  List<Object?> get searchProps;

  String get searchKey => searchProps.join(' ');
}
