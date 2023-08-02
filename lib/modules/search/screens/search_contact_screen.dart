import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/ellipsized_text.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/screens/contact_screen.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchContactScreen extends StatefulWidget {
  SearchContactScreen({
    Key? key,
    required this.contactListCubit,
    this.trailingBuilder,
    this.showSearchCompany = true,
  }) : super(key: key);

  static const String contactListCubitArg = 'contactListCubitArg';
  static const String trailingBuilderArg = 'trailingBuilderArg';
  static const String showSearchCompanyArg = 'showSearchCompanyArg';

  final ContactListCubit contactListCubit;
  final Function(ConversationBasicInfo)? trailingBuilder;
  final bool showSearchCompany;

  @override
  State<SearchContactScreen> createState() => _SearchContactScreenState();
}

class _SearchContactScreenState extends State<SearchContactScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  late final TextEditingControllerDebouncer _debouncer;
  late final ChatBloc _chatBloc;
  late final int? currentUserComId;

  @override
  void initState() {
    super.initState();

    _chatBloc = context.read<ChatBloc>();
    currentUserComId = context.userInfo().companyId;

    // if (_contactListCubit.filterContactsBy.value == null)
    //   _contactListCubit.setPreSearchAllData();

    _controller.text = widget.contactListCubit.initSearch ?? '';

    _debouncer = TextEditingControllerDebouncer(_call, controller: _controller);

    _focusNode.requestFocus();
  }

  ContactListCubit get _contactListCubit => widget.contactListCubit;

  FilterContactsBy? get _currentFilter =>
      _contactListCubit.filterContactsBy.value;

  bool _isConversationDisplay({String? name}) =>
      _currentFilter == FilterContactsBy.conversations ||
      name == StringConst.group;

  _callBack(String keyword) => _contactListCubit.search(keyword);

  _call() => _callBack(_controller.text);

  _onTapMoreButton(String header) {
    FilterContactsBy? filter;
    if (header == StringConst.company)
      filter = FilterContactsBy.allInCompany;
    else if (header == StringConst.peoples)
      filter = FilterContactsBy.myContacts;
    else if (header == StringConst.all)
      filter = FilterContactsBy.none;
    else if (header == StringConst.group)
      filter = FilterContactsBy.conversations;
    return AppRouterHelper.toSearchContactPage(
      context,
      contactListCubit: ContactListCubit(
        _contactListCubit.repo,
        initFilter: filter,
        searchGroupConversationOnly: header == StringConst.group,
        initSearch: _controller.text,
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              gradient: context.theme.gradient,
            ),
          ),
        ),
        leading: BackButton(color: AppColors.white),
        title: TextField(
          style: AppTextStyles.regularW400(
            context,
            size: 16,
            lineHeight: 22,
            color: AppColors.white,
          ),
          controller: _controller,
          focusNode: _focusNode,
          cursorColor: AppColors.white,
          cursorHeight: 25,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm',
            hintStyle: AppTextStyles.regularW400(
              context,
              size: 16,
              lineHeight: 22,
              color: AppColors.white,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: BlocBuilder<ContactListCubit, ContactListState>(
          bloc: _contactListCubit,
          builder: (context, state) {
            if (state is LoadSuccessState) {
              if (_currentFilter == null) {
                var allContacts = state.allContact;
                var group = Map.fromIterables(
                  allContacts.keys.map(
                    (e) => e.searchContactHeaderDisplayName,
                  ),
                  allContacts.values,
                );
                if (!widget.showSearchCompany)
                  group
                    ..remove(FilterContactsBy
                        .allInCompany.searchContactHeaderDisplayName)
                    ..remove(FilterContactsBy
                        .conversations.searchContactHeaderDisplayName);
                return GrouppedList<ConversationBasicInfo>(
                  group: group,
                  subGroupBuilder: (_, header, listItems) {
                    return listItems.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextHeader(text: header),
                              const SizedBox(height: 15),
                              ...listItems,
                              if (_currentFilter == null)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    child: Text('Xem thêm'),
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    onPressed: () => _onTapMoreButton(header),
                                  ),
                                ),
                            ],
                          );
                  },
                  groupItemBuilder: (_, header, ConversationBasicInfo contact) {
                    final bool isConversationDisplay =
                        _isConversationDisplay(name: header);
                    return _itemBuilder(
                      context,
                      contact: contact,
                      isConversationDisplay: isConversationDisplay,
                      isContactInCompany: contact.companyId == currentUserComId,
                    );
                  },
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  var contact = state.contactList[index];
                  return _itemBuilder(
                    context,
                    contact: contact,
                    isConversationDisplay: _isConversationDisplay(),
                    isContactInCompany: contact.companyId == currentUserComId,
                  );
                },
                itemCount: state.contactList.length,
              );
            }
            if (state is LoadFailedState) {
              return AppErrorWidget(
                error: state.message,
                onTap: _contactListCubit.loadContact,
              );
            }
            return WidgetUtils.centerLoadingCircle;
          },
        ),
      ),
    );
  }

  Padding _itemBuilder(
    BuildContext context, {
    required ConversationBasicInfo contact,
    required bool isContactInCompany,
    bool isConversationDisplay = false,
  }) {
    final UserInfoBloc? userInfoBloc = !isConversationDisplay
        ? null
        : UserInfoBloc(
            contact,
          );
    userInfoBloc?.close();
    return Padding(
      padding: EdgeInsets.only(bottom: isConversationDisplay ? 2 : 24),
      child: !isConversationDisplay
          ? Row(
              children: [
                Expanded(
                  child: UserListTile(
                    avatar: DisplayAvatar(
                      isGroup: contact.isGroup,
                      // userStatus: contact.userStatus,
                      model: contact,
                    ),
                    userName: contact.name,
                    bottom: Text(
                      contact.status ?? '',
                      style: context.theme.userStatusTextStyle,
                    ),
                    onTapUserName: () {
                      return _chatBloc.tryToChatScreen(
                        chatInfo: contact,
                        isNeedToFetchChatInfo: true,
                      );
                    },
                  ),
                ),
                if (!isContactInCompany)
                  FriendButton(
                    key: ValueKey(contact.id),
                    contact: contact,
                  ),
              ],
            )
          : GroupConversationItemBuilder(info: contact),
    );
  }
}

