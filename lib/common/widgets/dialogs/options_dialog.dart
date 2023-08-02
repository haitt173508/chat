import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class OptionsDialogItem {
  final String name;
  final Widget? icon;
  final void Function() onTap;

  OptionsDialogItem({
    required this.name,
    this.icon,
    required this.onTap,
  });
}

class OptionsDialog extends StatelessWidget {
  const OptionsDialog({
    Key? key,
    this.title,
    required this.items,
  }) : super(key: key);

  final String? title;
  final List<OptionsDialogItem> items;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 345,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 8,
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 25,
                    bottom: 6,
                    left: 25,
                  ),
                  child: Text(title!, style: AppTextStyles.optionsDialogItem),
                ),
              for (int i = 0; i < items.length; i++)
                _Item(
                  borderRadius: title == null && i == 0
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )
                      : null,
                  item: items[i],
                ),
              SizedBoxExt.h10,
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.item,
    this.borderRadius,
  }) : super(key: key);

  final OptionsDialogItem item;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        item.onTap();
        AppRouter.back(context);
      },
      borderRadius: borderRadius,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [
            if (item.icon != null) ...[
              item.icon!,
              SizedBoxExt.w15,
            ],
            Text(
              item.name,
              style: AppTextStyles.dropdownItem,
            ),
          ],
        ),
      ),
    );
  }
}
