import 'dart:async';

import 'package:chat_365/common/widgets/permission/contact_permission_page.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_route_observer.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';

class ContactService {
  static ContactService? _instance;

  factory ContactService() => _instance ??= ContactService._();

  ContactService._() {}

  Future init() async {
    await getLocalContactWithPermissionRequest(
      checkUserDenied: true,
    );
  }

  List<Contact>? contacts;

  StreamSubscription? _subscription;

  StreamController<List<Contact>> _streamController =
      StreamController.broadcast();

  addListener(ValueChanged<List<Contact>> listener) {
    if (_streamController.hasListener) removeListener();
    return _subscription = _streamController.stream.listen(listener);
  }

  removeListener() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future getLocalContactWithPermissionRequest({
    VoidCallback? callBack,
    bool checkUserDenied = false,
  }) =>
      SystemUtils.permissionCallback(
        Permission.contacts,
        _getLocalPhoneContact,
        onPermissionDisabled: () => _onContactServiceDisabled(checkUserDenied),
        onPermissionStatusGrandted: (isGrandted) => SpUtil.putBool(
          LocalStorageKey.isDeniedContactPermission,
          !isGrandted,
        ),
        onRequest: () async {
          if (routeObserver
                  .isContainPageName(AppPages.Contact_Permission.name) ||
              (checkUserDenied && spService.isDeniedContactPermission)) return;
          AppRouter.toPage(
            navigatorKey.currentContext!,
            AppPages.Contact_Permission,
            arguments: {
              ContactPermissionPage.callBackArg:
                  callBack ?? _getLocalPhoneContact,
            },
            duration: Duration.zero,
          );
        },
      );

  _onContactServiceDisabled(bool checkUserDenied) {
    if (checkUserDenied) {
      if (spService.isDeniedContactPermission)
        return;
      else
        openAppSettings();
    } else
      openAppSettings();
  }

  // getLocalContact() {
  //   return SystemUtils.permissionCallback(
  //     Permission.contacts,
  //     _getLocalPhoneContact,
  //   );
  // }

  ValueNotifier<DateTime?> lastTimeFetchContact = ValueNotifier(null);

  Future<void> _getLocalPhoneContact() async {
    lastTimeFetchContact.value = DateTime.now();
    contacts = (await ContactsService.getContacts()).map(
      (e) {
        var phones = [];
        for (Item phone in e.phones ?? []) {
          phones.add(ContactExt.toMap(phone));
        }
        return Contact.fromMap(
          e.toMap()..update('phones', (_) => phones),
        );
      },
    ).toList()
      ..removeWhere((e) => e.phones.isBlank);
    if (contacts != null) _streamController.sink.add(contacts!);
  }
}

extension ContactExt on Contact {
  static Map toMap(Item i) =>
      {"label": i.label, "value": i.value?.replaceAll(RegExp(r'\D'), '')};

  String get name => displayName ?? phones?[0].value ?? '';
}
