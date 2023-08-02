import 'package:chat_365/common/blocs/chat_library_cubit/cubit/chat_library_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/blocs/typing_detector_bloc/typing_detector_bloc.dart';
import 'package:chat_365/common/blocs/unread_message_counter_cubit/unread_message_counter_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/forward_message_screen.dart';
import 'package:chat_365/common/widgets/image_message_slider_screen.dart';
import 'package:chat_365/common/widgets/select_list_user_checkbox.dart';
import 'package:chat_365/common/widgets/send_contact_screen.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/auth/modules/login/screens/login_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/register_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/screens/auth_option_screen.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/screens/chat_sceen.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/screens/invite_contact_screen.dart';
import 'package:chat_365/modules/file_preview/file_preview_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/library_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/profile_chat_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/share_contact_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_screen.dart';
import 'package:chat_365/modules/search/screens/search_contact_screen.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/chat_feature_action.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/utilities/appointment/screens/appointment_screen.dart';
import '../modules/utilities/appointment/screens/create_appointment_screen.dart';
import 'app_pages.dart';
import 'app_router.dart';

/// Required các arguments cần thiết khi navigate giữa các màn cần tham số
class AppRouterHelper {
  static toLoginPage(
    BuildContext context, {
    required UserType userType,
    AuthMode? authMode,
  }) async {
    // if (userType != null) {
    context.read<AuthRepo>().userType = userType;
    // }
    return AppRouter.toPage(
      context,
      AppPages.Auth_Login,
      arguments: {
        LoginScreen.userTypeArg: context.read<AuthRepo>().userType,
        LoginScreen.authMode: authMode,
      },
    );
    // ..then(
    //     (value) => context.read<AuthRepo>().userType = UserType.unAuth,
    //   );
  }

  static toRegisterPage(
    BuildContext context, {
    UserType? userType,
  }) async {
    if (userType != null) {
      context.read<AuthRepo>().userType = userType;
    }
    return AppRouter.toPage(
      context,
      AppPages.Auth_Register,
      arguments: {
        RegisterScreen.userTypeArg: context.read<AuthRepo>().userType,
      },
    )..then(
        (value) => context.read<AuthRepo>().userType = UserType.unAuth,
      );
  }

///////
  static toCreateAppointmentPage(
    BuildContext context, {
    bool isCreate = true,
  }) =>
      AppRouter.toPage(context, AppPages.Utils_CreateAppointment,
          arguments: {CreateAppointmentScreen.argIsCreate: isCreate});
  static toAppointmentPage(
    BuildContext context, {
    bool isAdmin = true,
  }) =>
      AppRouter.toPage(context, AppPages.Utils_AppointmentScreen,
          arguments: {AppointmentScreen.argIsAdmin: isAdmin});

