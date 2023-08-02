import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatioScreen extends StatefulWidget {
  const RatioScreen({Key? key}) : super(key: key);

  @override
  State<RatioScreen> createState() => _RatioScreenState();
}

class _RatioScreenState extends State<RatioScreen> {
  bool fit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tỷ lệ khung hình'),
        centerTitle: true,
      ),
      body: Container(
        height: 120,
        padding: AppPadding.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    fit=true;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Điều chỉnh để vừa',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    fit?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                  ],
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    fit=false;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tỷ lệ gốc',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    !fit?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
