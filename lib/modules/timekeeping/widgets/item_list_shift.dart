import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ListShiftItem extends StatefulWidget {
  const ListShiftItem({
    Key? key,
    this.title,
    this.onPress,
    this.id,
    this.idList,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  final String? title;
  final String? startTime;
  final String? endTime;
  final VoidCallback? onPress;
  final String? id;
  final String? idList;

  @override
  State<ListShiftItem> createState() => _ListShiftItemState();
}

class _ListShiftItemState extends State<ListShiftItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.id == widget.idList
                ? SvgPicture.asset(Images.ic_v)
                : SizedBox(width: 16),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                widget.title ?? '',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: widget.id == widget.idList
                        ? AppColors.orange
                        : null),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 10),
            Text(
              ' ${widget.startTime ?? ""} - ${widget.endTime ?? ""} ',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: widget.id == widget.idList
                      ? AppColors.orange
                      : null),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
