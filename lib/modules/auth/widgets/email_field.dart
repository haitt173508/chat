import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/helpers/validators.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class EmailField extends StatefulWidget {
  const EmailField({
    Key? key,
    this.controller,
    this.focusNode,
    this.validator,
  }) : super(key: key);
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  late final TextEditingController _controller;
  final List<String> _emails = spService.loggedInEmail;
  String? Function(String?)? _validatorAccount;

  _onSuggestionSelected(String value) => _controller.text = value;

  Widget _suggestionItemBuilder(BuildContext context, String itemData) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Text(
          itemData,
          style: AppTextStyles.textMessageDisplayStyle(context),
        ),
      );

  List<String> _suggestionsCallback(String text) => SystemUtils.searchFunction(
        text,
        _emails,
      ).toList();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _validatorAccount = Validator.requiredInputPhoneOrEmailValidator;
    // _controller.addListener(_handleControllerChanged);
    // widget.data.addListener(_onData);
  }

  @override
  void didUpdateWidget(covariant EmailField oldWidget) {
    _validatorAccount =
        widget.validator ?? Validator.requiredInputPhoneOrEmailValidator;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<String>(
      validator: _validatorAccount,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      debounceDuration: const Duration(milliseconds: 200),
      textFieldConfiguration: TextFieldConfiguration(
        style: context.theme.inputStyle,
        controller: _controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          if (_validatorAccount != null) {
            setState(() {
              _validatorAccount = Validator.requiredInputPhoneOrEmailValidator;
            });
          }
        },
        decoration: context.theme.inputDecoration.copyWith(
          hintText: StringConst.inputPhoneOrEmail,
          hintStyle: context.theme.hintStyle,
          prefixIcon: WidgetUtils.getFormFieldColorPrefixIcon(
            Images.ic_person,
            color: context.theme.iconColor,
          ),
        ),
      ),
      getImmediateSuggestions: true,
      hideOnEmpty: true,
      hideSuggestionsOnKeyboardHide: true,
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: context.theme.messageBoxColor,
      ),
      onSuggestionSelected: _onSuggestionSelected,
      itemBuilder: _suggestionItemBuilder,
      suggestionsCallback: _suggestionsCallback,
      animationDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }
}
