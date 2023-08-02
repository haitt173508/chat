import 'dart:typed_data';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/data/services/map_service/map_service.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SendLocationScreen extends StatefulWidget {
  const SendLocationScreen({Key? key}) : super(key: key);

  @override
  State<SendLocationScreen> createState() => _SendLocationScreenState();
}

class _SendLocationScreenState extends State<SendLocationScreen> {
  late final ValueNotifier<LatLng> _position;
  final MapService _mapService = MapService();
  Uint8List? _iconByteDatas;
  Set<Marker> _marker = {};

  GoogleMapController? _controller;

  late final ChatBloc _chatBloc;

  late final Future<Uint8List> Function() _getMarker;

  late final ChatDetailBloc _chatDetailBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _chatDetailBloc = context.read<ChatDetailBloc>();

    _getMarker =
        () => GeneratorService.getBytesFromAsset(Images.img_my_location, 120);
    _position = ValueNotifier(MapService().position);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _position.addListener(_listener);
      _mapService.init().then((_) {
        _setPosition();
      });
    });
  }

  _setPosition() {
    if (_mapService.position != null) {
      logger.log('Set new position.value = ${_mapService.position}');
      _position.value = _mapService.position;
    }
  }

  _listener() {
    try {
      logger.log('Set move to position.value = ${_position.value}');
      _controller!.animateCamera(CameraUpdate.newLatLngZoom(
        _position.value,
        15,
      ));
      _setMarker();
      logger.log('Animated ${_position.value}');
    } catch (e, s) {
      logger.logError(e, s);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = context.mediaQuerySize.height / 2.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.location),
        centerTitle: false,
      ),
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FutureBuilder<Uint8List?>(
              future: _getMarker(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null)
                  _iconByteDatas = snapshot.data!;
                return ValueListenableBuilder<LatLng>(
                    valueListenable: _position,
                    builder: (context, position, _) {
                      _setMarker();
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: position,
                          zoom: 15,
                        ),
                        // myLocationEnabled: true,
                        onMapCreated: (controller) =>
                            _controller ??= controller,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        markers: _marker,
                        myLocationButtonEnabled: true,
                      );
                    });
              },
            ),
            DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                    color: context.theme.backgroundColor,
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    children: [
                      Container(
                        height: 2,
                        width: 120,
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: (context.mediaQuerySize.width - 120) / 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.theme.primaryColor,
                        ),
                        // margin: EdgeInsets.symmetric(vertical: 5),
                      ),
                      // _ListTileItem(
                      //   title: 'Gửi vị trí hiện tại của bạn',
                      //   assetPath: Images.ic_my_location,
                      //   color: AppColors.red,
                      //   subtitle: 'Liên tục cập nhật khi bạn di chuyển',
                      //   onTap: () {},
                      // ),
                      // Divider(
                      //   color: context.theme.dividerDefaultColor,
                      //   indent: 5,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Gửi địa điểm cụ thể: ',
                          style: context.theme.locationListTileStyle,
                        ),
                      ),
                      _ListTileItem(
                        assetPath: Images.ic_my_location,
                        gradient: context.theme.gradient,
                        title: 'Gửi vị trí hiện tại của bạn',
                        onTap: () {
                          AppDialogs.showSendLocationDialog(
                            context,
                            _ListTileItem(
                              assetPath: Images.ic_my_location,
                              gradient: context.theme.gradient,
                              title: 'Vị trí hiện tại của bạn',
                            ),
                            isCurrentLocation: true,
                            recieveInfo:
                                _chatDetailBloc.detail!.conversationBasicInfo,
                            onSend: () {
                              var currentUserId = context.userInfo().id;
                              _chatBloc.sendMessage(
                                ApiMessageModel(
                                  messageId: GeneratorService.generateMessageId(
                                      currentUserId),
                                  senderId: currentUserId,
                                  conversationId:
                                      _chatDetailBloc.conversationId,
                                  message:
                                      '${_position.value.latitude}, ${_position.value.longitude}',
                                  type: MessageType.map,
                                ),
                                memberIds: _chatDetailBloc
                                    .listUserInfoBlocs.keys
                                    .toList(),
                                conversationId: _chatDetailBloc.conversationId,
                              );
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                AppRouter.backUntil(
                                  context,
                                  (route) =>
                                      route is PageRoute &&
                                      routeObserver.currentPageRoute!.settings
                                              .name !=
                                          AppPages.Send_Location.name,
                                );
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              initialChildSize: 48 / maxHeight,
              minChildSize: 48 / maxHeight,
              expand: false,
              snap: true,
              maxChildSize: 1 / 2.5,
            ),
          ],
        ),
      ),
    );
  }

  void _setMarker() {
    _marker = {
      GeneratorService.createMarker(
        _position.value,
        'currentId',
        icon: _iconByteDatas,
      )
    };
  }
}

class _ListTileItem extends StatelessWidget {
  const _ListTileItem({
    Key? key,
    required this.assetPath,
    required this.title,
    this.subtitle,
    this.color,
    this.gradient,
    this.onTap,
  }) : super(key: key);

  final Color? color;
  final Gradient? gradient;
  final String assetPath;
  final VoidCallback? onTap;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: gradient == null ? color : null,
          gradient: gradient,
        ),
        child: SvgPicture.asset(
          assetPath,
          color: AppColors.white,
          height: 30,
          width: 30,
        ),
      ),
      horizontalTitleGap: 15,
      title: Text(
        title,
        style: context.theme.locationListTileStyle,
      ),
      minVerticalPadding: 0,
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.regularW400(
                context,
                size: 14,
                lineHeight: 21.6,
                color: context.theme.dividerDefaultColor,
              ),
            )
          : null,
    );
  }
}
