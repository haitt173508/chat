import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/form/search_field.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/contact_service/contact_service.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllContactInDevice extends StatefulWidget {
  const AllContactInDevice({Key? key}) : super(key: key);

  static const String suggestContactCubitArg = 'suggestContactCubitArg';

  @override
  State<AllContactInDevice> createState() => _AllContactInDeviceState();
}

class _AllContactInDeviceState extends State<AllContactInDevice> {
  List<Contact> initPhoneContacts = ContactService().contacts ?? [];
  late final ValueNotifier<List<Contact>> _phoneContacts;
  late final Map<String?, ApiContact> phoneApiContact;
  late final InputBorder searchFieldBorder;

  @override
  void initState() {
    super.initState();
    phoneApiContact = context.read<SuggestContactCubit>().contactFromPhone;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh bạ máy',
          // style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
          //       color: AppColors.white,
          //     ),
        ),
        elevation: 1,
        // leading: BackButton(
        //   color: AppColors.white,
        // ),
        // flexibleSpace: FlexibleSpaceBar(
        //   background: Container(
        //     decoration: BoxDecoration(
        //       gradient: context.theme.gradient,
        //     ),
        //   ),
        // ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<DateTime?>(
                      valueListenable: ContactService().lastTimeFetchContact,
                      builder: (context, time, _) {
                        return RichText(
                          text: TextSpan(
                            text: 'Lần cập nhật danh bạ gần nhất',
                            style: AppTextStyles.regularW500(
                              context,
                              size: 16,
                              lineHeight: 21.6,
                            ),
                            children: [
                              TextSpan(
                                text: '\n${time?.diffWith(
                                  showSpecialTime: true,
                                  showTimeStamp: false,
                                )} lúc ${time?.diffWith()}',
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
                      AppDialogs.toast('Đang cập nhật danh sách');
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
          Container(
            height: 10,
            color: context.theme.messageBoxColor,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SearchField(
              callBack: (value) =>
                  _phoneContacts.value = SystemUtils.searchFunction<Contact>(
                value,
                initPhoneContacts,
                delegate: (value) =>
                    '${value.displayName} ${value.phones?[0].value}',
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
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Contact>>(
                valueListenable: _phoneContacts,
                builder: (context, phoneContacts, _) {
                  return ListView.builder(
                    itemCount: phoneContacts.length,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (_, index) {
                      var item = phoneContacts[index];
                      var phone;
                      try {
                        phone = item.phones?.firstWhere(
                            (e) => phoneApiContact.keys.contains(e.value));
                      } catch (e) {}

                      var apiContact = phoneApiContact[phone];

                      var displayName =
                          item.displayName ?? item.phones?[0].value ?? '';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: UserListTile(
                          userName: displayName,
                          avatar: DisplayAvatar(
                            isGroup: false,
                            model: BasicInfo(
                              id: -1,
                              name: displayName,
                            ),
                            enable: false,
                            size: 45,
                          ),
                          bottom: Text(
                            apiContact?.name ?? item.phones?[0].value ?? '',
                            style: AppTextStyles.regular(
                              context,
                              size: 13,
                              lineHeight: 20,
                              color: context.theme.textColor,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
