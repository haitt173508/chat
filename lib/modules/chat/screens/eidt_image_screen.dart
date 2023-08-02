import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/profile/profile_cubit/profile_cubit.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

TextStyle _style(BuildContext context, {Color? color}) =>
    AppTextStyles.regularW500(
      context,
      size: 14,
      lineHeight: 22,
      color: color ?? context.theme.textColor,
    );

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({Key? key, required this.image}) : super(key: key);
  final XFile image;
  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  @override
  void initState() {
    // _profileCubit = context.read<ProfileCubit>();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileThemeData(
            contentPadding: EdgeInsets.zero,
            dense: true,
            minLeadingWidth: 20,
            minVerticalPadding: 0,
          ),
        ),
        child: Container());
  }
}

class _ChangeStatusTextFieldListTile extends StatefulWidget {
  const _ChangeStatusTextFieldListTile({
    Key? key,
    required this.initStatus,
  }) : super(key: key);

  final String initStatus;

  @override
  State<_ChangeStatusTextFieldListTile> createState() =>
      __ChangeStatusTextFieldListTileState();
}

class __ChangeStatusTextFieldListTileState
    extends State<_ChangeStatusTextFieldListTile> {
  late final ProfileCubit _profileCubit;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _profileCubit = context.read<ProfileCubit>();
    _controller.text = widget.initStatus;
  }

  bool _isEdit = false;

  Widget _buildTrailing(
    BuildContext context,
  ) =>
      InkWell(
        child: SvgPicture.asset(
          _isEdit ? Images.ic_tick : Images.ic_pencil,
        ),
        onTap: _changeMode,
      );

  _changeMode() {
    setState(() => _isEdit = !_isEdit);
    if (_isEdit)
      _focusNode.requestFocus();
    else
      _profileCubit.changeStatus(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        Images.ic_emoji,
      ),
      dense: true,
      trailing: _buildTrailing(context),
      title: TextField(
        style: _style(
          context,
        ),
        readOnly: !_isEdit,
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }
}
