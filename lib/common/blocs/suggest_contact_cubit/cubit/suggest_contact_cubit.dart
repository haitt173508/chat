import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/repo/suggest_contact_repo.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/contact_service/contact_service.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/enums/contact_source.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:contacts_service/contacts_service.dart';

part 'suggest_contact_state.dart';

class SuggestContactCubit extends Cubit<SuggestContactState> {
  SuggestContactCubit({
    required IUserInfo userInfo,
    required this.friendCubit,
  })  : suggestContactRepo = SuggestContactRepo(userInfo),
        super(SuggestContactSuccess(const [])) {
    _subscription = friendCubit.stream.listen((state) {
      if (state is FriendStateAddFriendSuccess) {
        if (!sendRequest.map((e) => e.id).contains(state.userInfo.id)) {
          sendRequest.add(state.userInfo);
          _emitSuccessState();
        }
      } else if (state is FriendStateLoadSuccess) getAddFriendRequest();
    });

    ContactService().addListener(listener);
  }

  listener(List<Contact> contacts) => loadSuggestContactFromPhone();

  final FriendCubit friendCubit;
  late final StreamSubscription _subscription;

  bool checkUserDeniedContactPermission = false;

  Future<List<ApiContact>> _getSuggestContactFromPhone() async {
    if (_contactService.contacts == null)
      try {
        await _contactService.getLocalContactWithPermissionRequest(
          checkUserDenied: checkUserDeniedContactPermission,
        );
        checkUserDeniedContactPermission = false;
        if (_contactService.contacts == null) {
          throw CustomException(ExceptionError(''));
        }
      } catch (e, s) {
        logger.logError(e, s, 'GetContactError');
        throw CustomException(ExceptionError('Lấy danh bạ thất bại'));
      } finally {
        checkUserDeniedContactPermission = false;
      }

    var res = await suggestContactRepo
        .getSuggestChatUsersFromContacts(_contactService.contacts!);

    return res.onCallBack((_) => List<ApiContact>.from(
          (json.decode(res.data)['data']['user_list'] as List).map(
            (e) => ApiContact.fromMyContact(
              e,
              contactSource: ContactSource.phone,
            ),
          ),
        ));
  }

  Future<List<List<ApiContact>>> getAddFriendRequestBasicInfo() async {
    var res = await suggestContactRepo.getAddFriendRequestBasicInfo();

    return res.onCallBack(
      (_) {
        var decodedData = json.decode(res.data)['data'];
        return [
          List<ApiContact>.from(
            (decodedData['requestListContact'] as List).map(
              (e) => ApiContact(
                avatar: e['contactAvatar'],
                name: e['contactName'],
                lastActive: null,
                companyId: null,
                id: e['contactId'],
                contactSource: ContactSource.friendRequest,
              ),
            ),
          ),
          List<ApiContact>.from(
            (decodedData['listUserSendRequest'] as List).map(
              (e) => ApiContact(
                avatar: e['contactAvatar'],
                name: e['contactName'],
                lastActive: null,
                companyId: null,
                id: e['contactId'],
                contactSource: ContactSource.friendRequest,
              ),
            ),
          )
        ];
      },
    );
  }

  List<ApiContact> requestAddFriend = [];

  List<IUserInfo> sendRequest = [];

  Map<String, ApiContact> contactFromPhone = {};

  Future loadSuggestContactFromPhone() async {
    try {
      var value = await _getSuggestContactFromPhone();
      contactFromPhone = Map.fromIterable(
        value,
        key: (e) => (e as ApiContact).email!,
      );
      _emitSuccessState();
    } catch (e, s) {
      logger.logError(e, s);
      _emitSuccessState();
    }
  }

  Future getAllSuggestContact({
    bool checkUserDenied = false,
  }) {
    checkUserDeniedContactPermission = checkUserDenied;
    return Future.wait([
      loadSuggestContactFromPhone(),
      getAddFriendRequest(),
    ]);
  }

  Future<void> getAddFriendRequest() async {
    try {
      var rest = await getAddFriendRequestBasicInfo();
      requestAddFriend = rest[0];
      sendRequest = <IUserInfo>[...rest[1]];
      _emitSuccessState();
    } on CustomException catch (e, s) {
      logger.logError(e, s);
      _emitSuccessState();
    } catch (e, s) {
      logger.logError(e, s);
      _emitSuccessState();
    }
  }

  _emitSuccessState() => emit(
      SuggestContactSuccess([...requestAddFriend, ...contactFromPhone.values]));

  late final SuggestContactRepo suggestContactRepo;
  final ContactService _contactService = ContactService();

  @override
  Future<void> close() {
    ContactService().removeListener();
    _subscription.cancel();
    return super.close();
  }
}
