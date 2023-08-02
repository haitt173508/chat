import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'accept_login_screen.dart';
import 'home_qr_code_screens.dart';
import 'my_qr_code_screen.dart';

class NavigationQRCodeScreen extends StatefulWidget {
  const NavigationQRCodeScreen({Key? key}) : super(key: key);

  @override
  State<NavigationQRCodeScreen> createState() => _NavigationQRCodeScreenState();
}

class _NavigationQRCodeScreenState extends State<NavigationQRCodeScreen> {
  late final MyTheme _myTheme;
  late List<BottomNavigationBarItem> _items;
  late int _screenIndex;

  changeScreen(int index) => setState(() {
        _screenIndex = index;
      });

  @override
  void initState() {
    _myTheme = context.theme;
    _screenIndex = 0;
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _items = [
      _bottomNavigationBarItem(
        AssetPath.ic_qr_no_color,
        StringConst.scanQR,
        AssetPath.ic_home_qr,
      ),
      _bottomNavigationBarItem(
        AssetPath.ic_user_no_color,
        StringConst.myQR,
        AssetPath.ic_user,
      ),
    ];
    var _screens = [
      HomeQRCodeScreens(),
      MyQRCodeScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        children: _screens,
        index: _screenIndex,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: AppColors.greyCC,
          width: 1,
        ))),
        child: BottomNavigationBar(
          currentIndex: _screenIndex,
          items: _items,
          onTap: changeScreen,
          elevation: 4.0,
          selectedFontSize: 13,
          unselectedFontSize: 13,
        ),
      ),
    );
  }

  _bottomNavigationBarItemIcon(
    String iconAsset, {
    required Color color,
    bool isActivated = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: SizedBox.fromSize(
        size: const Size.square(AppConst.kBottomNavigationBarItemIconSize),
        child: isActivated
            ? ShaderMask(
                child: SvgPicture.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                  height: AppConst.kBottomNavigationBarItemIconSize,
                  width: AppConst.kBottomNavigationBarItemIconSize,
                ),
                shaderCallback: (Rect bounds) => _myTheme.gradient.createShader(bounds),
              )
            : SvgPicture.asset(
                iconAsset,
                fit: BoxFit.contain,
                color: _myTheme.unSelectedIconColor,
                height: AppConst.kBottomNavigationBarItemIconSize,
                width: AppConst.kBottomNavigationBarItemIconSize,
              ),
      ),
    );
  }

  _bottomNavigationBarItem(
    String iconAsset,
    String label,
    String selectedIconAsset,
  ) {
    return BottomNavigationBarItem(
      icon: _bottomNavigationBarItemIcon(
        iconAsset,
        color: _myTheme.unSelectedIconColor,
      ),
      label: label,
      activeIcon: _bottomNavigationBarItemIcon(
        selectedIconAsset,
        color: context.theme.primaryColor,
        isActivated: true,
      ),
    );
  }
}
