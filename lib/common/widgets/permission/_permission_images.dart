import 'package:chat_365/common/images.dart';
import 'package:flutter/material.dart';

class PermissionImage extends StatelessWidget {
  const PermissionImage({Key? key}) : super(key: key);

  static final List<String> _images = [
    Images.img_permission_2,
    Images.img_permission_1,
    Images.img_permission_3,
  ];

  Widget _imageBuilder(String imageAsset, {double dx = 0.0}) {
    return Transform.translate(
      offset: Offset(dx, 0),
      child: Image.asset(imageAsset),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageBuilder(_images[0], dx: -40),
        _imageBuilder(_images[1], dx: 60),
        _imageBuilder(_images[2], dx: -60),
      ],
    );
  }
}
