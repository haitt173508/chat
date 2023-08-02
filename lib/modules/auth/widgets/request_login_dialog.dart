// import 'package:chat_365/core/constants/string_constants.dart';
// import 'package:chat_365/core/theme/app_colors.dart';
// import 'package:chat_365/core/theme/app_dimens.dart';
// import 'package:chat_365/router/app_pages.dart';
// import 'package:chat_365/router/app_router.dart';
// import 'package:flutter/material.dart';

// class RequestLoginDialog extends StatelessWidget {
//   const RequestLoginDialog({
//     Key? key,
//     required this.message,
//   }) : super(key: key);

//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: AppDimens.space30),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             vertical: AppDimens.space50, horizontal: AppDimens.space30),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Center(
//               child: Text(
//                 message,
//                 maxLines: 4,
//                 textAlign: TextAlign.center,
//                 style: AppTextStyles.regularW400(
//                   context,
//                   size: AppDimens.textSize16,
//                   color: AppColors.black33,
//                   lineHeight: 22,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: AppDimens.space40,
//             ),
//             ButtonBorder(
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//               radius: 15,
//               color: AppColors.primary,
//               textColor: AppColors.white,
//               title: StringConst.login,
//               backColor: AppColors.primary,
//               onPressed: () =>
//                   AppRouter.backToPage(context, AppPages.Auth_Login),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
