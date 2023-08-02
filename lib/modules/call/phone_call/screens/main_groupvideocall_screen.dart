import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/call/phone_call/widgets/join_viedeocall_items.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/images.dart';
import '../../../../common/widgets/form/search_field.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../utils/ui/app_border_and_radius.dart';
import '../../../../utils/ui/widget_utils.dart';

class MainGroupVideoCallScreen extends StatefulWidget {
  const MainGroupVideoCallScreen({Key? key}) : super(key: key);

  @override
  State<MainGroupVideoCallScreen> createState() =>
      _MainGroupVideoCallScreenState();
}

class _MainGroupVideoCallScreenState extends State<MainGroupVideoCallScreen> {
  final TextEditingController _controller = TextEditingController();
  List<bool> checkedBoxList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> pickedList = [
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1,
    Images.img_profile_test_1
  ];
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: context.theme.textColor,
      ),
    );
    final button = OutlinedButton(
      onPressed: () => AppRouter.toPage(context, AppPages.Calling_GroupVideo,
          arguments: {"pickedList": pickedList}),
      style: OutlinedButton.styleFrom(
        elevation: 0,
        padding: AppDimens.paddingButton,
        side: BorderSide(
          color: context.theme.primaryColor,
          width: 1,
        ),
        shape: AppBorderAndRadius.roundedRectangleBorder,
        backgroundColor: context.theme.primaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(),
          SizedBoxExt.w10,
          Text(
            "Bắt đầu gọi nhóm",
            style: AppTextStyles.button(context).copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.indigo,
        title: Text(
          "Chọn người tham gia",
          style:
              AppTextStyles.regularW500(context, size: 16, color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            AppRouter.back(context);
          },
          child: SvgPicture.asset(
            Images.ic_back,
            color: AppColors.white,
          ),
        ),
        leadingWidth: 34,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: AppPadding.paddingHor15Vert10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: StringConst.searchName,
                    prefixIconConstraints: BoxConstraints(
                      maxHeight: 32,
                      maxWidth: 32,
                    ),
                    enabledBorder: outlineInputBorder,
                    border: outlineInputBorder,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () {},
                        child: const CustomPaint(
                          size: Size.square(28),
                          painter: SearchIconPainter(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Thành viên nhóm (6)",
                  style: AppTextStyles.regularW400(context,
                      size: 14, color: AppColors.gray),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            flex: 8,
            // physics: ScrollPhysics,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      pickedList.add(Images.img_profile_test_1);
                      checkedBoxList[index] = !checkedBoxList[index];
                    });
                  },
                  child: JoinVideoCallItems(
                    value: checkedBoxList[index],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(60, 10, 0, 10),
                  child: Container(
                    height: 1,
                    color: AppColors.gray,
                  ),
                );
              },
              itemCount: checkedBoxList.length,
            ),
          )
        ]),
      ),
      bottomNavigationBar: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 8,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ],
        ),
        child: Padding(
          padding: AppPadding.paddingHor15Vert10,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Đã chọn: ${pickedList.length}/8",
                    style: AppTextStyles.regularW400(context,
                        size: 14, color: AppColors.doveGray)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      pickedList.length,
                      (index) => Builder(builder: (context) {
                            return Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage(Images.img_profile_test_1),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        pickedList.removeAt(index);
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      size: 15,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })),
                ),
                Center(child: button)
              ]),
        ),
      ),
    );
  }
}
