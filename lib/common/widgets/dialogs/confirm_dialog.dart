import 'dart:async';

import 'package:chat_365/common/widgets/dialogs/success_content.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.onDelete,
    required this.successMessage,
    required this.name,
    this.header,
    this.content,
    this.onError,
    this.onSuccess,
    this.isReversed = false,
    this.confirmTextColor,
  }) : super(key: key);

  final String title;
  final String name;
  final Widget? content;
  final Widget? header;
  final ErrorCallback onDelete;
  final ValueChanged<ExceptionError>? onError;
  final VoidCallback? onSuccess;
  final String successMessage;
  final bool isReversed;
  final Color? confirmTextColor;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  var _state = DialogState.init;
  late Widget child;

  Widget _dialogButton(
    String label, {
    required VoidCallback onPressed,
    final Color? textColor,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        label,
        style: AppTextStyles.regularW700(
          context,
          size: 16,
          lineHeight: 22,
          color: textColor ?? context.theme.primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var children2 = [
      _dialogButton(
        'HỦY',
        onPressed: () {
          AppRouter.back(context);
        },
      ),
      const SizedBox(width: 30),
      _dialogButton(
        '${widget.name.toUpperCase()}',
        textColor: widget.confirmTextColor,
        onPressed: () async {
          setState(() {
            _state = DialogState.processing;
          });
          var error = await widget.onDelete(null);
          if (error != null) {
            if (widget.onError != null) widget.onError!(error);
            setState(() {
              _state = DialogState.init;
            });
          } else {
            setState(() {
              _state = DialogState.success;
            });
          }
        },
      ),
    ];
    switch (_state) {
      case DialogState.init:
        child = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.header != null) widget.header!,
            Text(widget.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.regularW700(context, size: 16)),
            if (widget.content != null) widget.content!,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
                  widget.isReversed ? children2.reversed.toList() : children2,
            )
          ],
        );
        break;
      case DialogState.success:
        child = Center(
          child: SuccessContent(message: widget.successMessage),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          AppRouter.removeAllDialog(context);
          widget.onSuccess?.call();
        });
        break;
      case DialogState.processing:
        child = WidgetUtils.centerLoadingCircle;
    }
    return WillPopScope(
      onWillPop: () => Future.value(_state != DialogState.processing),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
          ],
        ),
      ),
    );
  }
}

typedef ErrorCallback<T> = FutureOr<ExceptionError?> Function(T);

enum DialogState {
  init,
  processing,
  success,
}
