import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/home_qr_code/bloc/home_qr_bloc.dart';
import 'package:chat_365/modules/home_qr_code/bloc/home_qr_state.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  String? nameGroup;
  String? avatarGroup;
  String? admin;
  String? data;
  late final HomeQRCodeBloc _homeQRCodeBloc = HomeQRCodeBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Future didChangeDependencies() async {
    try {
      nameGroup = context.args['nameGroup'];
      avatarGroup = context.args['avatarGroup'];
      admin = context.args['admin'];
      data = context.args['data'];
      print('Dữ Liệu: $nameGroup - $avatarGroup - $admin - $data');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeQRCodeBloc,
      child: BlocListener<HomeQRCodeBloc, HomeQRCodeState>(
        listenWhen: (_, __) => mounted,
        listener: (_, state) async {
          AppRouter.removeAllDialog(context);
          if (state is AddGroupLoadingState)
            AppDialogs.showLoadingCircle(context);
          else if (state is HomeQRCodeError)
            AppDialogs.showFunctionLockDialog(
              context,
              title: _homeQRCodeBloc.error ?? '',
            );
        },
        child: Scaffold(
          backgroundColor: context.theme.backgroundFormFieldColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => AppRouter.backToPage(context, AppPages.Navigation),
                      icon: SvgPicture.asset(
                        Images.ic_x,
                        // color: AppColors.white,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
                SizedBoxExt.h60,
                Center(
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(blurRadius: 10, color: AppColors.primary.withOpacity(0.1), offset: const Offset(0, 2)),
                        ],
                        color: AppColors.white),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: avatarGroup ?? "",
                        height: 140,
                        width: 140,
                        placeholder: (context, url) => const SizedBox(
                          child: CircularProgressIndicator(),
                          width: 23,
                          height: 23,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBoxExt.h15,
                Text(
                  nameGroup ?? 'Không xác định',
                  style: AppTextStyles.regularW700(context, size: 20, color: context.theme.primaryColor),
                ),
                SizedBoxExt.h10,
                Text(
                  "Được tạo bởi ${admin}",
                  style: AppTextStyles.regularW400(context, size: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBoxExt.h50,
                InkWell(
                  onTap: () {
                    _homeQRCodeBloc.addGroupMessage(context.userInfo().id, data);
                  },
                  child: Ink(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    child: Text(
                      "Tham gia nhóm",
                      style: AppTextStyles.regularW700(context, size: 16, color: context.theme.backgroundFormFieldColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
