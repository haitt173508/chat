import 'package:chat_365/common/widgets/forward_message_screen.dart';
import 'package:chat_365/common/widgets/image_message_slider_screen.dart';
import 'package:chat_365/common/widgets/map/send_location_screen.dart';
import 'package:chat_365/common/widgets/permission/contact_permission_page.dart';
import 'package:chat_365/common/widgets/permission/location_permission_page.dart';
import 'package:chat_365/common/widgets/send_contact_screen.dart';
import 'package:chat_365/common/widgets/widget_slider.dart';
import 'package:chat_365/modules/auth/modules/forgot_password/screens/forgot_password_screen.dart';
import 'package:chat_365/modules/auth/modules/forgot_password/screens/update_password_screen.dart';
import 'package:chat_365/modules/auth/modules/intro/screen/intro_screen.dart';
import 'package:chat_365/modules/auth/modules/login/screens/check_account.dart';
import 'package:chat_365/modules/auth/modules/login/screens/login_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/cubit/signup_cubit.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/add_first_employee_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_id_company.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_otp_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/register_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/scan_qr_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/signup_success_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/auth/screens/auth_option_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/accept_or_deny_access_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/create_meeting_schedule.dart';
import 'package:chat_365/modules/call/meeting/screens/create_new_vote_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/edit_meeting_schedule_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/edit_my_meeting_room_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/edit_region_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/edit_vote_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/meeting_chat_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/meeting_room_detail_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/meeting_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/my_meeting_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/overview_security_setting_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/participants_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/vote_list_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/vote_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/white_board_action_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/white_board_pages_screen.dart';
import 'package:chat_365/modules/call/meeting/screens/white_board_screen.dart';
import 'package:chat_365/modules/call/phone_call/screens/calling_groupvideo_screen.dart';
import 'package:chat_365/modules/call/phone_call/screens/main_phonecall_screen.dart';
import 'package:chat_365/modules/call/phone_call/screens/main_phonevideo_screen.dart';
import 'package:chat_365/modules/chat/screens/chat_sceen.dart';
import 'package:chat_365/modules/chat/screens/eidt_image_screen.dart';
import 'package:chat_365/modules/contact/screens/_recieved_friend_request_screen.dart';
import 'package:chat_365/modules/contact/screens/invite_contact_screen.dart';
import 'package:chat_365/modules/contact/widget/all_suggest_contact_screen.dart';
import 'package:chat_365/modules/file_preview/file_preview_screen.dart';
import 'package:chat_365/modules/home_qr_code/screens/accept_login_screen.dart';
import 'package:chat_365/modules/home_qr_code/screens/add_group_screen.dart';
import 'package:chat_365/modules/home_qr_code/screens/navigation_qr_code_screen.dart';
import 'package:chat_365/modules/navigation/screen/navigation_screen.dart';
import 'package:chat_365/modules/new_conversation/screens/create_group_screen.dart';
import 'package:chat_365/modules/new_conversation/screens/login_history/login_history_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/calender_phonecall_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/change_password_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/library_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/profile_chat_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/setting_conversation_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/share_contact_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_chat_screens/support_screen.dart';
import 'package:chat_365/modules/profile/screens/profile_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/contact_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/general_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/general/general_meeting_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/general/ring_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/general/select_ring_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/meeting/auto_connect_audio_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/meeting/meeting_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/meeting/preview_video_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/meeting/ratio_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/meeting_setting_main_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/meeting_setting/message/message_metting_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/message_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/notification_setting_screen.dart';
import 'package:chat_365/modules/profile/screens/setting_screens/setting_screen.dart';
import 'package:chat_365/modules/search/screens/search_contact_screen.dart';
import 'package:chat_365/modules/search/screens/search_contact_v2_screen.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/screens/timekeeping_face_screen.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_qr_timekeeping/screens/scan_qr_timekeeping_screen.dart';
import 'package:chat_365/modules/timekeeping/screens/choose_a_timekeeping_screen.dart';
import 'package:chat_365/modules/timekeeping/screens/timekeeping_company.dart';
import 'package:chat_365/modules/timekeeping/screens/timekeeping_personally.dart';
import 'package:chat_365/router/page_config.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/type_screen_to_otp.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../modules/call/phone_call/screens/main_groupvideocall_screen.dart';
import '../modules/utilities/appointment/screens/appointment_screen.dart';
import '../modules/utilities/appointment/screens/create_appointment_screen.dart';

