import 'package:chat_365/common/widgets/custom_scaffold.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/modules/new_conversation/models/conversation_creation_kind.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/material.dart';

import 'select_contact_view.dart';

extension on ConversationCreationKind {
  String get title {
    switch (this) {
      case ConversationCreationKind.normal:
        return StringConst.createNewConversation;
      case ConversationCreationKind.private:
        return StringConst.createNewPrivateConversation;
    }
  }
}

