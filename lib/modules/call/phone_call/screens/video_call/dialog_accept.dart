import 'package:chat_365/common/images.dart';
import 'package:chat_365/data/services/signaling_service/signaling_service.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../../core/interfaces/interface_user_info.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../router/app_router.dart';
import '../../../../../utils/data/clients/interceptors/call_client.dart';


class Dialog extends StatefulWidget {
  const Dialog({Key? key, required this.userInfo, required this.idRoom}) : super(key: key);
  final IUserInfo userInfo;
  final String idRoom;

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> with SingleTickerProviderStateMixin{
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  // signaling.onLocalStream = ((stream) {
  // _localRenderer.srcObject = stream;
  // setState(() {});
  // });
  //
  // Signaling?.onAddRemoteStream = ((_, stream) {
  // _remoteRenderer.srcObject = stream;
  // setState(() {});
  // });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P2P Call Sample' ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      body: Column(
        children: [
          // RTCVideoRenderer(),
          Row(children: [
            ElevatedButton(
              onPressed: () => AppRouter.back(context),
              child: Text(
                'Quay lại',
                style:
                AppTextStyles.regularW700(context, size: 18).copyWith(
                  color: context.theme.backgroundColor,
                ),
              ),
              style: context.theme.buttonStyle,
            ),
            SizedBoxExt.w10,

            ElevatedButton(
              onPressed: (){
                callClient.emit('join-room', {
                  'roomId': widget.idRoom,
                  //id của người nhận
                  'userId': 'chat_${widget.userInfo.id}',
                  'peerId': '',
                  //tên người nhận
                  'nameuser': widget.userInfo.name
                });
              },
              child: Text(
                'Chấp nhận',
                style:
                AppTextStyles.regularW700(context, size: 18).copyWith(
                  color: context.theme.backgroundColor,
                ),
              ),
              style: context.theme.buttonStyle,
            ),
          ],)
        ],
      )
    );
  }
}
