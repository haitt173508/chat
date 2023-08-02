import 'package:equatable/equatable.dart';

class SelectableItem extends Equatable {
  final String id;
  final String name;
  final bool isSelected = false;

  SelectableItem({
    required this.id,
    required this.name,
  });
  set isSelected(value) => isSelected = value;

  /// để name = '' do api search chỉ cần id
  factory SelectableItem.fromId(String id) => SelectableItem(id: id, name: '');

  @override
  List<Object?> get props => [
        id,
        name,
        isSelected,
      ];
}

extension SelectableItemExt on List<SelectableItem> {
  String get names => map((e) => e.name).join(', ');
}
