import 'dart:async';
import 'dart:io';

import 'package:chat_365/common/blocs/chat_library_cubit/cubit/chat_library_cubit.dart';
import 'package:chat_365/common/blocs/network_cubit/network_cubit.dart';
import 'package:chat_365/common/blocs/unread_message_counter_cubit/unread_message_counter_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/blocs/user_info_bloc/repo/user_info_repo.dart';
import 'package:chat_365/common/components/choice_dialog_item.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/common/widgets/library_display_message_content.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_bar.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/new_conversation/conversation_creation_repo.dart';
import 'package:chat_365/modules/new_conversation/create_conversation_cubit/create_conversation_cubit.dart';
import 'package:chat_365/modules/new_conversation/models/group_conversation_creation_kind.dart';
import 'package:chat_365/modules/profile/profile_cubit/profile_cubit.dart';
import 'package:chat_365/modules/profile/profile_cubit/profile_state.dart';
import 'package:chat_365/modules/profile/repos/group_profile_repo.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/permission_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

TextStyle _style(BuildContext context, {Color? color}) =>
    AppTextStyles.regularW500(
      context,
      size: 14,
      lineHeight: 22,
      color: color ?? context.theme.textColor,
    );
List<AssetImage> listImage = [
  AssetImage(
    Images.img_profile_test_1,
  ),
  AssetImage(
    Images.img_profile_test_2,
  ),
  AssetImage(
    Images.img_profile_test_3,
  ),
  AssetImage(
    Images.img_profile_test_4,
  ),
];

class ProfileChatScreen extends StatefulWidget {
  const ProfileChatScreen({
    Key? key,
    required this.userInfo,
    required this.isGroup,
  }) : super(key: key);

  static const userInfoArg = 'userInfoArg';
  static const isGroupArg = 'isGroupArg';

  final IUserInfo userInfo;
  final bool isGroup;

  @override
  State<ProfileChatScreen> createState() => _ProfileChatScreenState();
}

class _ProfileChatScreenState extends State<ProfileChatScreen> {
  late final ValueNotifier<int?> _conversationId;
  late final ChatLibraryCubit _chatLibraryCubit;
  TextEditingController _textNameController = TextEditingController();
  bool _isEdit = false;
  bool _isShowAllMember = false;
  late final int currentUserId;
  late final ChatBloc _chatBloc;
  late final ProfileCubit _profileCubit;
  late final UserInfoBloc _userInfoBloc;
  late final ChatConversationBloc _chatConversationBloc;
  ChatDetailBloc? _chatDetailBloc;
  //Hỗ trợ xóa thành viên trong nhóm
  late int indexMemberDelete;
  bool _isFavorited = false;
  ExceptionError? _getConversationIdLastError;
  late final StreamSubscription _networkSubscription;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textLinkController = TextEditingController();

  var _imagePicked;

  //Dung file picker de gioi han dinh dang file
  //Dung image picker de lay anh tu camera
  final _imagePicker = ImagePicker();

