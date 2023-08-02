import 'package:flutter/material.dart';

class ChatBarFeatureBottomSheet extends StatelessWidget {
  const ChatBarFeatureBottomSheet({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: items,
    );
  }
}
