import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class WhiteBoardPagesScreen extends StatefulWidget {
  const WhiteBoardPagesScreen({Key? key}) : super(key: key);

  @override
  State<WhiteBoardPagesScreen> createState() => _WhiteBoardPagesScreenState();
}

class _WhiteBoardPagesScreenState extends State<WhiteBoardPagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLilac,
      appBar: AppBar(
        title: Text('Các trang'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: AppPadding.paddingAll16,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2,
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: ()=>Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: AppBorderAndRadius.defaultBorderRadius,
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: context.theme.iconColor,
                        blurRadius: 1,
                      )
                    ]),
              ),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
