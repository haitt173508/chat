import 'package:chat_365/common/widgets/list_contact_view.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/modules/login/cubit/login_cubit.dart';
import 'package:chat_365/modules/auth/modules/login/models/login_model.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/confirm_id_company.dart';
import 'package:chat_365/modules/auth/modules/signup/screens/set_up_account_information_screen.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/modules/new_conversation/screens/select_contact_view.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_util/sp_util.dart';

class CheckAccountScreen extends StatefulWidget {
  const CheckAccountScreen({
    Key? key,
    required this.userType,
    this.mode,
  }) : super(key: key);
  final UserType userType;
  final AuthMode? mode;

  @override
  State<CheckAccountScreen> createState() => _CheckAccountScreenState();
}

class _CheckAccountScreenState extends State<CheckAccountScreen> {
  late final LoginCubit _loginCubit;
  final ValueNotifier<List<IUserInfo>> _selectedContact = ValueNotifier([]);

  @override
  void initState() {
    _loginCubit = context.read<LoginCubit>();
    _loginCubit.listContact(SpUtil.getInt(LocalStorageKey.userId2));
    _authRepo = context.read<AuthRepo>();
    //  TODO: implement initState
    super.initState();
  }

  late final IUserInfo userInfo;
  var countConversation;
  late final UserType userType;
  late final AuthRepo _authRepo;

  @override
  void didChangeDependencies() {
    try {
      userInfo = context.args['userInfor'];
      countConversation = context.args['countConversation'];
      userType = context.args['userType'];
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    super.didChangeDependencies();
  }

  // final bool? check = false;

  _onChangeCheckBox(bool value, IUserInfo item) {
    if (value) {
      _selectedContact.value = [..._selectedContact.value, item];
      // } else if (_selectedContact.value.length == 3) {
      //   check == true;
    } else {
      _selectedContact.value = [
        ..._selectedContact.value..removeWhere((e) => item.id == e.id),
      ];
    }
  }

  _btnCreateAccountPressedHandler(BuildContext context) {
    if (widget.mode == AuthMode.REGISTER) {
      _authRepo.userType = widget.userType;
      AppRouter.back(context);
    } else {
      if (widget.userType == UserType.customer) {
        AppRouter.toPage(context, AppPages.Auth_SetUpAccount_CreatCubit,
            arguments: {
              SetUpAccountInformationScreen.authModeArg: AuthMode.LOGIN
            });
      } else if (widget.userType == UserType.staff) {
        AppRouter.toPage(context, AppPages.Auth_ConfirmIdCompany,
            arguments: {ConfirmIdCompanyScreen.formLogin: AuthMode.LOGIN});
      } else if (widget.userType == UserType.company) {
        AppRouter.toPage(context, AppPages.Auth_SetUpAccount_CreatCubit,
            arguments: {
              SetUpAccountInformationScreen.authModeArg: AuthMode.LOGIN
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (_, state) {
          if (state is LoginSuccessfulTestState) {
            // _loginCubit.emit(LoginStateSuccess(userInfo,
            //     userType: userType, countConversation: countConversation));
            _loginCubit.login(
              UserType.fromId(userType.id),
              LoginModel(userInfo.email!, userInfo.password!),
              isMD5Pass: true,
            );
          }
        },
        buildWhen: (_, current) => current is ListContactSuccessState,
        builder: (context, state) {
          if (state is ListContactSuccessState) {
            // var listContact = state.model;
            return StatefulBuilder(
              builder: (context, setState) {
                var ids = _selectedContact.value.map((e) => e.id);
                var listUsers = state.model.listAccount;
                return Scaffold(
                  backgroundColor: context.theme.backgroundFormFieldColor,
                  appBar: AppBar(
                    title: Text(
                      StringConst.loginVerification,
                      style: AppTextStyles.regularW400(context, size: 16),
                    ),
                    elevation: 0,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            StringConst.peopleYouHaveContacted,
                            style: AppTextStyles.regularW500(
                              context,
                              size: 16,
                            ),
                          ),
                          SizedBoxExt.h8,
                          Text(
                            '( Chọn ${state.model.friendlist.length} đáp án )',
                            style: AppTextStyles.regularW400(
                              context,
                              size: 14,
                            ),
                          ),
                          Expanded(
                            child: ListContactView(
                              itemBuilder: (context, index, child) {
                                var item = listUsers.elementAt(index);
                                return CheckBoxUserListTile(
                                  value: ids.contains(item.id),
                                  userListTile: child,
                                  onChanged: (value) =>
                                      _onChangeCheckBox(value, item),
                                );
                              },
                              userInfos: listUsers,
                            ),
                          ),
                          SizedBoxExt.h10,
                          Center(
                            child: InkWell(
                              onTap: () {
                                print(
                                    'ListID: ${_selectedContact.value.map((e) => e.id).toList()}');
                                _selectedContact.value.length ==
                                        state.model.friendlist.length
                                    ? _loginCubit.confirmLogin(
                                        '${_selectedContact.value.map((e) => e.id).toList()}')
                                    : AppDialogs.showErrorDialog(context,
                                        "Bạn vui lòng chọn ${state.model.friendlist.length} đáp án!");
                                if (_selectedContact.value.length >
                                    state.model.friendlist.length)
                                  _selectedContact.value.clear();
                                setState(() {});
                              },
                              child: Ink(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 57, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: context.theme.primaryColor,
                                ),
                                child: Text(
                                  "Trả lời",
                                  style: AppTextStyles.regularW700(context,
                                      size: 16,
                                      color: context
                                          .theme.backgroundFormFieldColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBoxExt.h30,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                StringConst.doNotHaveAnAccount,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.theme.textColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  _btnCreateAccountPressedHandler(context);
                                },
                                child: Text(
                                  StringConst.signUp,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
