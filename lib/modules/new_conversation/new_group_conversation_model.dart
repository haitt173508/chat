import 'dart:io';

import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:flutter/foundation.dart';

class NewGroupConversationModel {
  final ValueNotifier<String> name;
  final ValueNotifier<File?> avatar;
  final ValueNotifier<List<ApiContact>> member;

  NewGroupConversationModel()
      : this.name = ValueNotifier(''),
        this.avatar = ValueNotifier(null),
        this.member = ValueNotifier([]);
}
