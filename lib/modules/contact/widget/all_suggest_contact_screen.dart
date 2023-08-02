import 'dart:async';

import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/widgets/button/gradient_button.dart';
import 'package:chat_365/common/widgets/chip_tab_bar.dart';
import 'package:chat_365/common/widgets/form/search_field.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/contact_service/contact_service.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/screens/contact_screen.dart';
import 'package:chat_365/modules/contact/widget/suggest_contact_item.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllSuggestContactScreen extends StatefulWidget {
  const AllSuggestContactScreen({Key? key}) : super(key: key);

  static const String suggestContactCubitArg = 'suggestContactCubitArg';

  @override
  State<AllSuggestContactScreen> createState() =>
      _AllSuggestContactScreenState();
}

class _AllSuggestContactScreenState extends State<AllSuggestContactScreen>
    with SingleTickerProviderStateMixin {
  List<Contact> initPhoneContacts = ContactService().contacts ?? [];
  late final ValueNotifier<List<Contact>> _phoneContacts;
  late final Map<String?, ApiContact> phoneApiContact;
  late final InputBorder searchFieldBorder;
  final double _kBottomHeight = 100;
  late final TabController _tabController;
  late final FriendCubit _friendCubit;
  late final SuggestContactCubit _suggestContactCubit;
  final List<ValueNotifier<int>> _counts = List.generate(
    ContactTabType.values.length,
    (_) => ValueNotifier(0),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _suggestContactCubit = context.read<SuggestContactCubit>();
    phoneApiContact = _suggestContactCubit.contactFromPhone;
    _friendCubit = context.read<FriendCubit>();
    _phoneContacts = ValueNotifier(initPhoneContacts);
    searchFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var updateTime = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15).copyWith(
            top: 56 + context.mediaQueryPadding.top,
          ),
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<DateTime?>(
                    valueListenable: ContactService().lastTimeFetchContact,
                    builder: (context, time, _) {
                      return RichText(
                        text: TextSpan(
                          text: 'Lần cập nhật danh bạ gần nhất\n',
                          style: AppTextStyles.regularW400(
                            context,
                            size: 14,
                            lineHeight: 16,
                          ),
                          children: [
                            WidgetSpan(
                              child: const SizedBox(height: 8),
                            ),
                            if (time != null)
                              TextSpan(
                                text: '\n${time.diffWith(
                                  showSpecialTime: true,
                                  showTimeStamp: false,
                                )} lúc ${time.diffWith()}',
                                style: AppTextStyles.regularW500(
                                  context,
                                  size: 16,
                                  lineHeight: 18.75,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
              ),
              CircleAvatar(
                backgroundColor: AppColors.greyCC,
                child: IconButton(
                  splashRadius: 24,
                  onPressed: () async {
                    // AppDialogs.toast('Đang cập nhật danh sách');
                    await ContactService().init();
                    initPhoneContacts = ContactService().contacts ?? [];
                    Fluttertoast.cancel();
                    _phoneContacts.value = initPhoneContacts;
                  },
                  constraints: BoxConstraints(
                    maxHeight: 40,
                    maxWidth: 40,
                  ),
                  icon: Icon(
                    Icons.autorenew_rounded,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          thickness: 8,
          color: context.theme.messageBoxColor,
        ),
      ],
    );
    var searchField = SearchField(
      callBack: (value) =>
          _phoneContacts.value = SystemUtils.searchFunction<Contact>(
        value,
        initPhoneContacts,
        delegate: (value) => '${value.displayName} ${value.phones?[0].value}',
      ).toList(),
      inputDecoration: InputDecoration(
        hintText: 'Tìm kiếm danh bạ',
        fillColor: context.theme.messageBoxColor,
        enabledBorder: searchFieldBorder,
        border: searchFieldBorder,
        focusedBorder: searchFieldBorder,
        errorBorder: searchFieldBorder,
        filled: true,
        constraints: BoxConstraints(
          maxHeight: 40,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
      ),
    );
    var body = BlocListener<SuggestContactCubit, SuggestContactState>(
      listener: (context, state) {
        if (state is SuggestContactSuccess) {
          _phoneContacts.value = [...ContactService().contacts ?? []];
        }
      },
      child: ValueListenableBuilder<List<Contact>>(
          valueListenable: _phoneContacts,
          builder: (context, phoneContacts, _) {
            var apiContacts = Map<Contact, ApiContact?>();
            phoneContacts.forEach((item) {
              apiContacts[item] = null;
              ApiContact? apiContact;
              for (var phone in (item.phones ?? [])) {
                apiContact = phoneApiContact[phone.value];
                if (apiContact != null) {
                  apiContacts[item] = apiContact;
                  break;
                }
              }
            });

            var list1 = apiContacts;
            var list2 = {...apiContacts}..removeWhere((k, v) =>
                _friendCubit.listFriends?.map((e) => e.id).contains(v?.id) ??
                false);

            WidgetsBinding.instance?.addPostFrameCallback((_) {
              _counts[0].value = list1.length;
              _counts[1].value = list2.length;
            });

            return TabBarView(
              controller: _tabController,
              children: [
                _BuildBody(listApiContacts: apiContacts),
                _BuildBody(listApiContacts: list2),
              ],
            );
          }),
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text('Danh bạ máy'),
            primary: true,
            elevation: 1,
            pinned: true,
            floating: false,
            expandedHeight: _kBottomHeight + 60 + 15 + 56,
            flexibleSpace: FlexibleSpaceBar(
              background: updateTime,
            ),
            collapsedHeight: 56,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(_kBottomHeight),
              child: Container(
                height: _kBottomHeight,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    searchField,
                    const SizedBox(height: 15),
                    Expanded(
                      child: ChipTabBar<ContactTabType>(
                        tabs: ContactTabType.values,
                        tabController: _tabController,
                        counts: _counts,
                        name: (e) => e.name,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: body,
        // child: Column(
        //   children: [
        //     updateTime,
        //     Container(
        //       height: 10,
        //       color: context.theme.messageBoxColor,
        //       width: double.infinity,
        //     ),
        //     searchField,
        //     Expanded(
        //       child: body,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class _BuildBody extends StatefulWidget {
  const _BuildBody({
    Key? key,
    required this.listApiContacts,
  }) : super(key: key);

  final Map<Contact, ApiContact?> listApiContacts;

  @override
  State<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<_BuildBody>
    with AutomaticKeepAliveClientMixin {
  late Map<Contact, ApiContact?> apiContacts;

  @override
  void initState() {
    super.initState();
    apiContacts = {...widget.listApiContacts};
  }

  @override
  void didUpdateWidget(covariant _BuildBody oldWidget) {
    apiContacts = {...widget.listApiContacts};
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Contact> list = apiContacts.keys.toList();

    final Map<String, List<Contact>> group = Map.fromIterable(
      AppConst.alphabet,
      value: (_) => <Contact>[],
    );

    // list.sort((a,b) => );

    var alphabet =
        list.map((e) => e.name[0].toEngAlphabetString().toLowerCase());

    for (int i = 0; i < list.length; i++) {
      group[alphabet.elementAt(i)]?.add(list[i]);
    }

    group.removeWhere((k, v) => v.isEmpty);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GrouppedList(
        // itemCount: apiContacts.length,
        // padding: EdgeInsets.symmetric(horizontal: 15),
        group: group,
        subGroupBuilder: (_, character, items) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextHeader(
                text: character.toUpperCase(),
              ),
              const SizedBox(height: 5),
              ...items,
            ],
          ),
        ),
        groupItemBuilder: (_, character, Contact item) {
          final ApiContact? apiContact = apiContacts[item];
          String displayName = item.displayName ?? item.phones?[0].value ?? '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: apiContact != null
                ? SuggestContactItem(
                    key: ValueKey(apiContact.id),
                    contact: apiContact.copyWith(name: displayName),
                    style2: true,
                    subtitle: Text(
                      'Tên Chat365: ${apiContact.name}',
                      style: AppTextStyles.regular(
                        context,
                        size: 13,
                        lineHeight: 20,
                        color: context.theme.textColor,
                      ),
                    ),
                  )
                : SuggestContactItemLayout(
                    userInfo: PhoneContact(contact: item),
                    button: GradientButton(
                      onPressed: () {
                        var phone =
                            (item.phones ?? []).map((e) => e.value).firstWhere(
                                  (e) => e != null,
                                  orElse: () => '',
                                );
                        if (!phone.isBlank)
                          SystemUtils.sendSms(
                            phone!,
                            message:
                                'Hãy trò chuyện trên Chat365. Đó là ứng dụng chính của tôi dành để nhắn tin và gọi miễn phí. Đây là liên kết https://onelink.to/dmmyez ',
                          );
                        else
                          AppDialogs.toast('Không thể xác định số điện thoại');
                      },
                      color: context.theme.primaryColor.withOpacity(0.3),
                      child: Text(
                        StringConst.invite,
                        style: AppTextStyles.regularW500(
                          context,
                          size: 14,
                          lineHeight: 16,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum ContactTabType {
  all,
  notFriend,
}

extension ContactTabTypeExt on ContactTabType {
  String get name {
    switch (this) {
      case ContactTabType.all:
        return StringConst.all;
      case ContactTabType.notFriend:
        return StringConst.notFriendYet;
    }
  }
}

class PhoneContact extends IUserInfo {
  final Contact contact;

  PhoneContact({
    required this.contact,
  }) : super(
          id: -1,
          name: contact.name,
          avatar: contact.avatar,
        );

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  FutureOr<Map<String, dynamic>> toLocalStorageJson() {
    // TODO: implement toLocalStorageJson
    throw UnimplementedError();
  }
}
