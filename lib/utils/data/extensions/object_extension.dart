import 'package:chat_365/utils/data/extensions/string_extension.dart';

extension ObjectExt on Object {
  String toColoredString(StrColor color) => toString().addColor(color);

  String toErrorString() => toColoredString(StrColor.red);

  bool get isStringNullOrEmpty => toString().isBlank;

  bool stringCompareWith(Object b) =>
      _toCompareString() == b._toCompareString();

  String _toCompareString() => toString().trim().toLowerCase();

  // List get flattenObject {
  //   if (this is! Iterable)
  //     return [this];
  //   else
  //     return (this as Iterable).toList().flatten;
  // }
}
