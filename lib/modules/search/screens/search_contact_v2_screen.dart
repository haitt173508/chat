import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/send_message_search_appbar.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/screens/chat_conversation_screen.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/modules/search/screens/search_contact_screen.dart';
import 'package:chat_365/modules/search/screens/search_contact_v2_detail_screen.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchContactV2Screen extends StatefulWidget {
  const SearchContactV2Screen({
    Key? key,
    Widget Function(ConversationBasicInfo)? itemBuilder,
    this.onTapMoreButton,
    this.appbarBottom,
  })  : _itemBuilder = itemBuilder ?? kDefaultItemBuilder,
        super(key: key);

  final Widget Function(ConversationBasicInfo) _itemBuilder;
  final Function(FilterContactsBy, String)? onTapMoreButton;
  final PreferredSizeWidget? appbarBottom;

  @override
  State<SearchContactV2Screen> createState() => _SearchContactV2ScreenState();
}

class _SearchContactV2ScreenState extends State<SearchContactV2Screen> {
  final TextEditingController _controller = TextEditingController();
  late final TextEditingControllerDebouncer _debouncer;
  final ValueNotifier<DialogState> _state = ValueNotifier(DialogState.init);

  @override
  void initState() {
    super.initState();
    _debouncer = TextEditingControllerDebouncer(
      () => searchContactCubits.searchAll(_controller.text),
      controller: _controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: searchContactCubits,
      child: Scaffold(
        appBar: SendMessageSearchAppBar(
          controller: _controller,
          onSubmit: searchContactCubits.searchAll,
          stateNotifier: _state,
        ),
        body: BlocConsumer<ContactListCubit, ContactListState>(
          listener: (_, state) {
            if (state is LoadingState)
              _state.value = DialogState.processing;
            else if (state is LoadSuccessState)
              _state.value = DialogState.success;
            else
              _state.value = DialogState.init;
          },
          buildWhen: (_, current) => current is LoadSuccessState,
          builder: (context, state) {
            if (state is LoadSuccessState)
              return CustomScrollView(
                slivers: [
                  if (widget.appbarBottom != null)
                    SliverToBoxAdapter(
                      child: widget.appbarBottom,
                    ),
                  _groupBuilder(
                    state.allContact[FilterContactsBy.allInCompany] ?? [],
                    header: FilterContactsBy
                        .allInCompany.searchContactHeaderDisplayName,
                    filter: FilterContactsBy.allInCompany,
                  ),
                  _groupBuilder(
                    state.allContact[FilterContactsBy.conversations] ?? [],
                    header: FilterContactsBy
                        .conversations.searchContactHeaderDisplayName,
                    filter: FilterContactsBy.conversations,
                  ),
                  _groupBuilder(
                    state.allContact[FilterContactsBy.none] ?? [],
                    header:
                        FilterContactsBy.none.searchContactHeaderDisplayName,
                    filter: FilterContactsBy.none,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              );
            return const SizedBox();
            // if (state is LoadFailedState) {
            //   return AppErrorWidget(
            //     error: state.message,
            //     onTap: searchContactCubits.loadContact,
            //   );
            // }
            // return WidgetUtils.centerLoadingCircle;
          },
        ),
      ),
    );
  }

  _groupBuilder(
    List<ConversationBasicInfo> users, {
    required String header,
    required FilterContactsBy filter,
  }) {
    return SliverList(
      delegate: SliverChildListDelegate(
        users.isNotEmpty
            ? [
                SmallHeader(
                  text: header,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                ),
                ...users.map((e) => widget._itemBuilder(e)),
                _showMoreButton(filter),
              ]
            : [],
      ),
    );
  }

  _showMoreButton(FilterContactsBy filter) {
    return InkWell(
      onTap: () {
        if (widget.onTapMoreButton != null)
          widget.onTapMoreButton!(filter, _controller.text);
        else
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => ContactListCubit(
                  searchContactCubits.repo,
                  initFilter: filter,
                  initSearch: _controller.text,
                  searchGroupConversationOnly:
                      filter == FilterContactsBy.conversations,
                ),
                child: SearchContactV2DetailScreen(
                  initSearch: _controller.text,
                  itemBuilder: widget._itemBuilder,
                ),
              ),
            ),
          );
      },
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          'Xem thêm',
          style: AppTextStyles.regularW400(
            context,
            size: 14,
            lineHeight: 22,
            color: context.theme.primaryColor,
          ),
        ),
      ),
    );
  }
}

Widget kDefaultItemBuilder(
  ConversationBasicInfo user,
) {
  return Builder(builder: (context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: UserListTile(
              avatar: DisplayAvatar(
                isGroup: user.isGroup,
                model: user,
                size: 40,
              ),
              userName: user.name,
              bottom: Text(
                user.isGroup
                    ? '${user.totalGroupMemebers!} thành viên'
                    : user.status ?? '',
                style: context.theme.userStatusTextStyle,
              ),
              onTapUserName: () {
                context.read<ChatBloc>().tryToChatScreen(chatInfo: user);
              },
            ),
          ),
          if (!user.isGroup && user.companyId != context.userInfo().companyId)
            FriendButton(
              contact: user,
            ),
        ],
      ),
    );
  });
}
