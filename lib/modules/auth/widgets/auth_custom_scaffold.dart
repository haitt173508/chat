import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class AuthCustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const AuthCustomScaffold({Key? key, required this.title, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: AppTextStyles.authTitle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary,),
          onPressed: () {},
        ),
      ),
      body: body,
    );
  }
}