enum AppPages {
  Splash,
  Intro,
  Initial,
  //
  Auth_option,
  Auth_Login,
  Auth_VerifyRegistration,
  Auth_VerifyRequestUpdatePassword,
  Auth_UpdatePass,
  Auth_ForgotPass,
  Auth_Register,
  Auth_ConfirmOTP,
  Auth_SetUpAccount,
  Auth_SetUpAccount_CreatCubit,
  Auth_SignUpSuccess,
  Auth_ChangePass,
  Auth_ConfirmIdCompany,
  Auth_ScanQR,
  Auth_AddFirstEmployee,
  //
  Navigation,
  //
  //
  Chat_Detail,
  Chat_Detail_PeopleProfile,
  Chat_Detail_GroupProfile,
  Chat_Detail_Profile_AddMember,
  Chat_Detail_SendContactCard,
  Chat_Image,
  Chat_Edit_Image,
  Forward_Message,
  Send_Location,
  //
  NewConversation_CreateGroup,
  NewConversation_CreateGroup_With,
  NewConversation_Create,
  //
  Profile_Self,
  Profile_Friend,
  Profile_Group,
  Invite_Contact,
  Profile_Chat,
  Change_Password,
  Support,
  Setting,
  General_Setting,
  Message_Setting,
  Notification_Setting,
  Meeting_Setting_Main,
  Meeting_Setting,
  Meeting_AutoConnectAudio,
  Meeting_RatioScreen,
  Meeting_PreviewVideo,
  Meeting_RingSetting,
  Meeting_SelectRing,
  MessageMeeting_Setting,
  GeneralMeeting_Setting,
  Contact_Block,
  Send_Contact,
  //
  Calender_Phone_Call,
  Share_Contact,
  Setting_Conversation,
  Library,
  Detail_Image,
  //

  Search,

  //
  Preview,
  Image_Slide,
  Phone_Contact,
  Recieved_AddFriend_Request,
  //
  Face_Timekeeping,
  QR_Timekeeping,
  Choose_A_Timekeeping,
  Navigation_QR_Code,
  Accept_Login_QR,
  Timekeeping_Company_Screen,
  Timekeeping_Personally_Screen,
  Add_Group_Screen,
  Test_123,
  Login_History_Screen,
  //
  Contact_Permission,
  Location_Permission,
  Call,
  Video_Call,
  Group_Video_call,
  Calling_GroupVideo,
  Phone_Video_Come,

  //
  MeetingSchedule_Create,
  AcceptOrDenyAccess,
  EditRegion,
  MyMeeting,
  MyMeetingRoom_Edit,
  MeetingSchedule_Edit,
  MeetingRoomDetail,
  Meeting_Screen,
  MeetingScreen_OverviewSecuritySetting,
  MeetingParticipant_Screen,
  MeetingWhiteBoard_Screen,
  MeetingWhiteBoard_ActionScreen,
  MeetingWhiteBoard_PagesScreen,
  MeetingVoteList_Screen,
  MeetingVote_CreateScreen,
  MeetingVote_EditScreen,
  MeetingVote_Screen,
  MeetingChat_Screen,
  //
  Utils_CreateAppointment,
  Utils_AppointmentScreen,
}

String _getPageArgumentErrorString(List<String> args) => args.join(', ');

void _checkMissingRequiredArgumentsAndAssureError(
    Map<String, dynamic>? arguments, List<String> argNames) {
  try {
    if (arguments == null)
      throw ArgumentError.notNull(_getPageArgumentErrorString(argNames));

    final List<String> missingArgNames =
        argNames.where((e) => arguments.containsKey(e) == false).toList();

    if (missingArgNames.isNotEmpty)
      throw ArgumentError.notNull(_getPageArgumentErrorString(missingArgNames));
  } catch (e) {
    print(e);
    rethrow;
  }
}

