import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/new_conversation/screens/select_contact_view.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';

class SelectListUserCheckBox extends StatelessWidget {
  const SelectListUserCheckBox({
    Key? key,
    this.title,
    required this.onSubmitted,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  final String? title;

  final ErrorCallback<List<IUserInfo>> onSubmitted;

  final ValueChanged<List<IUserInfo>> onSuccess;

  final ValueChanged<ExceptionError>? onError;

  @override
  Widget build(BuildContext context) {
    List<IUserInfo> selectedUser = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? '',
          style: AppTextStyles.regularW700(context, size: 18),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Column(
          children: [
            Expanded(
              child: SelectContactView(
                onChanged: (value) => selectedUser = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: RoundedButton(
                label: 'Xong',
                fillStyle: true,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                onPressed: () async {
                  AppDialogs.showLoadingCircle(context);
                  var error = await onSubmitted(selectedUser);
                  AppRouter.removeAllDialog(context);
                  if (error != null) {
                    if (onError != null) onError!(error);
                    AppDialogs.toast(error.toString());
                  } else {
                    onSuccess(selectedUser);
                    AppRouter.back(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
