import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/wavy_three_dot.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/open_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapDisplay extends StatelessWidget {
  const MapDisplay({
    Key? key,
    this.infoLink,
    required this.senderInfo,
  }) : super(key: key);

  final InfoLink? infoLink;
  final IUserInfo senderInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (infoLink != null &&
            !infoLink!.link.isBlank &&
            infoLink!.link!.contains('google.com/maps'))
          openUrl(infoLink!.link!);
        else
          openUrl(
              'https://www.google.com/maps/search/?api=1&query=${infoLink?.link?.replaceAll(' ', '')}');
      },
      child: Ink(
        width: 210 / 0.7,
        // alignment: Alignment.center,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: infoLink?.image ?? '',
                  errorWidget: (_, __, ___) => const SizedBox(),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 210,
                ),
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Container(
                    height: 80,
                    width: 65,
                    decoration: ShapeDecoration(
                      shape: AvatarMarkerShape(),
                      color: AppColors.white,
                      shadows: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.35),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    alignment: Alignment.topCenter,
                    child: BlocProvider(
                      create: (context) => UserInfoBloc(senderInfo),
                      child: BlocBuilder<UserInfoBloc, UserInfoState>(
                        buildWhen: (previous, current) =>
                            previous.userInfo.avatar != current.userInfo.avatar,
                        builder: (context, state) {
                          return DisplayAvatar(
                            size: 60,
                            isGroup: false,
                            model: state.userInfo,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: AppColors.greyCC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoLink != null
                      ? Text(
                          infoLink?.title ?? '',
                          style: AppTextStyles.regularW600(
                            context,
                            size: 16,
                            color: AppColors.black,
                          ),
                        )
                      : WavyThreeDot(),
                  Text(
                    infoLink?.description ?? '',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      color: AppColors.boulder,
                    ),
                  ),
                  Text(
                    infoLink?.linkHome ?? '',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AvatarMarkerShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addOval(Offset.zero & Size.square(60));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    path
      ..moveTo(rect.topRight.dx, rect.topRight.dy)
      ..addOval(
        Rect.fromCircle(
          center: Offset(
            rect.topRight.dx - 32.5,
            rect.topRight.dy + 30,
          ),
          radius: 32,
        ),
      )
      ..moveTo(rect.bottomRight.dx - 25, rect.bottomCenter.dy - 20)
      ..lineTo(rect.bottomCenter.dx, rect.bottomRight.dy - 6.5)
      ..lineTo(rect.bottomLeft.dx + 25, rect.bottomCenter.dy - 20);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
