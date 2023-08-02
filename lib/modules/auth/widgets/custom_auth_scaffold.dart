import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class CustomAuthScaffold extends StatelessWidget {
  const CustomAuthScaffold({
    Key? key,
    required this.child,
    this.showBottomBackgroundImage = true,
    this.title = '',
    this.resizeToAvoidBottomInset,
    this.extendBodyBehindAppBar = true,
    this.useAppBar = true,
    this.scrollAble = true,
  }) : super(key: key);

  final bool showBottomBackgroundImage;
  final Widget child;
  final String title;
  final bool? resizeToAvoidBottomInset;
  final bool useAppBar;
  final bool extendBodyBehindAppBar;
  final bool scrollAble;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      // appBar: useAppBar
      //     ?
      //     : null,
      body: Material(
        type: MaterialType.canvas,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            //!Column để xử lý lỗi parentwidget của expanded
            children: [
              Expanded(
                child: Container(
                  color: context.theme.backgroundColor,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      //!Phải tách constrain với container ở trên riêng mới đúng giao diện
                      //!Nếu ko sẽ có khoảng trắng hở ở dưới
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height),
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => FocusManager.instance.primaryFocus
                                    ?.unfocus(),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: context.mediaQueryPadding.top),
                                  child: child,
                                ),
                              ),
                              SizedBoxExt.h10,
                              // Spacer(),
                              // Stack(
                              //   alignment: Alignment.bottomRight,
                              //   children: [
                              //     CustomPaint(
                              //       size: Size(
                              //           MediaQuery.of(context).size.width,
                              //           (MediaQuery.of(context).size.width *
                              //                   0.30133333333333334)
                              //               .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                              //       painter: RPSCustomPainter(),
                              //     ),
                                  // Image.asset(
                                  //   AssetPath.auth_background_human,
                                  //   width:
                                  //       MediaQuery.of(context).size.width / 1.5,
                                  // ),
                                // ],
                              // )
                            ],
                          ),
                          if (useAppBar)
                            Positioned(
                              top: context.mediaQueryPadding.top + 4,
                              left: 10,
                              right: 10,
                              child: Row(
                                // alignment: Alignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () => AppRouter.back(context),
                                  ),
                                  Text(
                                    title.isNotEmpty ? title : ' ',
                                    style: AppTextStyles.authTitle.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox.square(
                                    dimension: kMinInteractiveDimension,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.cubicTo(
        size.width * 0.3427093,
        size.height * 0.5630434,
        size.width * 0.9750000,
        size.height * 0.4818841,
        size.width,
        size.height);
    path_0.cubicTo(
        size.width * 0.8583333, size.height, 0, size.height, 0, size.height);
    path_0.lineTo(0, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff4C5BD4).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
