import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool showIconLock;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  const PasswordField({
    Key? key,
    required this.hintText,
    this.controller,
    this.validator,
    this.showIconLock = true,
    this.autovalidateMode,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return OutlineTextFormField(
      controller: widget.controller,
      style: context.theme.inputStyle,
      obscureText: isVisible,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      decoration: context.theme.inputDecoration.copyWith(
        // helperText: '',
        hintText: widget.hintText,
        prefixIcon: widget.showIconLock
            ? WidgetUtils.getFormFieldColorPrefixIcon(AssetPath.password,
                color: context.theme.iconColor)
            : null,
        suffixIcon: IconButton(
          onPressed: () => setState(() => isVisible = !isVisible),
          padding: EdgeInsets.only(right: 16),
          constraints: BoxConstraints(maxHeight: 20),
          splashRadius: 8,
          iconSize: 18,
          icon: Icon(
            !isVisible ? Icons.visibility : Icons.visibility_off,
            color: context.theme.iconColor,
          ),
        ),
        hintStyle: context.theme.hintStyle,
      ),
    );
  }
}
