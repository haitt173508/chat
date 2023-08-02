import 'dart:async';

import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/modules/contact/screens/contact_screen.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareContactScreen extends StatefulWidget {
  const ShareContactScreen({
    Key? key,
    required this.filters,
    this.initSearch,
    this.showMoreButton = true,
  }) : super(key: key);

  static const String filtersArg = 'filtersArg';
  static const String initSearchArg = 'initSearchArg';
  static const String showMoreButtonArg = 'showMoreButtonArg';

  /// Các filter hiển thị
  ///
  /// DS có thể bao gồm [
  ///
  ///   - FilterContactsBy.none,
  /// ]
  final List<FilterContactsBy> filters;
  final String? initSearch;
  final bool showMoreButton;

  @override
  State<ShareContactScreen> createState() => _ShareContactScreenState();
}

class _ShareContactScreenState extends State<ShareContactScreen> {
  final FocusNode _focusNode = FocusNode();
  Timer? _throttle;
  final TextEditingController _controller = TextEditingController();

  ContactListCubit? _noneFilterCubit;
  ContactListCubit? _conversationFilterCubit;
  ContactListCubit? _contactFilterCubit;

  List<ConversationBasicInfo> _noneFilterList = [];
  List<ConversationBasicInfo> _conversationFilterList = [];
  List<ConversationBasicInfo> _contactFilterList = [];

  ValueNotifier<DialogState> _state = ValueNotifier(DialogState.processing);

  ContactListState _noneFilterState = LoadingState(FilterContactsBy.none);
  ContactListState _conversationFilterState =
      LoadingState(FilterContactsBy.conversations);
  ContactListState _contactFilterState =
      LoadingState(FilterContactsBy.myContacts);

  StreamSubscription? _s1, _s2, _s3;

  bool get hasNoneFilter => widget.filters.contains(FilterContactsBy.none);

  bool get hasContactFilter =>
      widget.filters.contains(FilterContactsBy.myContacts);

  bool get hasConversationFilter =>
      widget.filters.contains(FilterContactsBy.conversations);

  late final int? _limitDisplay;

  List<int> listIdSended = [];
  @override
  void initState() {
    super.initState();
    var user = context.userInfo();
    _controller.text = widget.initSearch ?? '';

    _limitDisplay = widget.showMoreButton ? 5 : null;

    var contactListRepo = ContactListRepo(user.id, companyId: user.companyId!);
    if (hasNoneFilter) {
      _noneFilterCubit = ContactListCubit(
        contactListRepo,
        initFilter: FilterContactsBy.none,
      );
      _s1 = _noneFilterCubit?.stream.listen((event) {
        _noneFilterState = event;
        _checkState();
      });
    }
    if (hasConversationFilter) {
      _conversationFilterCubit = ContactListCubit(
        contactListRepo,
        searchGroupConversationOnly: true,
        initFilter: FilterContactsBy.conversations,
      );
      _s2 = _conversationFilterCubit?.stream.listen((event) {
        _conversationFilterState = event;
        _checkState();
      });
    }
    if (hasContactFilter) {
      _contactFilterCubit = ContactListCubit(
        contactListRepo,
        initFilter: FilterContactsBy.myContacts,
      );
      _s3 = _contactFilterCubit?.stream.listen((event) {
        _contactFilterState = event;
        _checkState();
      });
    }
    _controller.addListener(_debouncer);
    _focusNode.requestFocus();
  }

  _checkState() {
    var states = [
      if (hasNoneFilter) _noneFilterState,
      if (hasConversationFilter) _conversationFilterState,
      if (hasContactFilter) _contactFilterState,
    ];
    if (states.any((e) => e is LoadFailedState)) {
      _state.value = DialogState.init;
    } else if (states.every((e) => e is LoadSuccessState)) {
      if (hasNoneFilter)
        _noneFilterList = [
          ...(_noneFilterState as LoadSuccessState).contactList
        ];
      if (hasConversationFilter)
        _conversationFilterList = [
          ...(_conversationFilterState as LoadSuccessState).contactList
        ];
      if (hasContactFilter)
        _contactFilterList = [
          ...(_contactFilterState as LoadSuccessState).contactList
        ];
      _state.value = DialogState.success;
    } else
      _state.value = DialogState.processing;
  }

  bool _isGroupDisplay(String name) => name == StringConst.group;

  _callBack(String keyword) {
    _noneFilterCubit?.search(keyword);
    _conversationFilterCubit?.search(keyword);
    _contactFilterCubit?.search(keyword);
  }

