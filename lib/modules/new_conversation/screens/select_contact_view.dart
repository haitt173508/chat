import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/app_error_widget.dart';
import 'package:chat_365/common/widgets/form/search_field.dart';
import 'package:chat_365/common/widgets/list_contact_view.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectContactView extends StatefulWidget {
  SelectContactView({
    Key? key,
    this.mulipleContactItemBuilder,
    required this.onChanged,
    this.userInfo,
  }) : super(key: key);

  final Widget Function(ApiContact)? mulipleContactItemBuilder;
  final ValueChanged<List<IUserInfo>> onChanged;
  final IUserInfo? userInfo;

  @override
  State<SelectContactView> createState() => _SelectContactViewState();
}

class _SelectContactViewState extends State<SelectContactView> {
  final ValueNotifier<String> searchKey = ValueNotifier('');
  final ValueNotifier<List<IUserInfo>> _selectedContact = ValueNotifier([]);
  late final ContactListCubit contactListCubit;
  late final FriendCubit _friendCubit;
  final GlobalKey<State<StatefulWidget>> _key =
      GlobalKey<State<StatefulWidget>>();
  bool loadFirst = true;
  List<ConversationBasicInfo> _friends = [];
  List<ConversationBasicInfo> _searchedFriends = [];

  @override
  void initState() {
    super.initState();
    var userInfo = context.userInfo();
    _friendCubit = context.read<FriendCubit>();
    contactListCubit = ContactListCubit(
      ContactListRepo(
        userInfo.id,
        companyId: userInfo.companyId ?? userInfo.id,
      ),
      initFilter: FilterContactsBy.allInCompany,
    );
    _selectedContact.addListener(_selectedContactListener);
  }

  _onChangeCheckBox(bool value, IUserInfo item) {
    if (value) {
      _selectedContact.value = [..._selectedContact.value, item];
    } else {
      _selectedContact.value = [
        ..._selectedContact.value..removeWhere((e) => item.id == e.id),
      ];
    }
  }

  _selectedContactListener() {
    widget.onChanged(_selectedContact.value);
  }

  @override
  void dispose() {
    _selectedContact.removeListener(_selectedContactListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadFirst) {
      if (widget.userInfo != null) {
        _onChangeCheckBox(true, widget.userInfo!);
      }
      loadFirst = false;
    }
    late final Widget suggestionText = Padding(
      padding: AppPadding.paddingHorizontal15,
      child: Text(
        StringConst.recommend,
        style: AppTextStyles.recommend(context),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBoxExt.h10,
        Padding(
          padding: AppPadding.paddingHorizontal15,
          child: SearchField(
            callBack: (value) {
              contactListCubit.search(value);
              _searchedFriends =
                  SystemUtils.searchFunction<ConversationBasicInfo>(
                value,
                _friends,
                toEng: true,
                delegate: (item) => item.name,
              ).toList();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          height: 40,
          child: ValueListenableBuilder<List<IUserInfo>>(
              valueListenable: _selectedContact,
              builder: (context, value, child) {
                return ListView.separated(
                  itemCount: value.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    var item = value[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        DisplayAvatar(
                          isGroup: false,
                          model: item,
                        ),
                        Positioned(
                          top: -2,
                          right: -4,
                          child: InkWell(
                            onTap: () {
                              _selectedContact.value = [
                                ..._selectedContact.value
                                  ..removeWhere((e) => item.id == e.id),
                              ];
                              _key.currentState?.setState(() {});
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 15,
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
        ),
        suggestionText,
        Expanded(
          child: BlocBuilder<FriendCubit, FriendState>(
            buildWhen: (previous, current) =>
                _friends.isEmpty && !_friendCubit.listFriends.isBlank,
            builder: (context, friendState) {
              if (!_friendCubit.listFriends!.isBlank)
                _friends = _searchedFriends = _friendCubit.listFriends!
                    .map(
                      (e) => ConversationBasicInfo(
                        conversationId: -1,
                        name: e.name,
                        isGroup: false,
                        userId: e.id,
                        avatar: e.avatar,
                      ),
                    )
                    .toList();
              return BlocBuilder<ContactListCubit, ContactListState>(
                bloc: contactListCubit,
                builder: (context, state) {
                  if (state is LoadSuccessState) {
                    return StatefulBuilder(
                      key: _key,
                      builder: (context, setState) {
                        var ids = _selectedContact.value.map((e) => e.id);
                        var listUsers = {
                          ..._searchedFriends,
                          ...state.contactList
                        };
                        return ListContactView(
                          userInfos: listUsers,
                          itemBuilder: (context, index, child) {
                            var item = listUsers.elementAt(index);
                            return CheckBoxUserListTile(
                              value: ids.contains(item.id),
                              userListTile: child,
                              onChanged: (value) =>
                                  _onChangeCheckBox(value, item),
                            );
                          },
                        );
                      },
                    );
                  }
                  if (state is LoadFailedState) {
                    return AppErrorWidget(error: state.message);
                  }
                  if (state is LoadingState) {
                    return WidgetUtils.centerLoadingCircle;
                  }
                  return Center(child: Text('DS trong'));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class CheckBoxUserListTile extends StatefulWidget {
  const CheckBoxUserListTile({
    Key? key,
    this.value = false,
    required this.onChanged,
    required this.userListTile,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget userListTile;

  @override
  State<CheckBoxUserListTile> createState() => _CheckBoxUserListTileState();
}

class _CheckBoxUserListTileState extends State<CheckBoxUserListTile>
    with AutomaticKeepAliveClientMixin {
  late bool _value;
  late Widget _userListTile;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _userListTile = widget.userListTile;
  }

  @override
  void didUpdateWidget(covariant CheckBoxUserListTile oldWidget) {
    if (widget.value != _value) _value = widget.value;
    if (widget.userListTile != _userListTile)
      _userListTile = widget.userListTile;
    super.didUpdateWidget(oldWidget);
  }

  _onChanged() {
    setState(() {
      _value = !_value;
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      onTap: _onChanged,
      child: Row(
        children: [
          Expanded(child: _userListTile),
          Checkbox(
            onChanged: (_) => _onChanged(),
            value: _value,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
