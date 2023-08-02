import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:flutter/material.dart';

class DisplayAvatar extends StatelessWidget {
  DisplayAvatar({
    Key? key,
    this.size = 36,
    required this.isGroup,
    required this.model,
    this.enable = true,
    this.enabledTapCallback,
  }) : super(key: key);

  final double size;
  final IUserInfo model;
  final bool isGroup;
  final bool enable;
  final VoidCallback? enabledTapCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable
          ? (enabledTapCallback ??
              () => AppRouterHelper.toProfilePage(
                    context,
                    userInfo: model,
                    isGroup: isGroup,
                  ))
          : null,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
        child: ClipOval(child: _buildChild(context)),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (model.avatar is List<int>)
      return Image.memory(
        Uint8List.fromList(model.avatar as List<int>),
        height: size,
        width: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, _, __) => _errorBuilder(context),
      );
    else if (model.avatar is String && (model.avatar as String).isNotEmpty)
      // return _loadBuilder(context, size);
      return CachedNetworkImage(
        imageUrl: model.avatar,
        filterQuality: FilterQuality.medium,
        progressIndicatorBuilder: (context, _, __) =>
            _loadBuilder(context, size),
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorWidget: (context, _, __) => _errorBuilder(context),
      );

    return _errorBuilder(context);
  }

  Widget _loadBuilder(context, double size) => _errorBuilder(context);

  Widget _errorBuilder(context) {
    return Image.asset(Images.img_non_avatar);
    // /// Hiển thì chữ cái đầu trong tên
    // /// Màu chữ hiển thị avatar group
    // /// Màu avatar background color = 30%
    // var name = model.name;

    // var character =
    //     name.isNotEmpty ? name[0].toEngAlphabetString().toUpperCase() : '';
    // var charIndex = alphabet.indexOf(character).clamp(1, 35).toInt();
    // var nonAvatarPrimaryColor =
    //     Colors.primaries[(Colors.primaries.length - 1) % charIndex];

    // return Container(
    //   decoration: BoxDecoration(
    //     color: nonAvatarPrimaryColor.withOpacity(0.25),
    //   ),
    //   alignment: Alignment.center,
    //   child: Text(
    //     character,
    //     style: AppTextStyles.regularW700(
    //       context,
    //       size: size / 2,
    //       color: nonAvatarPrimaryColor,
    //     ),
    //     textHeightBehavior: TextHeightBehavior(
    //       leadingDistribution: TextLeadingDistribution.even,
    //     ),
    //   ),
    // );
  }
}

var alphabet = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'G',
  'H',
  'I',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'Ư',
  'V',
  'X',
  'W',
  'Z',
  'Y',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
];

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    Key? key,
    this.dimension,
    this.boxDecoration,
    this.size,
  }) : super(key: key);

  final double? dimension;
  final Size? size;
  final BoxDecoration? boxDecoration;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  get shimmerGradient => LinearGradient(
        colors: [
          Color(0xFFEBEBF4),
          Color(0xFFF4F4F4),
          Color(0xFFEBEBF4),
        ],
        stops: [
          0.1,
          0.3,
          0.6,
        ],
        begin: Alignment(-1.0, -0.3),
        end: Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
        transform:
            _SlidingGradientTransform(slidePercent: _shimmerController.value),
      );

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000))
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.values[5],
      shaderCallback: (bounds) => shimmerGradient.createShader(bounds),
      child: Container(
        height: widget.size?.height ?? widget.dimension,
        width: widget.size?.width ?? widget.dimension,
        decoration: widget.boxDecoration?.copyWith(
          color: Colors.white,
        ),
        color: widget.boxDecoration == null ? Colors.white : null,
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
