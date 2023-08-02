extension NumExt on num {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));

  String fizeSizeString() {
    if (this < 1024) return '${_fileSizePrecision(this)} B';
    final double sizeInMb = this / (1024 * 1024);
    if (sizeInMb < 1) return '${_fileSizePrecision(_sizeInKb(this))} KB';
    return '${_fileSizePrecision(sizeInMb)} MB';
  }

  _sizeInKb(num byteSize) => byteSize / 1024;

  _fileSizePrecision(num byteSize) => byteSize.toPrecision(2);
}
