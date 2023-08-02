// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chat_365/core/theme/app_colors.dart';
// import 'package:chat_365/core/theme/app_text_style.dart';
// import 'package:chat_365/router/app_pages.dart';
// import 'package:chat_365/router/app_router.dart';
// import 'package:chat_365/utils/data/extensions/context_extension.dart';
// import 'package:chat_365/utils/ui/widget_utils.dart';
// import 'package:flutter/material.dart';

// TextStyle _style(
//   BuildContext context,
// ) =>
//     AppTextStyles.regularW700(
//       context,
//       size: 14,
//       lineHeight: 22,
//       color: context.theme.textColor,
//     );

// class DetailImageScreen extends StatefulWidget {
//   const DetailImageScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<DetailImageScreen> createState() => _DetailImageScreenState();
// }

// class _DetailImageScreenState extends State<DetailImageScreen> {
//   bool onNoti = true;
//   List<String> galleryItems = [
//     'https://icdn.dantri.com.vn/thumb_w/640/2018/5/23/net-cuoi-be-gai-7-15270534400351230956726.jpg',
//     'https://9mobi.vn/cf/images/2015/03/nkk/hinh-anh-dep-1.jpg',
//     'https://taimienphi.vn/tmp/cf/aut/hinh-anh-dep-2.jpg',
//     'https://i.9mobi.vn/cf/images/2015/03/nkk/hinh-anh-dep-3.jpg',
//     'https://i.9mobi.vn/cf/images/2015/03/nkk/hinh-anh-dep-16.jpg',
//   ];

//   PageController _pageController = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         listTileTheme: ListTileThemeData(
//           contentPadding: EdgeInsets.zero,
//           dense: true,
//           minLeadingWidth: 20,
//           minVerticalPadding: 0,
//         ),
//       ),
//       child: Scaffold(
//           backgroundColor: AppColors.black,
//           appBar: AppBar(
//             elevation: 1,
//             leading: BackButton(
//               color: context.theme.iconColor,
//             ),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: PhotoViewGallery.builder(
//                   pageController: _pageController,

//                   builder: (BuildContext context, int index) {
//                     return PhotoViewGalleryPageOptions(
//                       imageProvider: NetworkImage(galleryItems[index]),
//                       initialScale: PhotoViewComputedScale.contained * 1,
//                       minScale: PhotoViewComputedScale.contained * 1,
//                       // heroAttributes:
//                       //     PhotoViewHeroAttributes(tag: galleryItems[index].id),
//                     );
//                   },
//                   itemCount: galleryItems.length,
//                   loadingBuilder: (context, event) => Center(
//                     child: Container(
//                       width: 120.0,
//                       height: 120.0,
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                   // backgroundDecoration: widget.backgroundDecoration,
//                   // pageController: widget.pageController,
//                   // onPageChanged: onPageChanged,
//                 ),
//               ),
//               Expanded(
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   separatorBuilder: (context, index) => SizedBoxExt.w5,
//                   // controller: ,
//                   itemCount: galleryItems.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         AppRouter.toPage(context, AppPages.Detail_Image);
//                       },
//                       child: SizedBox(
//                         width: 60,
//                         height: 60,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(5),
//                           child: CachedNetworkImage(
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Container(
//                               child: Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                             ),
//                             imageUrl: galleryItems[index],
//                             errorWidget: (context, url, error) => Container(
//                               color: AppColors.gray,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           )),
//     );
//   }
// }
