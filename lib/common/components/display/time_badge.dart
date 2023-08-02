import 'dart:async';

import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TimeBadge extends StatefulWidget {
  const TimeBadge({
    Key? key,
    required this.lastOnlineTime,
    this.isShowJustOnline = false,
    this.onlineWidget = const SizedBox(),
    Widget Function(String)? builder,
  })  : this.builder = builder ?? _badgeTimeBuilder,
        super(key: key);

  final DateTime? lastOnlineTime;
  final bool isShowJustOnline;
  final Widget onlineWidget;
  final Widget Function(String) builder;

  @override
  State<TimeBadge> createState() => _TimeBadgeState();
}

class _TimeBadgeState extends State<TimeBadge> {
  DateTime? _lastOnlineTime;
  late Timer _timer;
  late final ValueNotifier<Duration> _diffTime;

  _updateTime(DateTime? newTime) {
    _lastOnlineTime = newTime;
    _diffTime.value = _getDiffTime();
    if (newTime == null) {
      if (_timer.isActive) _timer.cancel();
    } else {
      if (!_timer.isActive) _startTimer();
    }
  }

  _startTimer() => _timer = Timer.periodic(
        const Duration(minutes: 1),
        _timerCallback,
      );

  _timerCallback(timer) =>
      _diffTime.value = Duration(minutes: _diffTime.value.inMinutes + 1);

  Duration _getDiffTime() {
    if (_lastOnlineTime == null)
      return Duration.zero;
    else
      return DateTime.now().difference(_lastOnlineTime!);
  }

  String _getDiffString(Duration duration) {
    final days = duration.inDays;
    if (days >= 1) return '$days ngày';
    final hours = duration.inHours;
    if (hours >= 1) return '$hours giờ';
    final minutes = duration.inMinutes;
    if (minutes >= 1)
      return '$minutes phút';
    else
      return StringConst.recentAccess;
  }

  @override
  void initState() {
    _lastOnlineTime = widget.lastOnlineTime;
    _diffTime = ValueNotifier(_getDiffTime());
    _startTimer();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimeBadge oldWidget) {
    _updateTime(widget.lastOnlineTime);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastOnlineTime == null) return widget.onlineWidget;
    if (_lastOnlineTime != null && _diffTime.value.inDays > 7)
      return const SizedBox(
        key: ValueKey('empty'),
      );
    return ValueListenableBuilder<Duration>(
      key: ValueKey('builder'),
      valueListenable: _diffTime,
      builder: (context, value, child) =>
          (value.inMinutes < 1 && !widget.isShowJustOnline)
              ? const SizedBox(key: ValueKey('empty'))
              : widget.builder(_getDiffString(value)),
    );
  }
}

Widget _badgeTimeBuilder(String _diffTime) {
  return Card(
    key: ValueKey('key'),
    color: AppColors.greenF4FCE9,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    margin: EdgeInsets.zero,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: Text(
        _diffTime,
        style: const TextStyle(
          fontSize: 8,
          height: 9.68 / 8,
          color: AppColors.lima,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