  _debouncer() {
    if (_throttle?.isActive ?? true) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      _callBack(_controller.text);
    });
  }

  @override
  void dispose() {
    _s1?.cancel();
    _s2?.cancel();
    _s3?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Chia sẻ liên hệ',
          style: AppTextStyles.regularW700(
            context,
            size: 18,
            color: context.theme.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: context.theme.inputStyle,
              controller: _controller,
              focusNode: _focusNode,
              cursorColor: context.theme.textColor,
              decoration: context.theme.inputDecoration.copyWith(
                suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(Images.ic_uil_search)),
                hintText: 'Tìm kiếm',
              ),
            ),
            SizedBoxExt.h15,
            Expanded(
              child: ValueListenableBuilder<DialogState>(
                valueListenable: _state,
                builder: (context, value, child) {
                  if (value == DialogState.processing) {
                    return WidgetUtils.centerLoadingCircle;
                  }

                  /// Error
                  else if (value == DialogState.init) {
                    return AppErrorWidget(
                      error: 'Đã có lỗi xảy ra, vui lòng thử lại',
                    );
                  }

                  var group = <String, List<ConversationBasicInfo>>{};

                  group[StringConst.peoples] =
                      _noneFilterList.slice(end: _limitDisplay);
                  group[StringConst.phoneBook] =
                      _contactFilterList.slice(end: _limitDisplay);
                  group[StringConst.group] =
                      _conversationFilterList.slice(end: _limitDisplay);

                  return GrouppedList<ConversationBasicInfo>(
                      group: group,
                      subGroupBuilder: (_, header, listItems) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listItems.isEmpty
                              ? []
                              : [
                                  if (!_isGroupDisplay(header))
                                    TextHeader(text: header),
                                  const SizedBox(height: 15),
                                  ...listItems,
                                ],
                        );
                      },
                      groupItemBuilder:
                          (_, header, ConversationBasicInfo contact) {
                        final bool hadSend = listIdSended.firstWhere(
                              (element) => element == contact.id,
                              orElse: () {
                                return 0;
                              },
                            ) !=
                            0;
                        return Padding(
                            padding: EdgeInsets.only(
                                bottom: _isGroupDisplay(header) ? 2 : 24),
                            child: !_isGroupDisplay(header)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: UserListTile(
                                          avatar: DisplayImageWithStatusBadge(
                                            isGroup: contact.isGroup,
                                            userStatus: contact.userStatus,
                                            model: contact,
                                          ),
                                          userName: contact.name,
                                        ),
                                      ),
                                      RoundedButton(
                                        label: hadSend ? 'Đã gửi' : 'Gửi',
                                        fillStyle: hadSend,
                                        color: context.theme.primaryColor,
                                        onPressed: () {
                                          if (!hadSend)
                                            setState(() {
                                              listIdSended.add(contact.id);
                                            });
                                          //Chia sẻ thông tin liên hệ
                                        },
                                      )
                                    ],
                                  )
                                : SizedBox());
                        // Row(
                        //     children: [
                        //       MultiBlocProvider(
                        //         providers: [
                        //           BlocProvider(
                        //             create: (_) => UserInfoBloc(
                        //               contact,
                        //               userInfoRepo: UserInfoRepo(),
                        //             ),
                        //           ),
                        //           BlocProvider(
                        //             create: (_) =>
                        //                 UnreadMessageCounterCubit(
                        //               context.read<ChatRepo>(),
                        //               conversationId:
                        //                   contact.conversationId,
                        //               countUnreadMessage:
                        //                   contact.countUnreadMessage ??
                        //                       0,
                        //             ),
                        //           ),
                        //           BlocProvider(
                        //             create: (_) => TypingDetectorBloc(
                        //                 contact.conversationId),
                        //           ),
                        //         ],
                        //         child: ConversationItem(
                        //           padding:
                        //               EdgeInsets.symmetric(vertical: 8),
                        //           conversationBasicInfo: contact,
                        //           message:
                        //               contact.lastConversationMessage ??
                        //                   '',
                        //           createdAt: contact
                        //               .lastConversationMessageTime!,
                        //         ),
                        //       ),
                        //     ],
                        //   ));
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SearchContactAppBar extends StatelessWidget with PreferredSizeWidget {
//   const SearchContactAppBar({
//     Key? key,
//     required this.callBack,
//     this.initText = '',
//   }) : super(key: key);

//   final ValueChanged<String> callBack;
//   final String initText;

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(56);
// }