  File? fileAvatar;
  //Pick from Gallery
  _pickImageFromGallery() async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
          textDelegate: VietnameseAssetPickerTextDelegate(),
        ),
      );

      if (result != null) {
        _imagePicked = await result[0].file;
        if (_imagePicked != null) fileAvatar = _imagePicked;
      }
    } catch (e) {}
  }

  _imgFromGallery() => SystemUtils.permissionCallback(
        PermissionExt.libraryPermission,
        _pickImageFromGallery,
      );

  //Pick from Camera
  _imgFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    _imagePicked = image;
    if (_imagePicked != null) fileAvatar = File(_imagePicked.path);
  }

  _changeName(
      IUserInfo userInfo, bool isGroup, int userMainId, int userMainType) {
    setState(() {
      _isEdit = !_isEdit;
      _textNameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textNameController.text.length));
      if (_isEdit)
        _focusNode.requestFocus();
      else {
        _profileCubit.changeNickName(
          _textNameController.text,
          userInfo,
          isGroup,
          userMainId,
          userMainType,
          isGroup ? _chatDetailBloc!.listUserInfoBlocs.keys.toList() : [],
        );
        _focusNode.unfocus();
      }
    });
  }

  get isCurrentUser => currentUserId == widget.userInfo.id;
  get isGroup => widget.isGroup;

  @override
  void initState() {
    _networkSubscription =
        context.read<NetworkCubit>().stream.listen((networkState) {
      if (networkState.hasInternet &&
          _getConversationIdLastError?.isNetworkException == true) {
        _getConversationId(widget.userInfo.id);
      }
    });

    _profileCubit = ProfileCubit(
      widget.userInfo.id,
      isGroup: widget.isGroup,
    );

    currentUserId = context.userInfo().id;

    _chatBloc = context.read<ChatBloc>();

    _chatConversationBloc = context.read<ChatConversationBloc>();

    var favoriteConversations = _chatConversationBloc.favoriteConversations;

    try {
      _chatDetailBloc = context.read<ChatDetailBloc>();
    } catch (e) {
      if (widget.isGroup)
        _chatDetailBloc = ChatDetailBloc(
          conversationId: widget.userInfo.id,
          userInfoRepo: context.read<UserInfoRepo>(),
          isGroup: widget.isGroup,
          unreadMessageCounterCubit: context
                  .read<ChatConversationBloc>()
                  .unreadMessageCounteCubits[widget.userInfo.id] ??
              UnreadMessageCounterCubit(
                conversationId: widget.userInfo.id,
                countUnreadMessage: 0,
              ),
          chatRepo: chatRepo,
          senderId: context.userInfo().id,
        )..add(ChatDetailEventLoadConversationDetail());
    }

    if (widget.userInfo is ConversationBasicInfo && widget.userInfo.id != -1) {
      _isFavorited = favoriteConversations[
              (widget.userInfo as ConversationBasicInfo).conversationId] !=
          null;
      _conversationId = ValueNotifier(
          (widget.userInfo as ConversationBasicInfo).conversationId);

      _chatLibraryCubit = ChatLibraryCubit(_conversationId.value!);
    } else {
      _conversationId = ValueNotifier(_chatDetailBloc?.conversationId);
      try {
        _chatLibraryCubit = ChatLibraryCubit(
          _conversationId.value!,
          chatDetailBloc: _chatDetailBloc,
        );
      } catch (e) {
        if (widget.userInfo != currentUserId)
          _getConversationId(widget.userInfo.id);
      }
      for (var value in favoriteConversations.values) {
        if (!value.isGroup) {
          var index =
              value.memberList.indexWhere((e) => e.id == widget.userInfo.id);
          if (index != -1) {
            _isFavorited = true;
            break;
          }
        }
      }
    }

    _userInfoBloc = UserInfoBloc(
      widget.userInfo,
    );

    _textLinkController.text = 'https://join.chat365.vn/code';
    _textNameController.text = widget.userInfo.name;
    super.initState();
  }

  _getConversationId(int userId) async {
    try {
      _conversationId.value =
          await _profileCubit.getConversationId(currentUserId, userId);
      _getConversationIdLastError = null;
      _chatLibraryCubit = ChatLibraryCubit(
        _conversationId.value!,
        chatDetailBloc: _chatDetailBloc,
      );
    } on CustomException catch (e) {
      _getConversationIdLastError = e.error;
    }
  }

  _addNewMemberToGroup() {
    GroupProfileRepo groupProfileRepo;
    try {
      groupProfileRepo = context.read<GroupProfileRepo>();
    } catch (e) {
      groupProfileRepo = GroupProfileRepo(
        widget.userInfo.id,
        widget.isGroup,
      );
    }
    AppRouterHelper.toSelectListUserCheckBox(
      context,
      repo: [
        groupProfileRepo,
      ],
      title: 'Thêm thành viên vào nhóm',
      onSubmitted: (users) async {
        return groupProfileRepo.addMember(
          newMemberIds: users.map((e) => e.id).toList(),
          oldMemberIds: _chatDetailBloc!.listUserInfoBlocs.keys,
        );
      },
      onSuccess: (users) {
        var currentTick = DateTimeExt.currentTicks;
        for (int i = 0; i < users.length; i++)
          _chatBloc.sendMessage(
            ApiMessageModel(
              messageId: GeneratorService.generateMessageId(
                currentUserId,
                currentTick + 0,
              ),
              conversationId:
                  (widget.userInfo as ConversationBasicInfo).conversationId,
              senderId: currentUserId,
              message:
                  '$currentUserId added ${users[i].id} to this consersation',
              type: MessageType.notification,
            ),
            memberIds: [
              ..._chatDetailBloc!.listUserInfoBlocs.keys,
              ...users.map((e) => e.id)
            ],
          );
      },
    );
  }

  @override
  void dispose() {
    _userInfoBloc.close();
    _textNameController.dispose();
    _networkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 20,
          minVerticalPadding: 0,
        ),
      ),
      child: BlocProvider.value(
        value: _profileCubit,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            leading: Align(
              alignment: Alignment.topLeft,
              child: BackButton(
                color: AppColors.white,
              ),
            ),
            toolbarHeight: 70 + 100 + 20,
            flexibleSpace: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 125,
                  decoration: BoxDecoration(
                    gradient: context.theme.gradient,
                  ),
                ),
                Column(
                  children: [
                    SizedBoxExt.h70,
                    PopupMenuButton(
                      enabled: widget.isGroup,
                      offset: Offset(30, 30),
                      padding: EdgeInsets.zero,
                      color: AppColors.whiteLilac,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onSelected: (value) async {
                        if (value == 1) {
                          await _imgFromCamera();
                        } else {
                          await _imgFromGallery();
                        }
                        if (fileAvatar != null) {
                          widget.isGroup
                              ? _profileCubit.changeAvatar(
                                  fileAvatar: fileAvatar!,
                                  idConversation:
                                      _chatDetailBloc!.conversationId,
                                  members: _chatDetailBloc!
                                      .listUserInfoBlocs.keys
                                      .toList())
                              : _profileCubit.changeAvatar(
                                  fileAvatar: fileAvatar!, members: []);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              height: double.minPositive,
                              // padding: EdgeInsets.all(6),
                              // padding: EdgeInsets.zero,
                              value: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Chụp ảnh',
                                      // style:AppTextStyles.titleDropdownItem,
                                    ),
                                  ],
                                ),
                              )),
                          PopupMenuItem(
                            height: double.minPositive,
                            // padding: EdgeInsets.zero,
                            value: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Tải ảnh từ thư viện',
                                    // style:AppTextStyles.titleDropdownItem,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      child: BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          if (state is ChangeAvatarStateError) {
                            AppDialogs.toast('Thay đổi ảnh đại diện thất bại');
                          }
                        },
                        builder: (context, state) {
                          if (state is ChangeAvatarStateLoading) {
                            return Stack(
                              children: [
                                DisplayImageWithStatusBadge(
                                  model: widget.userInfo,
                                  isGroup: widget.isGroup,
                                  userStatus: widget.userInfo.userStatus,
                                  size: 100,
                                  enable: false,
                                ),
                                CircleAvatar(
                                  radius: 100 / 2,
                                  backgroundColor: Colors.transparent,
                                  child: Padding(
                                    padding: AppPadding.paddingAll10,
                                    child: CircularProgressIndicator(
                                        color: context.theme.primaryColor),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return BlocBuilder<UserInfoBloc, UserInfoState>(
                              bloc: _userInfoBloc,
                              builder: (context, state) {
                                return DisplayImageWithStatusBadge(
                                  model: widget.userInfo,
                                  isGroup: widget.isGroup,
                                  userStatus: widget.userInfo.userStatus,
                                  size: 100,
                                  enable: false,
                                  badge:
                                      widget.isGroup ? const SizedBox() : null,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    SizedBoxExt.h10,
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextField(
                            controller: _textNameController,
                            //  widget.userInfo.name,
                            // maxLines: 2,
                            textAlign: TextAlign.center,
                            focusNode: _focusNode,
                            readOnly: !_isEdit,
                            style:
                                AppTextStyles.nameCustomerProfileChat(context),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 5),
                              isCollapsed: true,
                              isDense: true,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle:
                                  new TextStyle(color: const Color(0xFF424242)),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          top: 0,
                          right: 10,
                          child: GestureDetector(
                            child: BlocConsumer<ProfileCubit, ProfileState>(
                              listener: (context, state) {
                                if (state is ChangeNameStateDone) {
                                  AppDialogs.toast('Thay đổi tên thành công');
                                } else if (state is ChangeNameStateError) {
                                  _textNameController.text =
                                      widget.userInfo.name;
                                  AppDialogs.toast('Thay đổi tên thất bại');
                                }
                              },
                              builder: (context, state) {
                                if (state is ChangeNameStateLoading) {
                                  return SizedBox(
                                    width: 25,
                                    height: 20,
                                    child: Align(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                                return SvgPicture.asset(
                                  _isEdit ? Images.ic_tick : Images.ic_pencil,
                                  color: context.theme.primaryColor,
                                );
                              },
                            ),
                            onTap: () => _changeName(
                                widget.userInfo,
                                widget.isGroup,
                                context.userInfo().id,
                                context.userType().id),
                          ),
                        ),
                      ],
                    ),
                    if (_focusNode.hasFocus)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: context.theme.primaryColor,
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //message
                  if (!isCurrentUser)
                    UnderlineWidget(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          AssetPath.chat,
                          width: 24,
                          color: context.theme.iconColor,
                        ),
                        title: Text(
                          'Gửi tin nhắn',
                          style: _style(
                            context,
                          ),
                        ),
                        onTap: () {
                          _chatBloc.tryToChatScreen(
                            chatInfo: widget.userInfo,
                            isGroup: widget.isGroup,
                          );
                        },
                      ),
                    ),
                  //call
                  !isCurrentUser
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              AssetPath.phone,
                              color: context.theme.iconColor,
                              width: 24,
                            ),
                            title: Text(
                              'Bắt đầu cuộc gọi',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () {
                              AppDialogs.toast('Gọi điện thành công');
                              // AppRouter.back(context);
                            },
                          ),
                        )
                      : SizedBox(),
                  //gọi video
                  !isCurrentUser
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_video_call,
                              width: 24,
                              color: context.theme.iconColor,
                            ),
                            title: Text(
                              'Bắt đầu cuộc gọi video',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () {
                              AppDialogs.toast('Gọi điện video thành công');
                              // AppRouter.back(context);
                            },
                          ),
                        )
                      : SizedBox(),
                  //lên lịch cuộc gọi
                  !isCurrentUser
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_calendar_phone,
                              width: 24,
                              color: context.theme.iconColor,
                            ),
                            title: Text(
                              'Lên lịch cuộc gọi',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () {
                              AppRouterHelper.toCalenderPhoneCallPage(context,
                                  userInfo: widget.userInfo,
                                  isGroup: widget.isGroup);
                            },
                          ),
                        )
                      : SizedBox(),
                  //bắt đầu cuộc trò chuyện riêng tư
                  !isCurrentUser && !widget.isGroup
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_chat_private,
                              width: 24,
                              color: context.theme.iconColor,
                            ),
                            title: Text(
                              'Bắt đầu cuộc trò chuyện riêng tư',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () {
                              // AppRouter.back(context);
                              AppDialogs.toast(
                                  'Đãc thêm vào cuộng trò chuyện riêng tư.');
                            },
                          ),
                        )
                      : SizedBox(),
                  //tạo nhóm
                  !isCurrentUser && !widget.isGroup
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_fluent_people_add,
                              color: context.theme.iconColor,
                            ),
                            title: Text(
                              'Tạo nhóm với ${widget.userInfo.name}',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () => AppRouter.toPage(
                              context,
                              AppPages.NewConversation_CreateGroup_With,
                              blocValue: CreateConversationCubit(
                                repo: ConversationCreationRepo(),
                              ),
                              arguments: {
                                'type': GroupConversationCreationKind.public,
                                'userInfo': widget.userInfo,
                                // 'chatMessagesRepo': context.read<ChatMessagesRepo>(),
                                // 'userNameRepo': context.read<UserNameRepo>(),
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                  // user,
                  if (!widget.isGroup)
                    UnderlineWidget(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          isCurrentUser
                              ? Images.ic_share_2
                              : Images.ic_contact_card,
                          color: context.theme.iconColor,
                        ),
                        title: Text(
                          isCurrentUser ? 'Chia sẻ hồ sơ' : 'Chia sẻ liên hệ',
                          style: _style(
                            context,
                          ),
                        ),
                        onTap: () {
                          !isCurrentUser
                              ? AppRouterHelper.toShareContactPage(
                                  context,
                                  showMoreButton: false,
                                  // initSearch: '',
                                  filters: [FilterContactsBy.none],
                                )
                              : AppRouterHelper.toInviteContactPage(
                                  context,
                                  userInfo: widget.userInfo,
                                );
                        },
                      ),
                    ),
                  //user name in chat
                  isCurrentUser
                      ? UnderlineWidget(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Images.ic_contact_card,
                                        color: context.theme.iconColor,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        'Tên Chat365',
                                        style: _style(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  widget.userInfo.name,
                                  style: AppTextStyles.introDescription,
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  //email
                  isCurrentUser
                      ? UnderlineWidget(
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: widget.userInfo.email != null ? 12 : 0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 12, 10, 12),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Images.ic_email,
                                        color: context.theme.iconColor,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        'Email',
                                        style: _style(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.userInfo.email != null
                                    ? Text(
                                        widget.userInfo.email!,
                                        style: AppTextStyles.introDescription,
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  //thêm vào yêu thích
                  !isCurrentUser
                      ? UnderlineWidget(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Thêm vào liên hệ yêu thích',
                                          style: _style(context),
                                        ),
                                      ),
                                      SwitchButton(
                                        initValue: _isFavorited,
                                        onChanged: (value) async {
                                          var conversationId;
                                          try {
                                            conversationId = isGroup
                                                ? widget.userInfo.id
                                                : await _profileCubit
                                                    .getConversationId(
                                                    currentUserId,
                                                    widget.userInfo.id,
                                                  );
                                            return (await _chatConversationBloc
                                                    .changeFavoriteConversation(
                                              conversationId,
                                              favorite: value ? 1 : 0,
                                            ))
                                                ?.error;
                                          } catch (e, s) {
                                            logger.logError(e, s);
                                            return 'Thay đổi trạng thái yêu thích thất bại';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        )
                      : SizedBox(),
                  // //date of birth
                  // if (!widget.isGroup)
                  //   UnderlineWidget(
                  //     child: Padding(
                  //       padding: EdgeInsets.only(bottom: 10),
                  //       child: Wrap(
                  //         crossAxisAlignment: WrapCrossAlignment.center,
                  //         direction: Axis.horizontal,
                  //         alignment: WrapAlignment.start,
                  //         children: [
                  //           Padding(
                  //             padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  //             child: Row(
                  //               // mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 SvgPicture.asset(
                  //                   Images.ic_gift,
                  //
                  //                 ),
                  //                 SizedBox(
                  //                   width: 16,
                  //                 ),
                  //                 Text(
                  //                   'Ngày sinh',
                  //                   style: _style(
                  //                     context,
                  //
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           Text(
                  //             '',
                  //             style: AppTextStyles.introDescription,
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  //Sao chép liên kết đến hồ sơ
                  if (!isCurrentUser)
                    UnderlineWidget(
                      child: InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                              ClipboardData(text: _textLinkController.text));
                          AppDialogs.toast('Đã lưu vào bộ nhớ tạm');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 12, 10, 12),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Sao chép liên kết đến ${widget.isGroup ? 'nhóm' : 'hồ sơ'}',
                                      style: _style(
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _textLinkController.text,
                                style: context.theme.hintStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  //danh sách thành viên nhóm
                  if (widget.isGroup)
                    UnderlineWidget(
                      child: BlocProvider.value(
                        value: _chatDetailBloc!,
                        child: BlocListener<ProfileCubit, ProfileState>(
                          listener: (context, state) {
                            if (state is RemoveMemberStateLoading) {
                            } else if (state is RemoveMemberStateDone) {
                              AppDialogs.toast('Xóa thành viên thành công');
                              setState(() {
                                _chatDetailBloc!.listUserInfoBlocs.removeWhere(
                                  (key, value) => key == indexMemberDelete,
                                );
                              });
                            } else if (state is RemoveMemberStateError) {
                              AppDialogs.toast('Xóa thành viên thất bại');
                            }
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBoxExt.h15,
                                ValueListenableBuilder<int>(
                                    valueListenable: _chatDetailBloc!
                                        .countConversationMember,
                                    builder: (context, count, __) {
                                      return Text(
                                        'Thành viên ($count)',
                                        style: _style(context),
                                      );
                                    }),
                                SizedBoxExt.h15,
                                TextButton.icon(
                                  onPressed: _addNewMemberToGroup,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  icon: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: context.theme.iconColor
                                          .withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: context.theme.backgroundColor,
                                    ),
                                  ),
                                  label: Text(
                                    'Thêm thành viên',
                                    style: context.theme.userListTileTextTheme,
                                  ),
                                ),
                                SizedBoxExt.h10,
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        context.mediaQuerySize.height / 2,
                                  ),
                                  child: BlocBuilder<ChatDetailBloc,
                                      ChatDetailState>(
                                    buildWhen: (_, current) => current
                                        is ChatDetailStateLoadDetailDone,
                                    builder: (context, state) {
                                      var items = _chatDetailBloc!
                                          .listUserInfoBlocs.values
                                          .toList();
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return ListView.separated(
                                          key: ValueKey(items.length),
                                          shrinkWrap: true,
                                          physics: _isShowAllMember
                                              ? const AlwaysScrollableScrollPhysics()
                                              : const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var item = items[index].userInfo;
                                            return GestureDetector(
                                              onTap: () {
                                                if (item.id !=
                                                    navigatorKey.currentContext!
                                                        .userInfo()
                                                        .id) {
                                                  AppDialogs.showChoicesDialog(
                                                      context,
                                                      choices: [
                                                        ChoiceDialogItem(
                                                          value: 'Gửi tin nhắn',
                                                          onTap: () {
                                                            _chatBloc
                                                                .tryToChatScreen(
                                                              chatInfo: item,
                                                              isGroup: false,
                                                            );
                                                          },
                                                        ),
                                                        ChoiceDialogItem(
                                                          value:
                                                              'Xóa người tham gia',
                                                          onTap: () async {
                                                            var error =
                                                                await _profileCubit
                                                                    .deleteMember(
                                                              item,
                                                              _chatDetailBloc!
                                                                  .listUserInfoBlocs
                                                                  .keys
                                                                  .toList(),
                                                            );

                                                            if (error == null) {
                                                              setState(() {});
                                                            }
                                                          },
                                                        ),
                                                      ]);
                                                }
                                              },
                                              child: UserListTile(
                                                userName: item.name,
                                                avatar:
                                                    DisplayImageWithStatusBadge(
                                                  model: item,
                                                  isGroup: false,
                                                  userStatus: item.userStatus,
                                                  enable: false,
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: _isShowAllMember
                                              ? _chatDetailBloc!
                                                  .listUserInfoBlocs.length
                                              : _chatDetailBloc!
                                                  .listUserInfoBlocs.length
                                                  .clamp(0, 5)
                                                  .toInt(),
                                          separatorBuilder: (context, int) =>
                                              SizedBoxExt.h10,
                                        );
                                      });
                                    },
                                  ),
                                ),
                                SizedBoxExt.h15,
                                BlocBuilder<ChatDetailBloc, ChatDetailState>(
                                  buildWhen: (_, current) =>
                                      current is ChatDetailStateLoadDetailDone,
                                  builder: (_, state) {
                                    if (_chatDetailBloc!
                                            .listUserInfoBlocs.length >=
                                        5)
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isShowAllMember =
                                                !_isShowAllMember;
                                          });
                                        },
                                        child: Text(
                                          _isShowAllMember
                                              ? 'Thu gọn'
                                              : 'Hiển thị thêm',
                                          style: AppTextStyles.regularW700(
                                            context,
                                            size: 14,
                                          ).copyWith(
                                            color: context.theme.primaryColor,
                                          ),
                                        ),
                                      );
                                    return const SizedBox();
                                  },
                                ),
                                SizedBoxExt.h15,
                              ]),
                        ),
                      ),
                    ),

                  //change password
                  isCurrentUser
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_lock,
                              color: context.theme.iconColor,
                            ),
                            title: Text(
                              'Đổi mật khẩu',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () {
                              AppRouter.toPage(
                                context,
                                AppPages.Change_Password,
                                arguments: {
                                  ProfileChatScreen.userInfoArg:
                                      widget.userInfo,
                                  ProfileChatScreen.isGroupArg: widget.isGroup,
                                },
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                  //images
                  !isCurrentUser
                      ? Padding(
                          padding: AppPadding.paddingVertical18,
                          child: ValueListenableBuilder<int?>(
                              valueListenable: _conversationId,
                              builder: (context, conversationId, _) {
                                if (conversationId == null)
                                  return const SizedBox();
                                return _LibraryGridView(
                                  userInfo: widget.userInfo,
                                  conversationId: conversationId,
                                  chatLibraryCubit: _chatLibraryCubit,
                                );
                              }),
                        )
                      : SizedBox(),
                  //Cài đặt cuộc trò chuyện
                  if (!isCurrentUser)
                    UnderlineWidget(
                      child: ListTile(
                        title: Text(
                          'Cài đặt cuộc trò chuyện',
                          style: _style(
                            context,
                          ),
                        ),
                        onTap: () {
                          AppRouter.toPage(
                            context,
                            AppPages.Setting_Conversation,
                            arguments: {
                              ProfileChatScreen.userInfoArg: widget.userInfo,
                            },
                          );
                        },
                      ),
                    ),
                  //Xóa khỏi danh sách liên hệ
                  if (!isCurrentUser)
                    UnderlineWidget(
                      child: ListTile(
                        title: Text(
                          'Xóa khỏi danh sách liên hệ',
                          style: _style(
                            context,
                          ),
                        ),
                        onTap: () {
                          AppDialogs.showConfirmDialog(context,
                              title: 'Xóa liên hệ', onFunction: (_) {
                            //Xóa khỏi danh sách liên hệ
                            return null;
                          },
                              content: Padding(
                                padding: AppPadding.paddingVertical20,
                                child: Text(
                                  'Bạn có chắn chắn muốn xóa liên hệ này?',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.regularW400(context,
                                      size: 14),
                                ),
                              ),
                              successMessage:
                                  'Xóa thông tin liên hệ thành công',
                              nameFunction: 'Xóa');
                        },
                      ),
                    ),
                  //Chặn liên hệ
                  if (!isCurrentUser && isGroup)
                    ListTile(
                      title: Text(
                        'Rời khỏi cuộc trò chuyện',
                        style: _style(context, color: AppColors.red),
                      ),
                      onTap: () {
                        AppDialogs.showConfirmDialog(
                          context,
                          title: 'Rời khỏi cuộc trò chuyện',
                          onFunction: (_) async {
                            return await _profileCubit.deleteMember(
                              context.userInfo(),
                              _chatDetailBloc!.listUserInfoBlocs.keys.toList(),
                            );
                          },
                          onSuccess: () {
                            var conversationId =
                                (widget.userInfo as ConversationBasicInfo)
                                    .conversationId;
                            _chatConversationBloc.onOutGroup(
                              conversationId,
                              context.userInfo().id,
                            );
                            AppRouter.backToPage(context, AppPages.Navigation);
                          },
                          content: Padding(
                            padding: AppPadding.paddingVertical20,
                            child: Text(
                              'Bạn có chắn chắn muốn rời khỏi cuộc trò chuyện này ?',
                              textAlign: TextAlign.center,
                              style:
                                  AppTextStyles.regularW400(context, size: 14),
                            ),
                          ),
                          successMessage: 'Rời khỏi cuộc trò chuyện thành công',
                          nameFunction: 'Đồng ý',
                        );
                      },
                    ),
                  //support
                  isCurrentUser
                      ? UnderlineWidget(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_question,
                            ),
                            title: Text(
                              'Trợ giúp và phản hồi',
                              style: _style(
                                context,
                              ),
                            ),
                            onTap: () {
                              AppRouter.toPage(
                                context,
                                AppPages.Support,
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryGridView extends StatelessWidget {
  const _LibraryGridView({
    Key? key,
    required this.userInfo,
    required int conversationId,
    required ChatLibraryCubit chatLibraryCubit,
  })  : _conversationId = conversationId,
        _chatLibraryCubit = chatLibraryCubit,
        super(key: key);

  final IUserInfo userInfo;
  final int _conversationId;
  final ChatLibraryCubit _chatLibraryCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              Images.ic_images,
              color: context.theme.iconColor,
            ),
            SizedBoxExt.w10,
            Text(
              'Thư viện trò chuyện',
              style: AppTextStyles.regularW700(context, size: 14),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                AppRouterHelper.toLibraryPage(
                  context,
                  userInfo: userInfo,
                  libraryCubit: _chatLibraryCubit,
                );
              },
              child: Text(
                'Xem thêm',
                textAlign: TextAlign.end,
                style: AppTextStyles.regularW700(context, size: 14).copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
            )
          ],
        ),
        SizedBoxExt.h20,
        BlocProvider.value(
          value: _chatLibraryCubit,
          child: BlocBuilder<ChatLibraryCubit, ChatLibraryState>(
            bloc: _chatLibraryCubit,
            buildWhen: (_, current) => current is ChatLibraryStateLoadSuccess,
            builder: (context, state) {
              if (state is ChatLibraryStateLoadSuccess) {
                if (_chatLibraryCubit.first4Files.isEmpty)
                  return Container(
                    height: 120,
                    color: Colors.indigo[900],
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Thư viện này đang trống\n\n',
                        style: AppTextStyles.regularW500(
                          context,
                          size: 18,
                          color: AppColors.white,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Ảnh, tệp và liên kết web được chia sẻ trong cuộc trò chuyện sẽ xuất hiện ở đây',
                            style: AppTextStyles.regularW400(
                              context,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    mainAxisExtent: 120,
                  ),
                  padding: EdgeInsets.all(1),
                  itemCount: _chatLibraryCubit.first4Files.length,
                  itemBuilder: (context, index) {
                    var item = _chatLibraryCubit.first4Files[index];
                    return InkWell(
                      child: LibraryDisplayMessageContent(
                        fileMessage: item,
                      ),
                      onTap: () {
                        AppRouterHelper.toLibraryPage(
                          context,
                          userInfo: userInfo,
                          messageType: item.type!,
                          libraryCubit: _chatLibraryCubit,
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

class _ChangeStatusTextFieldListTile extends StatefulWidget {
  const _ChangeStatusTextFieldListTile({
    Key? key,
    required this.initStatus,
  }) : super(key: key);

  final String initStatus;

  @override
  State<_ChangeStatusTextFieldListTile> createState() =>
      __ChangeStatusTextFieldListTileState();
}

class __ChangeStatusTextFieldListTileState
    extends State<_ChangeStatusTextFieldListTile> {
  late final ProfileCubit _profileCubit;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _profileCubit = context.read<ProfileCubit>();
    _controller.text = widget.initStatus;
  }

  bool _isEdit = false;

  Widget _buildTrailing(
    BuildContext context,
  ) =>
      InkWell(
        child: SvgPicture.asset(
          _isEdit ? Images.ic_tick : Images.ic_pencil,
        ),
        onTap: _changeMode,
      );

  _changeMode() {
    setState(() => _isEdit = !_isEdit);
    if (_isEdit)
      _focusNode.requestFocus();
    else
      _profileCubit.changeStatus(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        Images.ic_emoji,
      ),
      dense: true,
      trailing: _buildTrailing(context),
      title: TextField(
        style: _style(
          context,
        ),
        readOnly: !_isEdit,
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
      ),
    );
  }
}

class UnderlineWidget extends StatelessWidget {
  const UnderlineWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        Divider(
          thickness: 1,
          height: 1,
          color: AppColors.greyCC,
        ),
      ],
    );
  }
}
