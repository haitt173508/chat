import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HistoryItem extends StatefulWidget {
  const HistoryItem({
    Key? key,
    this.iconDevice,
    required this.loginMethod,
    required this.nameDevice,
    required this.time,
    required this.location,
    this.checkBrand,
    this.logUot = false,
  }) : super(key: key);
  final String? iconDevice;
  final String? nameDevice;
  final String? loginMethod;
  final String? time;
  final String? location;
  final String? checkBrand;
  final bool logUot;

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (widget.checkBrand == 'Ios')
                SvgPicture.asset(Images.ic_history_ip)
              else if (widget.checkBrand == 'Android')
                SvgPicture.asset(Images.ic_history_android)
              else if (widget.checkBrand == 'Windows')
                SvgPicture.asset(Images.ic_history_win)
              else if (widget.checkBrand == 'Mac')
                SvgPicture.asset(Images.ic_history_mac)
              else
                SvgPicture.asset(Images.ic_history_ip),
              SizedBoxExt.w16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.nameDevice ?? "Không xác định",
                      style: AppTextStyles.regularW400(context, size: 16)),
                  SizedBoxExt.h5,
                  Text(
                    widget.loginMethod ?? "Không xác định",
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      color: context.theme.dividerHistoryColor,
                    ),
                  ),
                  SizedBoxExt.h5,
                  Text('${widget.location} .${widget.time}',
                      style: AppTextStyles.regularW400(
                        context,
                        size: 14,
                        color: context.theme.dividerHistoryColor,
                      )),
                ],
              ),
            ],
          ),
        ),
        SizedBoxExt.w16,
        if (widget.logUot == true)
          InkWell(
            onTap: () {
              widget.logUot == !widget.logUot;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: context.theme.messageBoxColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Đăng xuất'),
            ),
          )
        else
          Text(
            "Đã đăng xuất",
            style: AppTextStyles.regularW400(
              context,
              size: 12,
              color: context.theme.dividerHistoryColor,
            ),
          )
      ],
    );
  }
}
