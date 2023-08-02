import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListContactItem extends StatefulWidget {
  const ListContactItem({
    Key? key,
    required this.model,
    this.accountName,
    this.check = false,
    this.onTap,
  }) : super(key: key);

  final IUserInfo model;
  final String? accountName;
  final bool check;
  final VoidCallback? onTap;

  @override
  State<ListContactItem> createState() => _ListContactItemState();
}

class _ListContactItemState extends State<ListContactItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  DisplayAvatar(
                    isGroup: false,
                    model: widget.model,
                    size: 50,
                  ),
                  SizedBoxExt.w8,
                  Expanded(
                    child: Text(
                      widget.accountName ?? "",
                      style: AppTextStyles.regularW500(context, size: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.check == true)
              SvgPicture.asset(Images.ic_v, color: context.theme.primaryColor)
            else
              SizedBox(
                height: 15,
                width: 15,
              )
          ],
        ),
      ),
    );
  }
}
