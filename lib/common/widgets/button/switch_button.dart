import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    Key? key,
    this.initValue = false,
    required this.onChanged,
  }) : super(key: key);
  final bool initValue;
  final Future<String?> Function(bool) onChanged;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  late bool _value;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initValue;
  }

  @override
  void didUpdateWidget(covariant SwitchButton oldWidget) {
    if (_value != widget.initValue) {
      _value = widget.initValue;
      _isLoading = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
          const SizedBox(width: 8),
          FlutterSwitch(
            value: _value,
            width: 40.0,
            height: 22.0,
            valueFontSize: 21.0,
            toggleSize: 17.0,
            padding: 2,
            activeColor: context.theme.primaryColor,
            onToggle: (value) async {
              setState(() => _isLoading = true);
              var error = await widget.onChanged(value);
              setState(
                () {
                  _isLoading = false;
                  if (error == null) {
                    _value = !_value;
                  } else {
                    AppDialogs.toast(error);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
