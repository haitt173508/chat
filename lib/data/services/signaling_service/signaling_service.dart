import 'dart:async';

import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../common/models/recvice_list_member_call_group_ps_data_model.dart';
import '../../../main.dart';
import '../../../router/app_pages.dart';
import '../../../router/app_router.dart';
import '../../../utils/data/clients/interceptors/call_client.dart';

enum SignalingState {
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

class Session {
  Session({required this.sid, required this.pid});

  String pid;
  String sid;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  List<RTCIceCandidate> remoteCandidates = [];
}

class Signaling {
  static Signaling? _instance;

  factory Signaling() => _instance ??= Signaling._();

  Signaling._() {
    _onListen();
  }

  bool _inCalling = false;
  bool _enabledVideo = true;
  bool _enabledAudio = true;

  String? idSender;

  Map<String, Session> _sessions = {};
  MediaStream? _localStream;
  List<MediaStream> _remoteStreams = <MediaStream>[];

  RTCPeerConnection? pc;
  IUserInfo? userInfo;

  Function(SignalingState state)? onSignalingStateChange;
  Function(CallState state)? onCallStateChange;
  Function(MediaStream stream)? onLocalStream;
  Function(MediaStream stream)? onAddRemoteStream;
  Function(MediaStream stream)? onRemoveRemoteStream;
  Function(dynamic event)? onPeersUpdate;

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:stun.stunprotocol.org'},
      {
        'urls': "turn:0.peerjs.com:3478",
        'username': "peerjs",
        'credential': "peerjsp"
      }
    ]
  };

  final Map<String, dynamic> _dcConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': false,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };
  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };

  close() async {
    print("_cleanSessions");
    await _cleanSessions();
  }

  void switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void turnCamAudio(String idRoom, bool checkType) async {
    if (_localStream != null) {
      if (checkType == true) {
        _enabledVideo = _localStream!.getVideoTracks()[0].enabled;
        _localStream!.getVideoTracks()[0].enabled = !_enabledVideo;
      } else {
        _enabledAudio = _localStream!.getAudioTracks()[0].enabled;
        _localStream!.getAudioTracks()[0].enabled = !_enabledAudio;
      }

      await callClient.emit('turnOnOffCamMic', {
        'roomId': 'chat_${idRoom}timviec365PS',
        'cam': _enabledVideo,
        'mic': _enabledAudio
      });
    }
  }

  //khi lắng nghe callee đã tham gia room bắt đầu tạo offer,candidate gửi cho callee
  void invite() {
    callClient.on('user-connected', _receiveUserConnectedMessagesHandler);
    onCallStateChange?.call(CallState.CallStateNew);
    onCallStateChange?.call(CallState.CallStateInvite);
  }

  //nhận về data bên callee join-room khi đã connect vào room
  _receiveUserConnectedMessagesHandler(response) async {
    var idPeer = response['peerId'];
    // socketId của người nhận( người mới tham gia cuộc gọi)
    var socketId = response['socketId'];
    //userId của người mới tham gia cuộc gọi
    idSender = response['userId'];
    //tên của người mới tham gia cuộc gọi
    var nameUser = response['nameuser'];

    try {
      if (nameUser != userInfo?.name) {
        await _createSession(
            'chat_${userInfo!.id.toString()}', idSender!, socketId);
      }
      _createOffer(socketId, idSender!);
    } catch (e, s) {
      print(s);
    }
  }

  void rejectCall(String idCaller) {
    callClient.emit('decline_currnent_meeting_invite', {
      'callee': idCaller,
      'userId': 'chat_${userInfo!.id}',
    });
    callClient.emit('addUser',
        {'userId': 'chat_${AuthRepo.idUser}', 'name': AuthRepo.nameUser});
    _closeSession();
  }

  void bye(String idRoom) {
    callClient.emit('endCallAll', {
      'roomId': 'chat_${idRoom}timviec365PS',
    });
    callClient.emit('addUser',
        {'userId': 'chat_${AuthRepo.idUser}', 'name': AuthRepo.nameUser});
    _closeSession();
  }

  void accept(String idRoom) async {
    await createLocalStream();

    joinRoom(idRoom);
    // pc!.onSignalingState = (state) {
    //   print("onSignalingState: ${state}");
    //   if (state == RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
    //     // answer here
    //     _createAnswer(idSender);
    //   }
    // };
  }

  void reject(String idCaller) {
    rejectCall(idCaller);
  }

  void joinRoom(String idRoom) {
    //tự động join room
    callClient.emit('join-room', {
      'roomId': idRoom,
      //id của người nhận
      'userId': 'chat_${userInfo!.id}',
      'peerId': '',
      //tên người nhận
      'nameuser': userInfo!.name
    });
    // _onListen();
  }

  //khởi tạo local sớm
  Future<void> createLocalStream() async {
    _localStream = await createStream();
    print(_iceServers);
    pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': 'unified-plan'}
    }, _config);
    try {
      if (_localStream != null) {
        pc!.onTrack = (event) {
          onAddRemoteStream!.call(event.streams[0]);
        };

        _localStream!.getTracks().forEach((track) {
          pc!.addTrack(track, _localStream!);
        });
      }
    } catch (e, s) {
      print(s);
    }
  }

  //các event láng nghe

  // void onMessage(message) async {
  //   Map<String, dynamic> mapData = message;
  //   var data = mapData['data'];
  //
  //   switch (mapData['type']) {
  //     case 'leave':
  //       {
  //         var peerId = data as String;
  //         _closeSessionByPeerId(peerId);
  //       }
  //       break;
  //     case 'bye':
  //       {
  //         var sessionId = data['session_id'];
  //         print('bye: ' + sessionId);
  //         var session = _sessions.remove(sessionId);
  //         if (session != null) {
  //           onCallStateChange?.call(CallState.CallStateBye);
  //           _closeSession(session);
  //         }
  //       }
  //       break;
  //     case 'keepalive':
  //       {
  //         print('keepalive response!');
  //       }
  //       break;
  //     default:
  //       break;
  //   }
  // }

  Future<void> connect(
      List<int> listIdUser, String idCaller, String idConversation) async {
    List<String> listIdUserString = listIdUser.map((e) => 'chat_$e').toList();
    print('onOpen');
    // onSignalingStateChange?.call(SignalingState.ConnectionOpen);
    //khởi tạo local
    createLocalStream();
    callClient.emit('sendListMemberCallGroupPS', {
      //truyền id callee
      'listUser': listIdUserString,
      //truyền id caller
      'linkGroup':
          'https://skvideocall.timviec365.vn/chat_${idCaller}timviec365PS',
      'caller': 'chat_$idCaller',
      'arrayConversationId': ['$idConversation'],
    });
    callClient.emit('join-room', {
      'roomId': 'chat_${idCaller}timviec365PS',
      //id của người nhận
      'userId': 'chat_${userInfo!.id}',
      'peerId': '',
      //tên người nhận
      'nameuser': userInfo!.name
    });
    //lắng nghe callee join
    invite();
    //// lắng nghe trả lời từ phía callee
    callClient.on('receive_answer_video_conference',
        _answerVideoConfferenceMessagesHandler);

    // callClient.onOpen = () {
    //    List<String> listIdUserString = listIdUser.map((e) => e.toString()).toList();
    //   print('onOpen');
    //   onSignalingStateChange?.call(SignalingState.ConnectionOpen);
    //   callClient.emit('sendListMemberCallGroupPS', {
    //     //truyền id callee
    //     'listUse': listIdUserString,
    //     //truyền id caller
    //     'linkGroup': 'https://skvideocall.timviec365.vn/${idCaller}timviec365PS',
    //     'caller': idCaller,
    //     'arrayConversationId' : idConversation,
    //   });
    //
    //   callClient.onClose = () {
    //     onSignalingStateChange?.call(SignalingState.ConnectionClosed);
    //   };
    //
    //   // on user-connected
    //
    // };
    // lắng nghe  nhận về từ phía caller
  }

  _onListen() {
    //lắng nghe có người gọi đến
    // callClient.on('recviceListMemberCallGroupPS',_receiveListMemberCallGroupPS);
    //lắng nghe offer video của caller
    callClient.on('receive_offer_video_conference',
        _receiveOfferVideoConferenceMessagesHandler);
    //lắng nghe nhận candidate để set sdp
    callClient.on('candidate_conference', _candidateConferenceMessagesHandler);
  }

  //data nhận về khi lắng nghe có người gọi đến
  _receiveListMemberCallGroupPS(data) {
    print(data);
    // Nhận về data của người gọi
    final RecviceListMemberCallGroupPSDataModel model =
        RecviceListMemberCallGroupPSDataModel.fromMap(data);
    //check id người nhận và chuyển màn ở trạng thái chờ phản hồi từ callee
    if (userInfo?.id != null)
      try {
        AppRouter.toPage(navigatorKey.currentContext!, AppPages.Video_Call,
            arguments: {
              'userInfor': userInfo,
              'idRoom': model.linkGroup.split('/').last,
              'idCaller': model.idCaller,
              'idCallee': model.idListCallee,
              'checkCallee': true,
            });
      } catch (e, s) {
        print(s);
      }
    onCallStateChange?.call(CallState.CallStateNew);

    onCallStateChange?.call(CallState.CallStateRinging);
  }

  //nhân về offer bên caller
  _receiveOfferVideoConferenceMessagesHandler(response) async {
    // if (_inCalling) return;
    print(response);
    List<RTCIceCandidate> listIceCandidate = [];
    //
    var description = response['description'];
    // userId của người gọi
    var userIdSender = response['userIdSender'];
    //socketId của người gọi để check nếu như gọi nhiều
    var socketIdSender = response['socketIdSender'];
    // _inCalling = true;
    //khởi tạo local bên người nhận
    //khởi tạo phiên,on track stream caller và setRemote
    try {
      if (userIdSender != null) {
        await _createSession(
            'chat_${userInfo!.id.toString()}', userIdSender, socketIdSender);
        await pc?.setRemoteDescription(
            RTCSessionDescription(description['sdp'], description['type']));
      }
    } catch (e, s) {
      print(s);
    }

    // if (listIceCandidate.length > 0) {
    // listIceCandidate.forEach((candidate) async {
    // await pc?.addCandidate(candidate);
    // });
    // listIceCandidate.clear();
    // }
    onCallStateChange?.call(CallState.CallStateNew);

    onCallStateChange?.call(CallState.CallStateRinging);
  }

  //nhận về data và chấp nhận cuộc gọi của callee
  _answerVideoConfferenceMessagesHandler(response) async {
    var description = response['description'];
    //userId của người nhận cuộc gọi(callee)
    var userIdReceiver = response['userIdReceiver'];
    // userId(caller),dữ liệu này lấy từ kênh receive_offer_video_conference
    var userIdSender = response['userIdSender'];
    pc?.setRemoteDescription(
        RTCSessionDescription(description['sdp'], description['type']));
    onCallStateChange?.call(CallState.CallStateConnected);
  }

  //thu thập candidate bên phía caller
  _candidateConferenceMessagesHandler(response) async {
    print(response);
    var candidateMap = response['candidate_data'];
    RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    // if (listIceCandidate.length > 0) {
    // listIceCandidate.forEach((candidate) async {
    // await pc?.addCandidate(candidate);
    // });
    // listIceCandidate.clear();
    // }

    if (pc != null) {
      await pc!.addCandidate(candidate);
    } else {
      candidateMap.remoteCandidates.add(candidate);
    }
  }

  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    MediaStream stream =
        // userScreen
        //     ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    onLocalStream!.call(stream);
    return stream;
  }

  //connectpeer và set localStream,candidate
  Future<void> _createSession(
      String idUser, String idSender, String idSocket) async {
    // if(_inCalling)
    // createLocalStream();

    pc?.onIceCandidate = (e) async {
      {
        print(e);
        if (e.candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        // This delay is needed to allow enough time to try an ICE candidate
        // before skipping to the next one. 1 second is just an heuristic value
        // and should be thoroughly tested in your own environment.
        await Future.delayed(const Duration(seconds: 1), () {
          if (e.candidate != null)
            // {
            //   print('onIceCandidate: complete!');
            //   return;
            // }
            // emitPing(idSender);
            // if (!_isSubmitCandidate){
            //   pc!.addCandidate(e);
            //   emitPing(idSender);
            //   _isSubmitCandidate = true;
            // }

            callClient.emit('candidate_conference', {
              'candidate_data': {
                'sdpMLineIndex': e.sdpMLineIndex,
                'sdpMid': e.sdpMid,
                'candidate': e.candidate,
              },
              'socketId': idSocket,
              //id của callee(do lúc này người nhận là ng emit)
              'userId': idSender,
              //id của caller
              'userIdSender': idUser
            });
        });
      }
      ;
    };

    pc?.onIceConnectionState = (state) {
      print(state);
    };

    pc?.onRemoveStream = (stream) {
      onRemoveRemoteStream?.call(stream);
      _remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    pc?.onSignalingState = (state) {
      print("onSignalingState: ${state}");
      if (state == RTCSignalingState.RTCSignalingStateHaveRemoteOffer) {
        // answer here
        _createAnswer(idSender);
      }
    };
  }

  //khởi tạo offer
  Future<void> _createOffer(String socketId, String userId) async {
    try {
      RTCSessionDescription s = await pc!.createOffer();
      await pc!.setLocalDescription(s);
      callClient.emit('offer_video_conference', {
        //nhận dữ liẹu từ kênh user-connected
        'socketId': socketId,
        //user ng nhận
        'userId': userId,
        'userIdSender': 'chat_${userInfo!.id}',
        'description': {'sdp': s.sdp, 'type': s.type},
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //hàm trả lời từ phía callee
  Future<void> _createAnswer(String userIdSender) async {
    try {
      //
      // RTCPeerConnection peerConnection = await createPeerConnection(_iceServers);

      RTCSessionDescription s = await pc!.createAnswer();
      await pc!.setLocalDescription(s);
      callClient.emit('answer_video_conference', {
        //id của người nhận(callee)
        'userIdReceiver': 'chat_${userInfo!.id.toString()}',
        'description': {'sdp': s.sdp, 'type': s.type},
        //id của người gọi(caller)
        'userIdSender': userIdSender
      });
    } catch (e, s) {
      print(s);
      print(e.toString());
    }
  }

  Future<void> _cleanSessions() async {
    if (_localStream != null) {
      _localStream!.getTracks().forEach((element) async {
        await element.stop();
      });
      await _localStream!.dispose();
      _localStream = null;
    }
    _sessions.forEach((key, sess) async {
      await sess.pc?.close();
      await sess.dc?.close();
    });
    _sessions.clear();
  }

  // void _closeSessionByPeerId() {
  //   // var session;
  //   // _sessions.removeWhere((String key, Session sess) {
  //   //   var ids = key.split('-');
  //   //   session = sess;
  //   //   return peerId == ids[0] || peerId == ids[1];
  //   // });
  //   if (pc != null) {
  //     _closeSession();
  //     onCallStateChange?.call(CallState.CallStateBye);
  //   }
  // }

  Future<void> _closeSession() async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    await pc?.close();
  }
}

final Signaling signaling = Signaling();
