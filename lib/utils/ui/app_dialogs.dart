import 'package:app_settings/app_settings.dart';
import 'package:chat_365/common/components/choice_dialog_item.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/components/display_image_with_status_badge.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/dialogs/custom_dialog.dart';
import 'package:chat_365/common/widgets/dialogs/detail_info_dialog.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/home_qr_code/model/detail_company_model.dart';
import 'package:chat_365/modules/new_conversation/screens/select_contact_view.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/auth_mode.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

_navigateBack(BuildContext context) => AppRouter.back(context, result: false);

class AppDialogs {
  static hideLoadingCircle(BuildContext context) => _navigateBack(context);

  // static showRequestLoginDialog(BuildContext context, String message) =>
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       barrierColor: Colors.transparent,
  //       builder: (BuildContext context) => RequestLoginDialog(message: message),
  //     );

  static showConfirmDeleteDialog(
    BuildContext context, {
    required String title,
    required ErrorCallback onDelete,
    required String successMessage,
    Widget? content,
    Widget? header,
    ValueChanged<ExceptionError>? onError,
  }) =>
      showDialog(
        context: context,
        routeSettings: RouteSettings(
          name: GeneratorService.generateDialogRouteName(),
        ),
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConfirmDialog(
                title: title,
                header: header,
                successMessage: successMessage,
                content: content,
                onDelete: onDelete,
                onError: onError,
                name: 'Xóa',
              ),
            ),
          );
        },
      );

  static showConfirmDialog(
    BuildContext context, {
    required String title,
    required ErrorCallback onFunction,
    required String successMessage,
    required String nameFunction,
    Widget? content,
    Widget? header,
    ValueChanged<ExceptionError>? onError,
    VoidCallback? onSuccess,
    Color? confirmTextColor,

    /// Đổi chỗ vị trí 2 nút cho nhau
    bool isReversed = false,
  }) =>
      showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConfirmDialog(
                title: title,
                header: header,
                successMessage: successMessage,
                isReversed: isReversed,
                content: content,
                onDelete: onFunction,
                onError: onError,
                onSuccess: onSuccess,
                name: nameFunction,
                confirmTextColor: confirmTextColor,
              ),
            ),
          );
        },
      );

  // static Future<bool?> showToast(BuildContext context, String msg) =>
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       barrierColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         Future.delayed(
  //             Duration(seconds: 2), () => Navigator.pop(context, false));

  //         return WillPopScope(
  //           onWillPop: () async {
  //             Navigator.pop(context, true);
  //             return false;
  //           },
  //           child: IgnorePointer(
  //             child: Material(
  //               type: MaterialType.transparency,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Chip(
  //                     label: Text(
  //                       msg,
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     backgroundColor: Colors.black.withOpacity(0.8),
  //                     labelPadding: const EdgeInsets.symmetric(
  //                       horizontal: 16,
  //                       vertical: 10,
  //                     ),
  //                   ),
  //                   SizedBox(height: 100),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );

  static toast(
    String msg, {
    Color? color,
    Toast? toast,
    Color? textColor,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color ?? Colors.grey.shade600,
      textColor: textColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: toast ?? Toast.LENGTH_LONG,
    );
  }

  static Future<void> showErrorDialog(BuildContext context, String msg,
          [void Function()? onAffirmativeBtnPressed]) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: AppColors.dialogBarrier,
        builder: (_) => CustomDialog(
          isMessageDialog: true,
          icon: SvgPicture.asset(Images.ic_error_lock),
          description: msg,
          onAffirmativeBtnPressed:
              onAffirmativeBtnPressed ?? () => _navigateBack(context),
          onCancel: () => _navigateBack(context),
        ),
        routeSettings: RouteSettings(name: 'error', arguments: msg),
      );

  static showRadioDialog<T>(
    BuildContext context, {
    required List<T> items,
    T? init,
  }) async {
    T seletedValue = init ?? items[0];
    return showDialog<T>(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4.0,
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.symmetric(horizontal: 15),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  // padding: EdgeInsets.all(20),
                  children: items
                      .map(
                        (e) => RadioListTile<T>(
                          groupValue: seletedValue,
                          value: e,
                          selected: e == seletedValue,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          dense: true,
                          onChanged: (_) {
                            setState(() {
                              seletedValue = e;
                            });
                          },
                          title: Text(
                            e.toString(),
                            style: AppTextStyles.regularW400(
                              context,
                              size: 16,
                              lineHeight: 22,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            title: Container(
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cài đặt tin nhắn tự xóa',
                    style: AppTextStyles.regularW700(
                      context,
                      size: 18,
                      lineHeight: 21,
                      color: AppColors.white,
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      Images.ic_cancel,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  StringConst.cancel,
                  style: AppTextStyles.regularW700(
                    context,
                    size: 16,
                    lineHeight: 19.2,
                    color: context.theme.textColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  StringConst.confirm,
                  style: AppTextStyles.regularW700(
                    context,
                    size: 16,
                    lineHeight: 19.2,
                    color: context.theme.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(seletedValue);
                },
              ),
            ],
          );
        });
  }
  // static resolveFailedState(
  //   BuildContext context,
  //   String error, [
  //   VoidCallback? callback,
  // ]) =>
  //     showErrorDialog(context, error, () {
  //       _navigateBack(context);
  //       AppDialogs.hideLoadingCircle(context);
  //       callback?.call();
  //     });

  // static showLoadingCircle(
  //   BuildContext context, {
  //   bool barrierDismissible = false,
  //   RouteSettings? routeSettings,
  // }) =>
  //     showDialog(
  //       context: context,
  //       barrierDismissible: barrierDismissible,
  //       barrierColor: AppColors.dialogBarrier,
  //       builder: (_) => WillPopScope(
  //         onWillPop: () async => barrierDismissible,
  //         child: SizedBox.expand(
  //           child: Center(
  //             child: CircularProgressIndicator(color: AppColors.primary),
  //           ),
  //         ),
  //       ),
  //       routeSettings: routeSettings ?? RouteSettings(name: 'loading'),
  //     );

  static showLoadingCircle(
    BuildContext context, {
    bool barrierDismissible = false,
    RouteSettings? routeSettings,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: AppColors.dialogBarrier,
        builder: (_) => Dialog(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoActivityIndicator(
                color: context.theme.primaryColor,
                radius: 40,
              ),
              SizedBox(
                height: 46,
              ),
              Text(
                'Vui lòng đợi trong giây lát!',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularW700(context, size: 18),
              )
            ],
          ),
        )),
        routeSettings: routeSettings ?? RouteSettings(name: 'loading'),
      );

  static showChoicesDialog(
    BuildContext context, {
    required List<ChoiceDialogItem> choices,
    String? title,
  }) {
    return showDialog(
      context: context,
      routeSettings: RouteSettings(
        name: 'DIALOG_CHOICES_${DateTime.now().millisecondsSinceEpoch}',
      ),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: context.theme.backgroundColor,
          child: ListView(
            physics: const ScrollPhysics(),
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12,
                  ),
                  child: Text(
                    title,
                    style: AppTextStyles.regularW500(
                      context,
                      size: 16,
                      lineHeight: 22,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
              ...choices
            ],
            padding: EdgeInsets.symmetric(vertical: 5),
            shrinkWrap: true,
          ),
        );
      },
    );
  }

  static showModalBottomSheetChoicesDialog(
    BuildContext context, {
    required List<ChoiceDialogItem> choices,
    Widget? title,
  }) {
    return showModalBottomSheet(
      context: context,
      routeSettings: RouteSettings(
        name: 'BOTTOM_SHEET_${DateTime.now().millisecondsSinceEpoch}',
      ),
      barrierColor: AppColors.black.withOpacity(0.85),
      constraints: BoxConstraints(
        maxHeight: context.mediaQuerySize.height,
        minHeight: 0,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: title,
              ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: context.theme.backgroundColor,
              child: ListView(
                // physics: const ScrollPhysics(),
                children: choices,
                padding: EdgeInsets.symmetric(vertical: 5),
                shrinkWrap: true,
              ),
            ),
          ],
        );
      },
    );
  }

  static showWrongUserTypeAuthDialog(
    BuildContext context, {
    UserType? wrongUserType,
    required UserType rightUserType,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        var theme = context.theme;
        var wrongUserTypeAuthDialogTextStyle =
            theme.wrongUserTypeAuthDialogTextStyle;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // titlePadding: const EdgeInsets.all(35).copyWith(bottom: 0),
          // title: Text(
          //   'Tài khoản không chính xác',
          //   style: AppTextStyles.regularW600(
          //     context,
          //     size: 20,
          //     lineHeight: 22,
          //   ),
          // ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 23)
              .copyWith(top: 35),
          content: RichText(
            text: TextSpan(
              text:
                  'Tài khoản bạn đăng nhập được xác minh là tài khoản sử dụng cho ',
              style: wrongUserTypeAuthDialogTextStyle,
              children: [
                TextSpan(
                  text: rightUserType.type,
                  style: wrongUserTypeAuthDialogTextStyle.copyWith(
                    color: theme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: '.\nBạn có muốn tiếp tục đăng nhập?',
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 35,
          ).copyWith(
            top: 0,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsOverflowButtonSpacing: 20,
          actions: [
            actionButton(
              context,
              OutlinedButton(
                child: Text(StringConst.next),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            actionButton(
              context,
              ElevatedButton(
                child: Text(StringConst.no),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static actionButton(
    BuildContext context,
    Widget child,
  ) {
    return SizedBox(
      width: (context.mediaQuerySize.width - 30 * 2 - 20 - 40 * 2) / 2,
      child: child,
    );
  }

  static showReactionDetailDialog(
    BuildContext context, {
    int initIndex = 0,
    required Iterable<IUserInfo> users,
    required Map<Emoji, Emotion> reactions,
  }) {
    var mapUsers =
        Map<int, IUserInfo>.fromIterable(users, key: (item) => item.id);

    var keys = reactions.keys.toList()
      ..removeWhere((e) => reactions[e]!.listUserId.isEmpty);

    logger.log(keys.length);

    initIndex = initIndex.clamp(0, keys.length - 1).toInt();

    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: DefaultTabController(
              length: keys.length,
              initialIndex: initIndex,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                        // right: Radius.circular(15),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'Biểu cảm',
                      style: AppTextStyles.regularW500(
                        context,
                        size: 20,
                        lineHeight: 22,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        indicatorColor: context.theme.primaryColor,
                        tabs: keys
                            .map(
                              (e) => Row(
                                children: [
                                  Image.asset(
                                    e.assetPath,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    (reactions[e]?.listUserId.length ?? 0)
                                        .toString(),
                                    style: AppTextStyles.regularW400(
                                      context,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()),
                  ),
                  Container(
                    height: context.mediaQuerySize.height / 2.5,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TabBarView(
                      children: keys
                          .map(
                            (e) => ListView.separated(
                              itemCount: reactions[e]?.listUserId.length ?? 0,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, index) {
                                var user =
                                    mapUsers[reactions[e]?.listUserId[index]];
                                if (user == null) return const SizedBox();
                                return UserListTile(
                                  avatar: DisplayImageWithStatusBadge(
                                    isGroup: false,
                                    model: user,
                                    userStatus: user.userStatus,
                                  ),
                                  userName: user.name,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static showReadMessageDialog(
    BuildContext context,
    Map<IUserInfo, DateTime> detail,
  ) {
    Map<IUserInfo, DateTime> resMap = {};
    List mapKeys = detail.keys.toList(growable: false);
    mapKeys.sort((a, b) {
      if (detail[a] == null || detail[b] == null) return 0;
      return detail[b]!.compareTo(detail[a]!);
    });
    mapKeys.forEach((k1) {
      resMap[k1] = detail[k1]!;
    });
    var entries = resMap.entries;
    return showDialog(
      context: context,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: context.theme.primaryColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  // right: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                'Thành viên đã xem (${entries.length})',
                style: AppTextStyles.regularW500(
                  context,
                  size: 20,
                  lineHeight: 22,
                  color: AppColors.white,
                ),
              ),
            ),
            Container(
              height: context.mediaQuerySize.height / 2.5,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.separated(
                itemCount: detail.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  var entry = entries.elementAt(index);
                  var user = entry.key;
                  var time = entry.value;
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: UserListTile(
                          avatar: DisplayAvatar(
                            isGroup: false,
                            model: user,
                          ),
                          userName: user.name,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: Text(time.diffWith(showSpecialTime: true)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showAppModalBottomSheet(
    BuildContext context, {
    required Widget child,
    String? title,
  }) {
    return showModalBottomSheet(
      context: context,
      routeSettings: RouteSettings(
        name: 'MODAL_BOTTOM_SHEET_${DateTime.now().microsecondsSinceEpoch}',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 10,
                ),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: AppTextStyles.mbsTitle(context),
                ),
              ),
            child,
            const SizedBox(height: 27),
          ],
        );
      },
    );
  }

  static Future<List<IUserInfo>?> showListUserDialog(
    BuildContext context,
  ) {
    var selectedContact = [];
    return showDialog(
        context: context,
        routeSettings: RouteSettings(
          name: GeneratorService.generateDialogRouteName(),
        ),
        builder: (_) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: context.mediaQuerySize.height / 1.5,
                    child: SelectContactView(
                      onChanged: (value) => selectedContact = value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: RoundedButton(
                      label: 'Xong',
                      fillStyle: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      onPressed: () => AppRouter.back(
                        context,
                        result: selectedContact,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static showLogoutDialog(
    BuildContext context,
  ) {
    var buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));

    return showDialog(
      context: context,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: CircleAvatar(
                  radius: 45,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      Images.ic_log_out,
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Đăng xuất',
                  style: AppTextStyles.regularW700(
                    context,
                    size: 18,
                    lineHeight: 21,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Bạn chắc chắn muốn đăng xuất?',
                  style: AppTextStyles.regularW400(
                    context,
                    size: 14,
                    lineHeight: 24,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => AppRouter.back(context),
                        child: Text(
                          'Hủy',
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: buttonShape,
                          side: BorderSide(
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => SystemUtils.logout(context),
                        child: Text(
                          'Đăng xuất',
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: buttonShape,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showLoginDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: context.theme.backgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: MaterialButton(
                  minWidth: 40,
                  padding: EdgeInsets.zero,
                  shape: CircleBorder(),
                  onPressed: () => AppRouter.back(context),
                  child: Padding(
                    padding: AppPadding.paddingAll10,
                    child: Icon(
                      Icons.close,
                      color: context.theme.iconColor,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBoxExt.h10,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Bạn đã có tài khoản trên hệ thống. Xin vui lòng đăng nhập bằng tài khoản đó!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regularW400(
                        context,
                        size: 16,
                        lineHeight: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => AppRouterHelper.toAuthOptionPage(
                        context,
                        authMode: AuthMode.LOGIN,
                      ),
                      child: Text(
                        'Đăng nhập',
                        style: AppTextStyles.regularW700(context, size: 18)
                            .copyWith(
                          color: context.theme.backgroundColor,
                        ),
                      ),
                      style: context.theme.buttonStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Chi back ve man dang nhap
  static showUpdatePasswordSuccessDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: context.theme.backgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBoxExt.h10,
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Chúc mừng bạn đã cập nhật mật khẩu thành công. Vui lòng đăng nhập lại!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularW400(
                    context,
                    size: 16,
                    lineHeight: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () =>
                      AppRouter.backToPage(context, AppPages.Auth_Login),
                  child: Text(
                    'Về màn Đăng nhập',
                    style:
                        AppTextStyles.regularW700(context, size: 18).copyWith(
                      color: context.theme.backgroundColor,
                    ),
                  ),
                  style: context.theme.buttonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Thay doi mat khau thanh cong
  static showChangePasswordSuccessDialog(
    BuildContext context,
    VoidCallback onTapYes,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: context.theme.backgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBoxExt.h10,
              Text(
                'Chúc mừng bạn đã thay đổi mật khẩu thành công.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularW400(context,
                    size: 16,
                    lineHeight: 24,
                    color: context.theme.primaryColor),
              ),
              SizedBoxExt.h10,
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Bạn có muốn đăng xuất khỏi các thiết bị khác.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularW400(
                    context,
                    size: 16,
                    lineHeight: 24,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onTapYes,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: context.theme.backgroundFormFieldColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: context.theme.primaryColor, width: 2)),
                      child: Text(
                        'Có',
                        style: AppTextStyles.regularW700(context, size: 18)
                            .copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        AppRouter.backToPage(context, AppPages.Navigation),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: context.theme.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: context.theme.primaryColor, width: 2)),
                      child: Text(
                        'Không',
                        style: AppTextStyles.regularW700(context, size: 18)
                            .copyWith(
                          color: context.theme.backgroundFormFieldColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   height: 40,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       AppRouter.back(context);
              //       AppRouter.back(context);
              //     },
              //     child: Text(
              //       'Trở về hồ sơ Chat 365',
              //       style: AppTextStyles.regularW700(context, size: 18).copyWith(
              //         color: context.theme.backgroundColor,
              //       ),
              //     ),
              //     style: context.theme.buttonStyle,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  ///Phan hien noi dung va chuc nang button
  static showMessConfirm(
    BuildContext context,
    String companyName,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: context.theme.backgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.regularW400(
                      context,
                      size: 16,
                      lineHeight: 24,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Vui lòng chờ ',
                      ),
                      TextSpan(
                        text: '$companyName ',
                        style: AppTextStyles.regularW500(
                          context,
                          size: 16,
                          lineHeight: 24,
                        ),
                      ),
                      TextSpan(
                        text:
                            'duyệt để có thể sử dụng dịch vụ! Nếu thời gian chờ duyệt diễn ra quá lâu, bạn hãy liên hệ bộ phận Nhân sự của Công ty để được hỗ trợ duyệt tài khoản sớm nhất!',
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () => AppRouter.back(context),
                  child: Text(
                    'Quay lại',
                    style:
                        AppTextStyles.regularW700(context, size: 18).copyWith(
                      color: context.theme.backgroundColor,
                    ),
                  ),
                  style: context.theme.buttonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<dynamic> showListDialog({
    required BuildContext context,
    required List<SelectableItem> list,
    required SelectableItem? value,
  }) async {
    FocusScope.of(context).unfocus();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap out side
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),

          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2.8,
            ),
            child: RawScrollbar(
              // thumbVisibility: true,
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: <Widget>[
                  if (list.isEmpty)
                    Container(
                      padding: AppPadding.paddingAll15,
                      child: SizedBox(
                        height: 14,
                      ),
                    ),
                  for (SelectableItem item in list)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(item);
                      },
                      child: Container(
                        padding: AppPadding.paddingAll15,
                        color: value != null
                            ? value.id == item.id
                                ? AppColors.primary.withOpacity(1)
                                : context.theme.backgroundColor
                            : context.theme.backgroundColor,
                        child: Text(
                          item.name,
                          style: value != null
                              ? value.id == item.id
                                  ? TextStyle(
                                      color: context.theme.backgroundColor)
                                  : TextStyle()
                              : TextStyle(),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),

          // actionsPadding: EdgeInsets.zero,
          // buttonPadding: EdgeInsets.zero,
          // actions: <Widget>[
          //   SizedBox(
          //     height: 6,
          //   )
          // ],
        );
      },
    );
  }

  static showSendLocationDialog(
    BuildContext context,
    Widget child, {
    bool isCurrentLocation = false,
    required IUserInfo recieveInfo,
    required VoidCallback onSend,
  }) =>
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(
                'Gửi vị trí ${isCurrentLocation ? 'hiện tại' : 'này'} cho ${recieveInfo.name} ?',
                maxLines: 2,
                style: AppTextStyles.regularW500(
                  context,
                  size: 18,
                  lineHeight: 20,
                ),
              ),
              content: child,
              actions: [
                TextButton(
                  child: Text(
                    'HỦY',
                    style: AppTextStyles.regularW500(
                      context,
                      size: 16,
                      lineHeight: 18,
                      color: context.theme.textColor,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text(
                    'GỬI',
                    style: AppTextStyles.regularW500(
                      context,
                      size: 16,
                      lineHeight: 18,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  onPressed: onSend,
                ),
              ],
            );
          });

  static showDetailInfo(
    BuildContext context, {
    required UserType type,
    required Future<DetailModel?> Function() detailModel,
  }) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: FutureBuilder<DetailModel?>(
              future: detailModel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return WidgetUtils.loadingCircle(context);
                if (snapshot.hasError || snapshot.data == null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Images.img_thinkingFace,
                        ),
                        Text(snapshot.error?.toString() ?? 'Đã có lỗi xảy ra'),
                      ],
                    ),
                  );
                }
                return DetailInfo(
                  detailInfo: snapshot.data!,
                  type: type,
                );
              }),
        ),
      );

  static showFunctionLockDialog(
    BuildContext context, {
    required String title,
  }) =>
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(Images.ic_error_lock),
                  SizedBoxExt.w15,
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 5,
                      style: AppTextStyles.regularW400(
                        context,
                        size: 14,
                        lineHeight: 20,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Đóng',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      lineHeight: 18,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });

  static Future<bool> showRequestExternalManageStorage(
      BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Allow Chat365 to access to manage all files ?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        actions: [
          TextButton(
            child: Text('ALLOW'),
            onPressed: () => Navigator.pop(context, true),
          ),
          TextButton(
            child: Text('DENY'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }

  static showDialogCall(BuildContext context, void Function()? onPressed) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      routeSettings: RouteSettings(
        name: GeneratorService.generateDialogRouteName(),
      ),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: context.theme.backgroundColor,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => AppRouter.back(context),
                child: Text(
                  'Quay lại',
                  style: AppTextStyles.regularW700(context, size: 18).copyWith(
                    color: context.theme.backgroundColor,
                  ),
                ),
                style: context.theme.buttonStyle,
              ),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  'Chấp nhận',
                  style: AppTextStyles.regularW700(context, size: 18).copyWith(
                    color: context.theme.backgroundColor,
                  ),
                ),
                style: context.theme.buttonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static openWifiDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Bạn đang offline'),
          content: Text('Bật dữ liệu di động hoặc wifi để tiếp tục ?'),
          actions: [
            TextButton(
              child: Text(
                'Cài đặt',
              ),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openWIFISettings();
              },
            ),
            TextButton(
              child: Text(
                'Hủy',
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );

  static showAttendanceDialog(
    BuildContext context, {
    required String title,
    required VoidCallback function,
    required VoidCallback cancelF,
  }) =>
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(Images.ic_error_lock),
                  SizedBoxExt.w15,
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 5,
                      style: AppTextStyles.regularW400(
                        context,
                        size: 14,
                        lineHeight: 20,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Tiếp tục',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      lineHeight: 18,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  onPressed: function,
                ),
                TextButton(
                  child: Text(
                    'Huỷ',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      lineHeight: 18,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  onPressed: cancelF,
                ),
              ],
            );
          });
}