  static toAuthOptionPage(
    BuildContext context, {
    required AuthMode authMode,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Auth_option,
        arguments: {
          AuthOptionScreen.authModeArg: authMode,
        },
      );

  static toNavigationPage(
    BuildContext context,
  ) {
    return AppRouter.replaceAllWithPage(context, AppPages.Navigation);
  }

  /// - Pop until [AppPages.Navigation] trước sau đó push đến màn [AppPages.Chat_Detail]
  static toChatPage(
    BuildContext context, {
    required UserInfoBloc userInfoBloc,
    required bool isGroup,
    required int senderId,
    required int conversationId,
    ChatItemModel? chatItemModel,
    UnreadMessageCounterCubit? unreadMessageCounterCubit,
    TypingDetectorBloc? typingDetectorBloc,
    int? messageDisplay,
    ChatFeatureAction? action,
  }) {
    var chatConversationBloc = context.read<ChatConversationBloc>();
    var _unreadMessageCounterCubit =
        chatConversationBloc.unreadMessageCounteCubits.putIfAbsent(
            conversationId,
            () =>
                unreadMessageCounterCubit ??
                UnreadMessageCounterCubit(
                  conversationId: conversationId,
                  countUnreadMessage: 0,
                ));
    var _typingDetectorBloc = typingDetectorBloc ??
        chatConversationBloc.typingBlocs[conversationId] ??
        TypingDetectorBloc(conversationId);

    chatItemModel?.lastMessages ??=
        chatConversationBloc.chatsMap[conversationId]?.lastMessages;

    AppRouter.backToPage(context, AppPages.Navigation);
    AppRouter.toPage(
      context,
      AppPages.Chat_Detail,
      blocProviders: [
        BlocProvider.value(value: userInfoBloc),
        BlocProvider.value(value: _unreadMessageCounterCubit),
        BlocProvider.value(value: _typingDetectorBloc),
      ],
      arguments: {
        ChatScreen.isGroupArg: isGroup,
        ChatScreen.conversationIdArg: conversationId,
        ChatScreen.senderIdArg: senderId,
        ChatScreen.messageDisplayArg: messageDisplay,
        ChatScreen.chatItemModelArg: chatItemModel,
        ChatScreen.actionArg: action,
      },
    );
  }

  static toForwardMessagePage(
    BuildContext context, {
    required SocketSentMessageModel message,
    required IUserInfo senderInfo,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Forward_Message,
        arguments: {
          ForwardMessageScreen.messageArg: message,
          ForwardMessageScreen.senderInfoArg: senderInfo,
        },
      );

  static toProfilePage(
    BuildContext context, {
    required IUserInfo userInfo,
    required bool isGroup,
    ChatDetailBloc? bloc,
    bool self = false,
    int? conversationId,
  }) =>
      AppRouter.toPage(
        context,
        self ? AppPages.Profile_Self : AppPages.Profile_Chat,
        arguments: {
          ProfileChatScreen.userInfoArg: userInfo,
          ProfileChatScreen.isGroupArg: isGroup,
        },
        blocValue: bloc,
      );

  static toCalenderPhoneCallPage(
    BuildContext context, {
    required IUserInfo userInfo,
    required bool isGroup,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Calender_Phone_Call,
        arguments: {
          ProfileScreen.userInfoArg: userInfo,
          ProfileScreen.isGroupArg: isGroup,
        },
      );

  static toSendContactPage(
    BuildContext context, {
    required int conversationBasicInfo,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Send_Contact,
        arguments: {
          SendContactScreen.conversationBasicInfoArg: conversationBasicInfo,
        },
      );

  static toSendLocationPage(
    BuildContext context, {
    required ChatDetailBloc chatDetailBloc,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Send_Location,
        blocValue: chatDetailBloc,
      );

  // static toProfileSelfPage(
  //   BuildContext context, {
  //   required IUserInfo userInfo,
  //   required bool isGroup,
  // }) =>
  //     AppRouter.toPage(
  //       context,
  //       AppPages.Profile_Self,
  //       arguments: {
  //         ProfileScreen.userInfoArg: userInfo,
  //         ProfileScreen.isGroupArg: isGroup,
  //       },
  //     );

  static toSelectListUserCheckBox(
    BuildContext context, {
    String? title,
    required ErrorCallback<List<IUserInfo>> onSubmitted,
    required ValueChanged<List<IUserInfo>> onSuccess,
    ValueChanged<ExceptionError>? onError,
    dynamic repo,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            var selectListUserCheckBox = SelectListUserCheckBox(
              onSubmitted: onSubmitted,
              onSuccess: onSuccess,
              onError: onError,
              title: title,
            );
            if (repo != null)
              return RepositoryProvider.value(
                value: repo,
                child: selectListUserCheckBox,
              );
            return selectListUserCheckBox;
          },
        ),
      );

  static toInviteContactPage(
    BuildContext context, {
    required IUserInfo userInfo,
  }) {
    return AppRouter.toPage(context, AppPages.Invite_Contact, arguments: {
      InviteContactScreen.userInfoArg: userInfo,
    });
  }

  static toSearchContactPage(
    BuildContext context, {
    required ContactListCubit contactListCubit,
    Function(ConversationBasicInfo)? trailingBuilder,
    bool showSearchCompany = true,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Search,
        arguments: {
          SearchContactScreen.contactListCubitArg: contactListCubit,
          SearchContactScreen.trailingBuilderArg: trailingBuilder,
          SearchContactScreen.showSearchCompanyArg: showSearchCompany,
        },
      );

  static toShareContactPage(
    BuildContext context, {
    String? initSearch,
    bool showMoreButton = true,
    List<FilterContactsBy> filters = const [
      FilterContactsBy.none,
      FilterContactsBy.conversations,
      FilterContactsBy.myContacts,
    ],
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Share_Contact,
        arguments: {
          ShareContactScreen.filtersArg: filters,
          ShareContactScreen.showMoreButtonArg: showMoreButton,
          ShareContactScreen.initSearchArg: initSearch,
        },
      );

  static toPreviewFile(
    BuildContext context, {
    required String link,
  }) =>
      AppRouter.toPage(context, AppPages.Preview, arguments: {
        FilePrevewScreen.linkFileArg: link,
      });

  static toLibraryPage(
    BuildContext context, {
    MessageType messageType = MessageType.image,
    required IUserInfo userInfo,
    required ChatLibraryCubit libraryCubit,
  }) {
    AppRouter.toPage(
      context,
      AppPages.Library,
      arguments: {
        LibraryScreen.userInfoArg: userInfo,
        LibraryScreen.initMessageTypeArg: messageType,
        LibraryScreen.libraryCubitArg: libraryCubit,
      },
    );
  }

  static toImageSlidePage(
    BuildContext context, {
    required List<SocketSentMessageModel> imageMessages,
    int initIndex = -1,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Image_Slide,
        arguments: {
          ImageMessageSliderScreen.imagesArg: imageMessages,
          ImageMessageSliderScreen.initIndexArg: initIndex,
        },
      );

  static toPhoneContactPage(
    BuildContext context, {
    required SuggestContactCubit suggestContactCubit,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Phone_Contact,
        blocValue: suggestContactCubit,
      );

  static toFriendRequestPage(
    BuildContext context, {
    required SuggestContactCubit suggestContactCubit,
    required ContactListCubit contactListCubit,
  }) =>
      AppRouter.toPage(
        context,
        AppPages.Recieved_AddFriend_Request,
        blocProviders: [
          BlocProvider.value(
            value: suggestContactCubit,
          ),
          BlocProvider.value(
            value: contactListCubit,
          ),
        ],
      );
}
