// import 'package:chat_365/common/components/display/display_avatar.dart';
// import 'package:chat_365/common/widgets/app_error_widget.dart';
// import 'package:chat_365/common/widgets/list_contact_view.dart';
// import 'package:chat_365/core/interfaces/interface_user_info.dart';
// import 'package:chat_365/core/theme/app_colors.dart';
// import 'package:chat_365/core/theme/app_text_style.dart';
// import 'package:chat_365/modules/profile/profile_cubit/profile_cubit.dart';
// import 'package:chat_365/modules/profile/profile_cubit/profile_state.dart';
// import 'package:chat_365/utils/data/extensions/context_extension.dart';
// import 'package:chat_365/utils/ui/widget_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class GroupProfileScreen extends StatefulWidget {
//   const GroupProfileScreen({
//     Key? key,
//     required this.conversationId,
//   }) : super(key: key);

//   static const conversationIdArg = 'conversationIdArg';

//   final int conversationId;

//   @override
//   State<GroupProfileScreen> createState() => _GroupProfileScreenState();
// }

// class _GroupProfileScreenState extends State<GroupProfileScreen> {
//   late final ProfileCubit _profileCubit;

//   @override
//   void initState() {
//     super.initState();
//     var userId = context.userInfo().id;
//     _profileCubit = ProfileCubit(
//       widget.conversationId,
//       isGroup: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(56),
//         child: BlocBuilder(
//           bloc: _profileCubit,
//           buildWhen: (_, state) => state is ProfileStateLoadDone,
//           builder: (_, state) {
//             if (state is ProfileStateLoadDone) {
//               return ProfileAppBar(
//                   userInfo: state.profile.conversationBasicInfo);
//             }
//             return AppBar();
//           },
//         ),
//       ),
//       body: BlocBuilder(
//         bloc: _profileCubit,
//         builder: (_, state) {
//           if (state is ProfileStateLoadDone)
//             return ListContactView(
//               itemBuilder: (_, index, child) {
//                 return child;
//               },
//               userInfos: state.profile.memberList,
//             );
//           if (state is ProfileStateLoadError)
//             return AppErrorWidget(error: state.error.toString());
//           return WidgetUtils.centerLoadingCircle;
//         },
//       ),
//     );
//   }
// }

// class ProfileAppBar extends StatelessWidget with PreferredSizeWidget {
//   ProfileAppBar({
//     Key? key,
//     required this.userInfo,
//     this.actions,
//   });

//   final IUserInfo userInfo;
//   final List<Widget>? actions;

//   @override
//   Size get preferredSize => Size.fromHeight(180);

//   @override
//   Widget build(BuildContext context) {
//     var avatar = DisplayAvatar(
//       isGroup: false,
//       model: userInfo,
//       size: 100,
//     );
//     return AppBar(
//       leading: Align(
//         alignment: Alignment.topLeft,
//         child: BackButton(
//           color: AppColors.white,
//         ),
//       ),
//       actions: actions,
//       // elevation: 0,
//       flexibleSpace: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Container(
//             height: 125,
//             color: AppColors.primary,
//           ),
//           Column(
//             children: [
//               SizedBox(height: context.mediaQueryPadding.top),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: avatar,
//               ),
//               Text(
//                 userInfo.name,
//                 style: AppTextStyles.regularW700(
//                   context,
//                   size: 18,
//                   lineHeight: 21.09,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       // backgroundColor: AppColors.primary,
//       // title: Align(
//       //   alignment: Alignment.topCenter,
//       //   child: avatar,
//       // ),
//       // centerTitle: true,
//     );
//   }
// }
