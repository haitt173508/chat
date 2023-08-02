import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WidgetCircleChoose extends StatefulWidget {
  const WidgetCircleChoose({
    Key? key,
    this.title,
    this.onPress,
    this.id,
    this.idList,
  }) : super(key: key);

  final String? title;
  final VoidCallback? onPress;
  final String? id;

  final String? idList;

  @override
  State<WidgetCircleChoose> createState() => _WidgetCircleChooseState();
}

class _WidgetCircleChooseState extends State<WidgetCircleChoose> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
        onTap: widget.onPress,
        child: Row(
          children: [
            SvgPicture.asset(widget.id == widget.idList ? Images.ic_v : ''),
            const SizedBox(width: 16),
            Text(
              widget.title ?? '',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: widget.id == widget.idList ? AppColors.orange : AppColors.tundora),
            ),
          ],
        ),
      ),
    );
  }
}
