import 'dart:async';

import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SendMessageSearchAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const SendMessageSearchAppBar({
    Key? key,
    required this.controller,
    this.onSubmit,
    this.stateNotifier,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String>? onSubmit;
  final ValueNotifier<DialogState>? stateNotifier;

  @override
  State<SendMessageSearchAppBar> createState() =>
      _SendMessageSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _SendMessageSearchAppBarState extends State<SendMessageSearchAppBar> {
  final StreamController<DialogState> _controller =
      StreamController.broadcast();
  String _lastValue = '';

  Widget _buildSuffixIcon(BuildContext context) {
    return SizedBox.square(
      dimension: 18,
      child: StreamBuilder<DialogState>(
        stream: _controller.stream,
        builder: (_, sns) {
          if (sns.data == DialogState.processing)
            return CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2.5,
            );
          else if (widget.controller.text.isNotEmpty) {
            return _cancelButton();
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _cancelButton() {
    return IconButton(
      icon: Icon(Icons.cancel),
      color: AppColors.white,
      padding: EdgeInsets.zero,
      onPressed: () => widget.controller.clear(),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
    if (widget.stateNotifier != null)
      widget.stateNotifier!.addListener(_stateListener);
  }

  _listener() {}
  _stateListener() => _controller.sink.add(widget.stateNotifier!.value);

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_listener);
    widget.stateNotifier?.removeListener(_stateListener);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        color: AppColors.white,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: context.theme.gradient,
          ),
          alignment: Alignment.bottomCenter,
          child: TextField(
            controller: widget.controller,
            style: context.theme.searchBigTextStyle,
            cursorColor: AppColors.white,
            cursorHeight: 26.4,
            onSubmitted: widget.onSubmit,
            onChanged: (value) {
              if (value.isNotEmpty && value != _lastValue) {
                _controller.sink.add(DialogState.success);
                _lastValue = value;
              }
            },
            decoration: InputDecoration(
              hintText: StringConst.search,
              hintStyle: context.theme.searchBigTextStyle,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _buildSuffixIcon(context),
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 45,
                maxWidth: 45 + 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
