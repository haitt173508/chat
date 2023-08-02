import 'package:chat_365/common/images.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
    this.onChanged,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

//   @override
//   State<ChatInputField> createState() => _ChatInputFieldState();
// }

// class _ChatInputFieldState extends State<ChatInputField> {
  // ValueNotifier<bool> _isFocusing = ValueNotifier(false);

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.focusNode != null)
  //     widget.focusNode!.addListener(_focusScopeListener);
  //   _isFocusing.addListener(() {
  //     if (_isFocusing.value)
  //       widget.focusNode?.requestFocus();
  //     else
  //       widget.focusNode?.unfocus();
  //   });
  // }

  // void _focusScopeListener() {
  //   try {
  //     if (widget.focusNode!.hasFocus || widget.focusNode!.hasPrimaryFocus) {
  //       _isFocusing.value = true;
  //     } else
  //       _isFocusing.value = false;
  //   } catch (e, s) {
  //     logger.logError(e, s);
  //   }
  // }

  // @override
  // void didUpdateWidget(covariant ChatInputField oldWidget) {
  //   if (widget.focusNode != null && widget.focusNode.) {
  //     if (!(widget.focusNode!.hasFocus || widget.focusNode!.hasPrimaryFocus) &&
  //         !_isFocusing.value) widget.focusNode!.requestFocus();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 120,
      ),
      child: TextField(
        // onTap: _inputTapHandler,
        cursorHeight: 18,
        onChanged: onChanged,
        controller: controller,
        focusNode: focusNode,
        maxLines: null,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          hintText: 'Nhập tin nhắn',
          isDense: true,
          suffixIcon: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: SvgPicture.asset(
              Images.ic_emoji,
              color: context.theme.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