class GroupConversationItemBuilder extends StatelessWidget {
  const GroupConversationItemBuilder({
    Key? key,
    required this.info,
    this.avatarSize = 40,
  }) : super(key: key);

  final ConversationBasicInfo info;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.75,
      height: 22 / 16.75,
      color: context.theme.isDarkTheme ? AppColors.white : AppColors.black,
    );
    return InkWell(
      onTap: () => context.read<ChatBloc>().tryToChatScreen(
            chatInfo: info,
            isGroup: true,
            isNeedToFetchChatInfo: true,
          ),
      child: Ink(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            DisplayAvatar(
              model: info,
              isGroup: true,
              size: avatarSize,
              enable: false,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EllipsizedText(
                    info.name,
                    maxLines: 1,
                    style: textStyle,
                  ),
                  Text(
                    '${info.totalGroupMemebers} thành viên',
                    maxLines: 1,
                    style: textStyle,
                  ),
                  Container(
                    height: 0.5,
                    margin: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    color: AppColors.greyCC,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendButton extends StatefulWidget {
  const FriendButton({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final IUserInfo contact;

  @override
  State<FriendButton> createState() => _FriendButtonState();
}

class _FriendButtonState extends State<FriendButton> {
  late FriendStatus _status;
  late VoidCallback _onTap;
  DialogState _state = DialogState.init;

  @override
  void initState() {
    super.initState();
    _status = widget.contact.friendStatus ?? FriendStatus.unknown;
  }

  @override
  void didUpdateWidget(covariant FriendButton oldWidget) {
    if (widget.contact.friendStatus != null)
      _status = widget.contact.friendStatus!;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;
    final Color textColor;

    /// Mình gửi lời mời đi
    if (_status == FriendStatus.send) {
      text = StringConst.cancelAddFriend;
      color = AppColors.orange;
      textColor = AppColors.white;
      _onTap = () async {
        setState(() {
          _state = DialogState.processing;
        });
        var isSuccess =
            await context.read<FriendCubit>().deleteRequestAddFriend(
                  context.userInfo().id,
                  widget.contact.id,
                );
        setState(() {
          if (isSuccess) {
            _state = DialogState.success;
            widget.contact.friendStatus = _status = FriendStatus.unknown;
          } else
            _state = DialogState.init;
        });
      };
    }

    // /// Đã là bạn bè
    // else if (_status == FriendStatus.send) {
    //   text = StringConst.cancelFriend;
    //   color = Color(0xFFD6D9F5);
    //   textColor = AppColors.primary;
    // }

    /// Chưa có tương tác bạn bè
    else if (_status == FriendStatus.unknown) {
      text = StringConst.addFriend;
      color = AppColors.primary;
      textColor = AppColors.white;
      _onTap = () async {
        context.read<ChatBloc>().tryToChatScreen(
              chatInfo: widget.contact,
              isNeedToFetchChatInfo: true,
            );

        setState(() {
          _state = DialogState.processing;
        });
        var error = await context.read<FriendCubit>().addFriend(widget.contact);
        setState(() {
          if (error == null) {
            _state = DialogState.success;
            widget.contact.friendStatus = _status = FriendStatus.send;
          } else
            _state = DialogState.init;
        });
      };
    }

    /// Người khác gửi lời mời
    // else if (_status == FriendStatus.request) {
    //   text = StringConst.agree;
    //   color = AppColors.lawnGreen;
    //   textColor = AppColors.white;
    // }

    /// Khác
    else {
      text = '';
      color = Colors.transparent;
      textColor = Colors.transparent;
    }

    return SizedBox(
      height: 30,
      child: text.isEmpty
          ? null
          : _state == DialogState.processing
              ? SizedBox.square(
                  dimension: 15,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : ElevatedButton(
                  onPressed: _onTap,
                  style: ElevatedButton.styleFrom(
                    primary: color,
                  ),
                  child: Text(
                    text,
                    style: AppTextStyles.regularW500(
                      context,
                      size: 14,
                      lineHeight: 16,
                      color: textColor,
                    ),
                  ),
                ),
    );
  }
}
