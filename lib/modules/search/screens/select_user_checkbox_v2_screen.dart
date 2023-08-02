import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/button/gradient_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/send_message_search_appbar.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/screens/chat_conversation_screen.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/modules/search/screens/search_contact_v2_screen.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectUserCheckboxV2Screen extends StatefulWidget {
  const SelectUserCheckboxV2Screen({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  final ValueChanged<ConversationBasicInfo> onSelected;

  @override
  State<SelectUserCheckboxV2Screen> createState() =>
      _SelectUserCheckboxV2ScreenState();
}

class _SelectUserCheckboxV2ScreenState
    extends State<SelectUserCheckboxV2Screen> {
  ConversationBasicInfo? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SearchContactV2Screen(
          itemBuilder: (user) => _RowItemUserCheckbox(
            user: user,
            selected: user.id == _selectedUser?.id,
            onChanged: (value) {
              if (value == true) _selectedUser = user;
              setState(() {});
            },
          ),
          appbarBottom: _selectedUser != null
              ? _AppbarBottom(
                  selectedUser: _selectedUser!,
                  onDeleteSelectedUser: () => setState(() {
                    _selectedUser = null;
                  }),
                )
              : null,
          onTapMoreButton: (filter, currentSearch) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => ContactListCubit(
                    searchContactCubits.repo,
                    initFilter: filter,
                    initSearch: currentSearch,
                    searchGroupConversationOnly:
                        filter == FilterContactsBy.conversations,
                  ),
                  child: SelectUserCheckboxV2DetailScreen(
                    initSearch: currentSearch,
                    selectedUser: _selectedUser,
                    onSelected: widget.onSelected,
                  ),
                ),
              ),
            );
          },
        ),
        _SelectDoneButton(
          onTap: widget.onSelected,
          selectedUser: _selectedUser,
        ),
      ],
    );
  }
}

class SelectUserCheckboxV2DetailScreen extends StatefulWidget {
  const SelectUserCheckboxV2DetailScreen({
    Key? key,
    this.initSearch = '',
    this.selectedUser,
    required this.onSelected,
  }) : super(key: key);

  final String initSearch;
  final ConversationBasicInfo? selectedUser;
  final ValueChanged<ConversationBasicInfo> onSelected;

  @override
  State<SelectUserCheckboxV2DetailScreen> createState() =>
      _SelectUserCheckboxV2DetailScreenState();
}

class _SelectUserCheckboxV2DetailScreenState
    extends State<SelectUserCheckboxV2DetailScreen> {
  final TextEditingController _controller = TextEditingController();
  late final TextEditingControllerDebouncer _debouncer;
  late final ContactListCubit _contactListCubit;
  final ValueNotifier<DialogState> _state = ValueNotifier(DialogState.init);
  ConversationBasicInfo? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedUser = widget.selectedUser;
    _contactListCubit = context.read<ContactListCubit>();
    _controller.text = widget.initSearch;
    _debouncer = TextEditingControllerDebouncer(
      () => _contactListCubit.search(_controller.text),
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
    return Scaffold(
      appBar: SendMessageSearchAppBar(
        controller: _controller,
        onSubmit: _contactListCubit.search,
        stateNotifier: _state,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallHeader(
                text: 'Gợi ý',
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
              Expanded(
                child: BlocConsumer<ContactListCubit, ContactListState>(
                  listener: (context, state) {
                    if (state is LoadingState)
                      _state.value = DialogState.processing;
                    else if (state is LoadSuccessState)
                      _state.value = DialogState.success;
                    else if (state is LoadFailedState) {
                      _state.value = DialogState.init;
                      AppDialogs.toast(state.message);
                    }
                  },
                  buildWhen: (_, current) => current is LoadSuccessState,
                  builder: (_, state) {
                    if (state is LoadSuccessState)
                      return ListView.builder(
                        itemCount: state.contactList.length,
                        itemBuilder: (context, index) {
                          var user = state.contactList[index];
                          return _RowItemUserCheckbox(
                            user: user,
                            selected: user.id == _selectedUser?.id,
                            onChanged: (value) {
                              if (value == true) _selectedUser = user;
                              setState(() {});
                            },
                          );
                        },
                      );

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
          _SelectDoneButton(
            onTap: widget.onSelected,
            selectedUser: _selectedUser,
          ),
        ],
      ),
    );
  }
}

class _RowItemUserCheckbox extends StatelessWidget {
  const _RowItemUserCheckbox({
    Key? key,
    required this.user,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  final ConversationBasicInfo user;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
          Checkbox(
            value: selected,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}

class _SelectDoneButton extends StatefulWidget {
  const _SelectDoneButton({
    Key? key,
    required this.onTap,
    required this.selectedUser,
  }) : super(key: key);

  final ValueChanged<ConversationBasicInfo> onTap;
  final ConversationBasicInfo? selectedUser;

  @override
  State<_SelectDoneButton> createState() => _SelectDoneButtonState();
}

class _SelectDoneButtonState extends State<_SelectDoneButton> {
  ConversationBasicInfo? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedUser = widget.selectedUser;
  }

  @override
  void didUpdateWidget(covariant _SelectDoneButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedUser = widget.selectedUser;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(15),
        height: 45,
        alignment: Alignment.center,
        child: GradientButton(
          onPressed: () =>
              _selectedUser != null ? widget.onTap(_selectedUser!) : null,
          gradientColor: _selectedUser != null ? context.theme.gradient : null,
          color: _selectedUser != null ? null : AppColors.gray,
          width: double.infinity,
          child: Center(
            child: Text(
              'XONG',
              style: AppTextStyles.regularW500(
                context,
                size: 16,
                lineHeight: 18,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppbarBottom extends StatelessWidget with PreferredSizeWidget {
  const _AppbarBottom({
    Key? key,
    required this.selectedUser,
    required this.onDeleteSelectedUser,
  }) : super(key: key);

  final ConversationBasicInfo selectedUser;
  final VoidCallback onDeleteSelectedUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              DisplayAvatar(
                isGroup: selectedUser.isGroup,
                model: selectedUser,
                size: 40,
                enable: false,
              ),
              Positioned(
                top: -2,
                right: -4,
                child: InkWell(
                  onTap: onDeleteSelectedUser,
                  child: Icon(
                    Icons.cancel,
                    size: 15,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
