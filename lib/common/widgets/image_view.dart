// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';

// class ImageView extends StatelessWidget {
//   const ImageView({
//     Key? key,
//     required this.imageProvider,
//     required this.heroTag,
//   }) : super(key: key);

//   final ImageProvider imageProvider;
//   final Object heroTag;

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints.expand(
//         height: MediaQuery.of(context).size.height,
//       ),
//       child: PhotoView(
//         imageProvider: imageProvider,
//         backgroundDecoration: const BoxDecoration(color: Colors.black45),
//         minScale: 0.1,
//         maxScale: 1.3,
//         heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
//       ),
//     );
//   }
// }
