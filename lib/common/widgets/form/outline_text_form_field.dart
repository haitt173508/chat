import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutlineTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onPressedIcon;
  final VoidCallback? onTapTextField;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final bool enable;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final int? maxLine;
  final int? minLine;
  final String? suffixIcon;
  final String? prefixIcon;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool obscureText;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  const OutlineTextFormField({
    Key? key,
    this.controller,
    this.onPressedIcon,
    this.onTapTextField,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.autovalidateMode,
    this.validator,
    this.readOnly = false,
    this.inputFormatter,
    this.maxLength,
    this.maxLine = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.decoration,
    this.style,
    this.obscureText = false,
    this.enable = true,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.minLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: validator,
      enabled: enable,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      inputFormatters: inputFormatter,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: onSubmitted,
      maxLength: maxLength,
      onTap: onTapTextField,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLine,
      minLines: minLine ?? 1,
      onChanged: onChanged,
      scrollPadding: EdgeInsets.all(5),
      keyboardType: keyboardType,
      controller: controller,
      decoration: decoration,
      obscureText: obscureText,
      style: style ?? TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
    );
  }
}
