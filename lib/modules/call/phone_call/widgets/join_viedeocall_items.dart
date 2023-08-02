import 'package:chat_365/common/images.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../utils/ui/app_padding.dart';

class JoinVideoCallItems extends StatefulWidget {
  late bool? value;
  late bool? isCheckBox;
  late int? status;
  VoidCallback? ontap;
  JoinVideoCallItems({
    Key? key,
    this.value,
    this.isCheckBox = true,
    this.status = 0,
  }) : super(key: key);

  @override
  State<JoinVideoCallItems> createState() => _JoinVideoCallItemsState();
}

class _JoinVideoCallItemsState extends State<JoinVideoCallItems> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          widget.isCheckBox!
              ? Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                  onChanged: (_) => {},
                  value: widget.value,
                  // shape: OutlinedBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )
              : Container(),
          SizedBox(
            width: 4,
          ),
          CircleAvatar(
            backgroundImage: AssetImage(Images.img_profile_test_1),
            radius: 20,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            "Le Hoang Long",
            style: AppTextStyles.regularW700(context,
                size: 16,
                color:
                    widget.isCheckBox! ? AppColors.tundora : AppColors.white),
          ),
          SizedBox(
            width: context.mediaQuerySize.width * 0.23,
          ),
          Expanded(
            child: widget.isCheckBox!
                ? Container()
                : Container(
                    width: context.mediaQuerySize.width * 0.25,
                    // height: 50.0,
                    padding: AppPadding.paddingAll10,
                    decoration: BoxDecoration(
                        gradient: widget.status == 2
                            ? context.theme.gradientPhoneCall
                            : LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                    Color(0xff0086DA).withOpacity(0.4),
                                    Color(0xff00A9E9).withOpacity(0.4)
                                  ]),
                        borderRadius: BorderRadius.circular(100)),
                    child: InkWell(
                        onTap: () {
                          // AppRouter.back(context);
                          // AppRouter.replaceWithPage(
                          //   context,
                          //   AppPages.Video_Call,
                          // );
                        },
                        child: Center(
                          child: Text(
                            widget.status == 2
                                ? 'Thêm'
                                : (widget.status == 0
                                    ? 'Đã vào'
                                    : 'Đang gọi...'),
                            style: AppTextStyles.regularW500(context,
                                size: 16, color: context.theme.backgroundColor),
                          ),
                        )),
                  ),
          ),
        ],
      ),
    );
  }
}
