import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFieldTheme extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextEditingController? textEditingController;
  final VoidCallback? onPressedIcon;
  final VoidCallback? onTapTextField;

  final bool? isChildTitle;
  final String? childTitle;
  final bool? isPassword;
  final bool? isTitle;
  final bool? isShowIcon;
  final bool? isShowIconPre;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Color? colorBorder;
  final Color? colorEnabledBorder;
  final Color? colorFocusedBorder;
  final String? iconSuffix;
  final String? iconPrefix;
  final String? error;
  final double? height;
  final bool? obligatory;
  final bool? readOnly;
  final bool? isIconTitle;
  final String? iconTitle;
  final VoidCallback? onTapIconTitle;
  final int? maxLength;
  final int? maxLine;
  final Key? keyText;
  final FocusNode? focus;
  final List<TextInputFormatter>? inputFormatter;

  const CustomTextFieldTheme(
      {Key? key,
      this.title,
      this.isPassword = false,
      this.isChildTitle = false,
      this.childTitle,
      this.keyboardType = TextInputType.multiline,
      this.colorBorder = AppColors.black99,
      this.iconSuffix,
      this.onChanged,
      this.iconPrefix,
      this.height = 50,
      this.textEditingController,
      this.hintText,
      this.onPressedIcon,
      this.isShowIcon = false,
      this.isShowIconPre = false,
      this.obligatory = false,
      this.error,
      this.isTitle = true,
      this.focus,
      this.readOnly = false,
      this.onTapTextField,
      this.maxLength,
      this.maxLine = 1,
      this.inputFormatter,
      this.colorFocusedBorder = Colors.grey,
      this.colorEnabledBorder = Colors.grey,
      this.validator,
      this.keyText,
      this.isIconTitle = false,
      this.iconTitle,
      this.onTapIconTitle});

  @override
  _CustomTextFieldThemeState createState() => _CustomTextFieldThemeState();
}

class _CustomTextFieldThemeState extends State<CustomTextFieldTheme> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isTitle!
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: widget.title,
                          style: AppTextStyles.regularW400(
                            context,
                            size: AppDimens.textSize16,
                            lineHeight: AppDimens.space18,
                            color: context.theme.textColor,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.obligatory! ? ' *' : '',
                              style: AppTextStyles.regularW400(
                                context,
                                size: AppDimens.textSize18,
                                lineHeight: AppDimens.space18,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.isIconTitle!
                        ? InkWell(
                            onTap: widget.onTapIconTitle,
                            child: SvgPicture.asset(widget.iconTitle!))
                        : Container(),
                  ],
                )
              : Container(),
          widget.isChildTitle!
              ? Text(
                  widget.childTitle!,
                  style: AppTextStyles.regularW400(context,
                      size: AppDimens.textSize14,
                      color: Theme.of(context).primaryColor),
                )
              : Container(),
          SizedBox(
            height: AppDimens.space10,
          ),
          Form(
            key: widget.keyText,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: widget.validator,
                  inputFormatters: widget.inputFormatter,
                  maxLength: widget.maxLength,
                  onTap: widget.onTapTextField,
                  readOnly: widget.readOnly!,
                  focusNode: widget.focus,
                  maxLines: widget.maxLine,
                  obscureText: widget.isPassword!,
                  onChanged: (value) {
                    widget.onChanged!(value);
                  },
                  keyboardType: widget.keyboardType,
                  controller: widget.textEditingController,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: context.theme.textColor,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    errorText: widget.error,
                    hintText: widget.hintText,
                    labelStyle: AppTextStyles.regularW400(context,
                        size: AppDimens.textSize16,
                        color: Theme.of(context).primaryColor),
                    hintStyle: AppTextStyles.regularW400(
                      context,
                      size: AppDimens.textSize16,
                      color: context.theme.textColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        width: 1,
                        color: widget.colorBorder!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        width: 1,
                        color: widget.colorBorder!,
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        width: 1,
                        color: widget.colorBorder!,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefixIconConstraints: BoxConstraints(),
                    prefixIcon: widget.isShowIconPre!
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: SvgPicture.asset(
                              widget.iconPrefix!,
                              color: Theme.of(context).primaryColor,
                            ))
                        : null,
                    isDense: true,
                    contentPadding: EdgeInsets.all(14),
                    suffixIcon: widget.isShowIcon!
                        ? IconButton(
                            icon: SvgPicture.asset(
                              widget.iconSuffix!,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: widget.onPressedIcon,
                          )
                        : null,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
