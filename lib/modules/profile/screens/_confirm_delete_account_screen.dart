import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/auth/repo/auth_repo.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmDeleteAccountScreen extends StatelessWidget {
  const ConfirmDeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConst.deleteAccount),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              Images.img_delete,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Tài khoản của bạn sẽ bị xóa vĩnh viễn và không thể khôi phục lại dữ liệu!\nBạn có chắc muốn xóa?',
                style: AppTextStyles.regularW400(
                  context,
                  size: 18,
                  lineHeight: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              child: Text(
                StringConst.deleteAccount,
                style: AppTextStyles.regularW400(
                  context,
                  size: 18,
                  lineHeight: 24,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: AppColors.red,
              ),
              onPressed: () async {
                AppDialogs.showLoadingCircle(context);
                var error = await context.read<AuthRepo>().deleteAccount();
                AppRouter.removeAllDialog(context);
                if (error == null)
                  SystemUtils.logout(context);
                else
                  AppDialogs.toast(error.error);
              },
            ),
          ],
        ),
      ),
    );
  }
}