extension AppPagesExtension on AppPages {
  String get key => this
      .toString()
      .split('.')
      .last
      .replaceAll(r'_', '.')
      .replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'),
        (Match m) => "_${m.group(0) ?? ''}",
      )
      .toLowerCase();

  String get path => "/${this.key.replaceAll(r'.', '/')}";

  String get name => path;

  static PageConfig getPageConfig(
      AppPages page, Map<String, dynamic>? arguments) {
    switch (page) {
      case AppPages.Splash:

      case AppPages.Initial:
      case AppPages.Intro:
        return PageConfig()..pageBuilder = () => IntroScreen();
      case AppPages.Auth_option:
        _checkMissingRequiredArgumentsAndAssureError(
            arguments, [AuthOptionScreen.authModeArg]);
        final AuthMode mode = arguments![AuthOptionScreen.authModeArg];
        return PageConfig()
          ..pageBuilder = () => AuthOptionScreen(
                mode: mode,
              );
      case AppPages.Auth_Register:
        return PageConfig()
          ..pageBuilder = () => BlocProvider(
              create: (context) => SignUpCubit(context.read<AuthRepo>()),
              child: RegisterScreen());
      case AppPages.Auth_ConfirmIdCompany:
        bool isFormLogin = false;
        if (arguments != null) {
          if (arguments[ConfirmIdCompanyScreen.formLogin] == AuthMode.LOGIN) {
            isFormLogin = true;
          } else {
            isFormLogin = false;
          }
        }
        return PageConfig()
          ..pageBuilder = () => BlocProvider(
              create: (context) => SignUpCubit(context.read<AuthRepo>()),
              child: ConfirmIdCompanyScreen(
                isFormLoginScreen: isFormLogin,
              ));
      case AppPages.Auth_ConfirmOTP:
        _checkMissingRequiredArgumentsAndAssureError(arguments, [
          ConfirmOTPScreen.isPhoneNumberKey,
          ConfirmOTPScreen.idTypeScreenToOtp,
        ]);
        final bool isPhone = arguments![ConfirmOTPScreen.isPhoneNumberKey];
        final TypeScreenToOtp typeScreenToOtp =
            arguments[ConfirmOTPScreen.idTypeScreenToOtp];
        final String? email = arguments[ConfirmOTPScreen.idEmail];
        return PageConfig()
          ..pageBuilder = () => ConfirmOTPScreen(
                isPhoneNumber: isPhone,
                typeScreenToOtp: typeScreenToOtp,
                email: email,
              );
      case AppPages.Auth_AddFirstEmployee:
        return PageConfig()..pageBuilder = () => AddFirstEmployeeScreen();

      case AppPages.Search:
        var contactListCubitArg =
            arguments![SearchContactScreen.contactListCubitArg];
        var showSearchCompanyArg =
            arguments[SearchContactScreen.showSearchCompanyArg];
        var trailingBuilderArg =
            arguments[SearchContactScreen.trailingBuilderArg];
        return PageConfig()..pageBuilder = () => SearchContactV2Screen();
        return PageConfig()
          ..pageBuilder = () => SearchContactScreen(
                contactListCubit: contactListCubitArg,
                showSearchCompany: showSearchCompanyArg,
                trailingBuilder: trailingBuilderArg,
              );

      case AppPages.Share_Contact:
        var filters = arguments![ShareContactScreen.filtersArg];
        var showMoreButton = arguments[ShareContactScreen.showMoreButtonArg];
        var initSearch = arguments[ShareContactScreen.initSearchArg];
        return PageConfig()
          ..pageBuilder = () => ShareContactScreen(
                filters: filters,
                showMoreButton: showMoreButton,
                initSearch: initSearch,
              );

      case AppPages.Image_Slide:
        var initIndex = arguments![ImageMessageSliderScreen.initIndexArg];
        var images = arguments[ImageMessageSliderScreen.imagesArg];
        return PageConfig()
          ..pageBuilder = () => ImageMessageSliderScreen(
                images: images,
                initIndex: initIndex,
              );
      //   return PageConfig()
      //     ..pageBuilder = () => MultiRepositoryProvider(
      //           providers: [
      //             RepositoryProvider(
      //               create: (_) => VerificationRepo(),
      //             ),
      //             if (!hasAuthCubit)
      //               RepositoryProvider(
      //                 create: (context) => AuthRepo(),
      //               ),
      //           ],
      //           child: MultiBlocProvider(
      //             providers: [
      //               BlocProvider(
      //                 create: (context) => VerificationCubit(
      //                   context.read<VerificationRepo>(),
      //                   VerificationKind.signUp,
      //                 ),
      //               ),
      //               if (!hasAuthCubit)
      //                 BlocProvider(
      //                   create: (context) => AuthCubit(
      //                     context.read<AuthRepo>(),
      //                   ),
      //                 ),
      //             ],
      //             child: RegisterScreen(),
      //           ),
      //         );
      case AppPages.Auth_ScanQR:
        return PageConfig()..pageBuilder = () => ScanQRScreen();
      case AppPages.Auth_SetUpAccount:
        final AuthMode mode =
            arguments![SetUpAccountInformationScreen.authModeArg];
        return PageConfig()
          ..pageBuilder = () => SetUpAccountInformationScreen(
                mode: mode,
              );
      case AppPages.Auth_SetUpAccount_CreatCubit:
        final AuthMode mode =
            arguments![SetUpAccountInformationScreen.authModeArg] as AuthMode;
        return PageConfig()
          ..pageBuilder = () => BlocProvider(
              create: (context) => SignUpCubit(context.read<AuthRepo>()),
              child: SetUpAccountInformationScreen(
                mode: mode,
              ));
      case AppPages.Auth_SignUpSuccess:
        final String phoneNumber = arguments!['phone'];
        final String password = arguments['password'];
        final UserType userType = arguments['userType'];
        return PageConfig()
          ..pageBuilder = () => SignUpSuccessScreen(
                password: password,
                phoneNumber: phoneNumber,
                userType: userType,
              );

      // case AppPages.Auth_VerifyRegistration:
      // case AppPages.Auth_VerifyRequestUpdatePassword:
      //   _checkMissingRequiredArgumentsAndAssureError(
      //     arguments,
      //     ['checkOtpSuccessCallback'],
      //   );

      //   final Function(String?) checkOtpSuccessCallback =
      //       arguments!['checkOtpSuccessCallback'];

      //   return PageConfig()
      //     ..pageBuilder = () => InputOtpScreen(
      //           checkOtpSuccessCallback: checkOtpSuccessCallback,
      //         );
      case AppPages.Auth_UpdatePass:
        _checkMissingRequiredArgumentsAndAssureError(
            arguments, [UpdatePasswordScreen.userTypeArg]);

        final UserType userType = arguments![UpdatePasswordScreen.userTypeArg];

        return PageConfig()
          ..pageBuilder = () => UpdatePasswordScreen(
                userType: userType,
              );

      case AppPages.Send_Contact:
        final conversationBasicInfo =
            arguments![SendContactScreen.conversationBasicInfoArg];
        return PageConfig()
          ..pageBuilder = () => SendContactScreen(
                conversationBasicInfo: conversationBasicInfo,
              );

      /// Phiên bản hiện tại đang không dùng chức năng này
      case AppPages.Preview:
        final linkFile = arguments![FilePrevewScreen.linkFileArg];
        return PageConfig()
          ..pageBuilder = () => FilePrevewScreen(
                linkFile: linkFile,
              );

      case AppPages.Navigation:
        return PageConfig()..pageBuilder = () => NavigationScreen();

      case AppPages.Chat_Detail:
        var isGroup = arguments![ChatScreen.isGroupArg] ?? false;
        var senderId = arguments[ChatScreen.senderIdArg];
        var conversationId = arguments[ChatScreen.conversationIdArg];
        var messageDisplay = arguments[ChatScreen.messageDisplayArg];
        var chatItemModel = arguments[ChatScreen.chatItemModelArg];
        var action = arguments[ChatScreen.actionArg];
        return PageConfig()
          ..pageBuilder = () => ChatScreen(
                isGroup: isGroup,
                senderId: senderId,
                conversationId: conversationId,
                messageDisplay: messageDisplay,
                chatItemModel: chatItemModel,
                action: action,
              );

      case AppPages.Forward_Message:
        var message = arguments![ForwardMessageScreen.messageArg];
        var senderInfo = arguments[ForwardMessageScreen.senderInfoArg];
        return PageConfig()
          ..pageBuilder = () => ForwardMessageScreen(
                message: message,
                senderInfo: senderInfo,
              );

      case AppPages.Invite_Contact:
        var userInfo = arguments![InviteContactScreen.userInfoArg];
        return PageConfig()
          ..pageBuilder = () => InviteContactScreen(
                userInfo: userInfo,
              );

      case AppPages.Send_Location:
        return PageConfig()..pageBuilder = () => SendLocationScreen();
      case AppPages.Utils_CreateAppointment:
        final argIsCreate = arguments![CreateAppointmentScreen.argIsCreate];
        return PageConfig()
          ..pageBuilder = () => CreateAppointmentScreen(
                isCreate: argIsCreate,
              );

      case AppPages.Utils_AppointmentScreen:
        final argIsAdmin = arguments![AppointmentScreen.argIsAdmin];
        return PageConfig()
          ..pageBuilder = () => AppointmentScreen(
                isAdmin: argIsAdmin,
              );

      // case AppPages.Chat_Detail:
      //   _checkMissingRequiredArgumentsAndAssureError(
      //     arguments,
      //     [
      //       'id',
      //       'model',
      //       'members',
      //       'totalNumberOfMessages',
      //       'isGroup',
      //     ],
      //   );

      //   final int id = arguments!['id'];
      //   final model = arguments['model'];
      //   final members = arguments['members'];
      //   final totalNumberOfMessages = arguments['totalNumberOfMessages'];
      //   final bool isGroup = arguments['isGroup'];

      //   print("total messages: ${totalNumberOfMessages}");

      //   return PageConfig()
      //     ..pageBuilder = () => MultiRepositoryProvider(
      //           providers: [
      //             RepositoryProvider(
      //               create: (context) => ChatInfoRepo(
      //                 context.read<UserNameRepo>(),
      //               ),
      //             ),
      //             RepositoryProvider(
      //               create: (context) => ChatMessageRepo(
      //                 userNameRepo: context.read<UserNameRepo>(),
      //                 chatInfoRepo: context.read<ChatInfoRepo>(),
      //                 chatId: id,
      //                 members: members,
      //               ),
      //             ),
      //             RepositoryProvider(
      //               create: (context) => SendMessageRepo(
      //                 conversationId: id,
      //                 senderId: AuthRepo.id!,
      //                 members: members,
      //                 userNameRepo: context.read<UserNameRepo>(),
      //               ),
      //             ),
      //           ],
      //           child: MultiBlocProvider(
      //             providers: [
      //               BlocProvider(
      //                 create: (context) => SendMessageCubit(
      //                   context.read<SendMessageRepo>(),
      //                 ),
      //               ),
      //               BlocProvider(
      //                 create: (context) => ChatMessageCubit(
      //                   repo: context.read<ChatMessageRepo>(),
      //                   userNameRepo: context.read<UserNameRepo>(),
      //                   totalNumberOfMessages: totalNumberOfMessages,
      //                   messagesRepo: context.read<ChatMessagesRepo>(),
      //                   sendMessageCubit: context.read<SendMessageCubit>(),
      //                   chatInfo: model,
      //                   isGroup: isGroup,
      //                 ),
      //               ),
      //             ],
      //             child: ChatDetailScreen(),
      //           ),
      //         );
      // case AppPages.Chat_Detail_PeopleProfile:
      //   _checkMissingRequiredArgumentsAndAssureError(
      //     arguments,
      //     ['chatId', 'model'],
      //   );

      //   final chatId = arguments!['chatId'];
      //   final model = arguments['model'];

      //   return PageConfig()
      //     ..pageBuilder = () => MultiRepositoryProvider(
      //           providers: [
      //             RepositoryProvider(
      //               create: (context) => ChatInfoRepo(
      //                 context.read<UserNameRepo>(),
      //               ),
      //             ),
      //             RepositoryProvider(
      //               create: (_) => PeopleProfileRepo(),
      //             ),
      //           ],
      //           child: BlocProvider(
      //             create: (context) => PeopleProfileCubit(
      //               chatId: chatId,
      //               model: model,
      //               chatInfoRepo: context.read<ChatInfoRepo>(),
      //               peopleProfileRepo: context.read<PeopleProfileRepo>(),
      //             ),
      //             child: PeopleProfileScreen(),
      //           ),
      //         );
      // case AppPages.Chat_Detail_GroupProfile:
      //   _checkMissingRequiredArgumentsAndAssureError(
      //     arguments,
      //     ['chatId', 'model'],
      //   );

      //   final chatId = arguments!['chatId'];
      //   final model = arguments['model'];

      //   return PageConfig()
      //     ..pageBuilder = () => MultiRepositoryProvider(
      //           providers: [
      //             RepositoryProvider(
      //               create: (context) => ChatInfoRepo(
      //                 context.read<UserNameRepo>(),
      //               ),
      //             ),
      //             RepositoryProvider(
      //               create: (_) => GroupProfileRepo(chatId),
      //             ),
      //             RepositoryProvider(
      //               create: (_) => MemberChangedNotificationMessageRepo(
      //                 conversationId: chatId,
      //                 senderId: AuthRepo.id!,
      //               ),
      //             ),
      //           ],
      //           child: BlocProvider(
      //             create: (context) => GroupProfileCubit(
      //               chatId: chatId,
      //               model: model,
      //               chatInfoRepo: context.read<ChatInfoRepo>(),
      //               groupProfileRepo: context.read<GroupProfileRepo>(),
      //               notificationMessageRepo:
      //                   context.read<MemberChangedNotificationMessageRepo>(),
      //             ),
      //             child: GroupProfileScreen(),
      //           ),
      //         );
      // case AppPages.Chat_Detail_Profile_AddMember:
      //   return PageConfig()
      //     ..transition = trans.Transition.fadeIn
      //     ..pageBuilder = () => RepositoryProvider(
      //           create: (_) => ContactListRepo(),
      //           child: BlocProvider(
      //             create: (context) => SelectContactCubit(
      //               ContactSelectionMode.many,
      //               context.read<ContactListRepo>(),
      //             ),
      //             child: AddMemberScreen(),
      //           ),
      //         );
      // case AppPages.Chat_Detail_SendContactCard:
      //   return PageConfig()
      //     ..transition = trans.Transition.fadeIn
      //     ..pageBuilder = () => RepositoryProvider(
      //           create: (_) => ContactListRepo(),
      //           child: BlocProvider(
      //             create: (context) => SelectContactCubit(
      //               ContactSelectionMode.many,
      //               context.read<ContactListRepo>(),
      //             ),
      //             child: SendContactCardScreen(),
      //           ),
      //         );

      // case AppPages.Chat_Image:
      //   _checkMissingRequiredArgumentsAndAssureError(
      //     arguments,
      //     ['imageProvider', 'heroTag'],
      //   );
      case AppPages.Chat_Edit_Image:
        _checkMissingRequiredArgumentsAndAssureError(
          arguments,
          ['image'],
        );

        final XFile image = arguments!['type'];
        return PageConfig()
          ..pageBuilder = () => ImageEditScreen(
                image: image,
              );

      //   final imageProvider = arguments!['imageProvider'];
      //   final heroTag = arguments['heroTag'];

      //   return PageConfig()
      //     ..transition = trans.Transition.fadeIn
      //     ..pageBuilder = () => ChatImageViewerScreen(
      //           imageProvider: imageProvider,
      //           heroTag: heroTag,
      //         );
      case AppPages.NewConversation_CreateGroup:
        _checkMissingRequiredArgumentsAndAssureError(
          arguments,
          ['type'],
        );

        final type = arguments!['type'];

        return PageConfig()
          ..pageBuilder = () => CreateGroupScreen(conversationType: type);
      case AppPages.NewConversation_CreateGroup_With:
        _checkMissingRequiredArgumentsAndAssureError(
          arguments,
          ['type', 'userInfo'],
        );

        final type = arguments!['type'];
        final userInfo = arguments['userInfo'];

        return PageConfig()
          ..pageBuilder = () => CreateGroupScreen(
                conversationType: type,
                userInfo: userInfo,
                setGroupName: false,
              );
      // case AppPages.NewConversation_Create:
      //   _checkMissingRequiredArgumentsAndAssureError(arguments, ['type']);

      //   final type = arguments!['type'];

      //   return PageConfig()
      //     ..pageBuilder = () => MultiRepositoryProvider(
      //           providers: [
      //             RepositoryProvider(
      //               create: (_) => ContactListRepo(),
      //             ),
      //             RepositoryProvider(
      //               create: (_) => ConversationCreationRepo(),
      //             ),
      //           ],
      //           child: MultiBlocProvider(
      //             providers: [
      //               BlocProvider(
      //                 create: (context) => SelectContactCubit(
      //                   ContactSelectionMode.single,
      //                   context.read<ContactListRepo>(),
      //                 ),
      //               ),
      //               BlocProvider(
      //                 create: (context) => CreateConversationCubit(
      //                   selectContactCubit: context.read<SelectContactCubit>(),
      //                   repo: context.read<ConversationCreationRepo>(),
      //                 ),
      //               ),
      //             ],
      //             child: CreateConversationScreen(
      //               conversationType: type,
      //             ),
      //           ),
      //         );

      case AppPages.Auth_Login:
        var userType = arguments![LoginScreen.userTypeArg] as UserType;
        final AuthMode? authMode = arguments[LoginScreen.authMode];
        return PageConfig()
          ..pageBuilder = () => LoginScreen(
                userType: userType,
                mode: authMode,
              );
      case AppPages.Auth_ForgotPass:
        var userType = arguments![ForgotPasswordScreen.userTypeArg] as UserType;
        return PageConfig()
          ..pageBuilder = () => BlocProvider(
              create: (context) => SignUpCubit(context.read<AuthRepo>()),
              child: ForgotPasswordScreen(userType: userType));

      case AppPages.Profile_Self:
        var userInfo = arguments![ProfileScreen.userInfoArg];
        var isGroup = arguments[ProfileScreen.isGroupArg];
        return PageConfig()
          ..pageBuilder = () => ProfileScreen(
                userInfo: userInfo,
                isGroup: isGroup,
              );
      case AppPages.Profile_Chat:
        var userInfo = arguments![ProfileChatScreen.userInfoArg];
        var isGroup = arguments[ProfileChatScreen.isGroupArg];
        return PageConfig()
          ..pageBuilder = () => ProfileChatScreen(
                userInfo: userInfo,
                isGroup: isGroup,
              );

      // case AppPages.Profile_Group:
      //   var conversationId = arguments![GroupProfileScreen.conversationIdArg];
      //   return PageConfig()
      //     ..pageBuilder = () => GroupProfileScreen(
      //           conversationId: conversationId,
      //         );
      // case AppPages.Profile_Chat:
      //   var userInfo = arguments![ProfileScreen.userInfoArg];
      //   var isGroup = arguments[ProfileScreen.isGroupArg];
      //   return PageConfig()
      //     ..pageBuilder = () => ProfileChatScreen(
      //           userInfo: userInfo,
      //           isGroup: isGroup,
      //         );
      case AppPages.Change_Password:
        var userInfo = arguments![ProfileScreen.userInfoArg];
        var isGroup = arguments[ProfileScreen.isGroupArg];
        return PageConfig()
          ..pageBuilder = () => BlocProvider(
                create: (context) => SignUpCubit(context.read<AuthRepo>()),
                child: ChangePasswordScreen(
                  isGroup: isGroup,
                  userInfo: userInfo,
                ),
              );
      case AppPages.Support:
        return PageConfig()..pageBuilder = () => SupportScreen();
      case AppPages.Setting:
        return PageConfig()..pageBuilder = () => SettingScreen();
      case AppPages.General_Setting:
        return PageConfig()..pageBuilder = () => GeneralSettingScreen();
      case AppPages.Message_Setting:
        return PageConfig()..pageBuilder = () => MessageSettingScreen();
      case AppPages.Notification_Setting:
        return PageConfig()..pageBuilder = () => NotificationSettingScreen();
      case AppPages.Contact_Block:
        return PageConfig()..pageBuilder = () => ContactBlockScreen();
      case AppPages.Calender_Phone_Call:
        var userInfo = arguments![ProfileScreen.userInfoArg];
        var isGroup = arguments[ProfileScreen.isGroupArg];
        return PageConfig()
          ..pageBuilder = () => CalenderPhoneCallScreen(
                userInfo: userInfo,
                isGroup: isGroup,
                isUser: true,
              );
      case AppPages.Setting_Conversation:
        var userInfo = arguments![ProfileScreen.userInfoArg];
        return PageConfig()
          ..pageBuilder = () => SettingConversationScreen(
                userInfo: userInfo,
              );

      case AppPages.Library:
        var userInfo = arguments![LibraryScreen.userInfoArg];
        var initMessageType = arguments[LibraryScreen.initMessageTypeArg];
        var libraryCubit = arguments[LibraryScreen.libraryCubitArg];
        return PageConfig()
          ..pageBuilder = () => LibraryScreen(
                userInfo: userInfo,
                initMessageType: initMessageType,
                libraryCubit: libraryCubit,
              );

      case AppPages.Detail_Image:
        final arg = arguments!['listWidgetImage'];
        return PageConfig()
          ..pageBuilder = () => WidgetSlider(
                images: arg,
                initIndex: 1,
              );

      case AppPages.Phone_Contact:
        return PageConfig()..pageBuilder = () => AllSuggestContactScreen();

      case AppPages.Recieved_AddFriend_Request:
        return PageConfig()..pageBuilder = () => RecievedFriendRequest();

      ///
      case AppPages.Face_Timekeeping:
        return PageConfig()..pageBuilder = () => FaceTimekeepingScreen();

      case AppPages.Choose_A_Timekeeping:
        return PageConfig()..pageBuilder = () => ChooseATimekeepingScreen();
      case AppPages.QR_Timekeeping:
        return PageConfig()..pageBuilder = () => ScanQRTimekeepingScreen();
      case AppPages.Navigation_QR_Code:
        return PageConfig()..pageBuilder = () => NavigationQRCodeScreen();
      case AppPages.Accept_Login_QR:
        return PageConfig()..pageBuilder = () => AcceptLoginScreen();
      case AppPages.Timekeeping_Company_Screen:
        return PageConfig()..pageBuilder = () => TimekeepingCompanyScreen();
      case AppPages.Timekeeping_Personally_Screen:
        return PageConfig()..pageBuilder = () => TimekeepingPersonallyScreen();
      case AppPages.Add_Group_Screen:
        return PageConfig()..pageBuilder = () => AddGroupScreen();

      case AppPages.Contact_Permission:
        var callBack = arguments![ContactPermissionPage.callBackArg];

        return PageConfig()
          ..pageBuilder = () => ContactPermissionPage(
                callBack: callBack,
              );

      case AppPages.Location_Permission:
        var callBack = arguments![LocationPermissionPage.callBackArg];

        return PageConfig()
          ..pageBuilder = () => LocationPermissionPage(
                callBack: callBack,
              );

      case AppPages.Call:
        final argUserInfo = arguments![MainPhoneCallScreen.arugUserInfo];
        return PageConfig()
          ..pageBuilder = () => MainPhoneCallScreen(
                userInfo: argUserInfo,
              );
      case AppPages.Video_Call:
        // final argUserInfo = arguments![MainPhoneVideoScreen.arugUserInfo];
        final userInfo = arguments!['userInfor'];
        final idRoom = arguments['idRoom'];
        final idCaller = arguments['idCaller'];
        final idCallee = arguments['idCallee'] as List<int>;
        final checkCallee = arguments['checkCallee'];
        final idConversation = arguments['idConversation'];
        // final argUserContacInfo =
        //     arguments[MainPhoneVideoScreen.arugContacUserInfo];

        return PageConfig()
          ..pageBuilder = () => MainPhoneVideoScreen(
                userInfo: userInfo,
                idRoom: idRoom,
                idCaller: idCaller,
                idCallee: idCallee,
                idConversation: idConversation,
                checkCallee: checkCallee,
              );
      //   VideoCallOneOne(
      //     // userInfo: argUserInfo,
      // idCaller: idCaller,
      // idCallee: idCallee,
      // idConversation: idConversation,
      //   );
      case AppPages.Calling_GroupVideo:
        // final argUserContacInfo =
        //     arguments[MainPhoneVideoScreen.arugContacUserInfo];

        return PageConfig()..pageBuilder = () => CallingGroupVideo();
      case AppPages.Group_Video_call:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MainGroupVideoCallScreen();
      case AppPages.Calling_GroupVideo:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => CallingGroupVideo();

      case AppPages.MeetingSchedule_Create:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => CreateMeetingSchedule();
      case AppPages.AcceptOrDenyAccess:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => AcceptOrDenyAccessScreen();
      case AppPages.EditRegion:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => EditRegionScreen();
      case AppPages.MyMeeting:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MyMeetingScreen();
      case AppPages.MyMeetingRoom_Edit:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => EditMyMeetingRoomScreen();
      case AppPages.MeetingSchedule_Edit:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => EditMeetingSchedule();
      case AppPages.MeetingRoomDetail:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MeetingRoomDetailScreen();
      case AppPages.Meeting_Setting_Main:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MeetingSettingMainScreen();
      case AppPages.Meeting_Setting:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MeetingSettingScreen();
      case AppPages.MessageMeeting_Setting:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MessageMeetingSettingScreen();
      case AppPages.GeneralMeeting_Setting:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => GeneralMeetingSettingScreen();
      case AppPages.Meeting_AutoConnectAudio:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => AutoConnectAudioScreen();
      case AppPages.Meeting_RatioScreen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => RatioScreen();
      case AppPages.Meeting_RingSetting:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => RingSettingScreen();
      case AppPages.Meeting_SelectRing:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => SelectRingScreen();
      case AppPages.Meeting_PreviewVideo:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => PreviewVideoScreen();
      case AppPages.Meeting_Screen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MeetingScreen();
      case AppPages.MeetingScreen_OverviewSecuritySetting:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()
          ..pageBuilder = () => OverviewSecuritySettingScreen();

      case AppPages.MeetingParticipant_Screen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => ParticipantScreen();
      case AppPages.MeetingWhiteBoard_Screen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => WhiteBoardScreen();
      case AppPages.MeetingWhiteBoard_ActionScreen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => WhiteBoardActionScreen();
      case AppPages.MeetingWhiteBoard_PagesScreen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => WhiteBoardPagesScreen();
      case AppPages.MeetingVoteList_Screen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => VoteListScreen();
      case AppPages.MeetingVote_CreateScreen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => CreateNewVoteScreen();
      case AppPages.MeetingVote_EditScreen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => EditVoteScreen();
      case AppPages.MeetingVote_Screen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => VoteScreen();
      case AppPages.MeetingChat_Screen:
        // final arg = arguments!['listWidgetImage'];
        return PageConfig()..pageBuilder = () => MeetingChatScreen();

      case AppPages.Test_123:
        var userType = arguments!['userType'] as UserType;
        final AuthMode? authMode = arguments[LoginScreen.authMode];
        return PageConfig()
          ..pageBuilder = () => CheckAccountScreen(
                userType: userType,
                mode: authMode,
              );
      case AppPages.Login_History_Screen:
        return PageConfig()..pageBuilder = () => LoginHistoryScreen();

      default:
        throw StateError(
            "Missing page: ${page.toString()} in AppPagesExtension.getPageConfig()");
    }
  }
}
