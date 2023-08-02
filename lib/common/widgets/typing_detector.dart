import 'package:chat_365/common/blocs/typing_detector_bloc/typing_detector_bloc.dart';
import 'package:chat_365/common/widgets/wavy_three_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypingDetector extends StatelessWidget {
  const TypingDetector({
    Key? key,
    required this.conversationId,
    this.builder,
  }) : super(key: key);

  final int conversationId;

  /// [builder]: widget hiển thị khi có user đang nhập
  ///
  /// Mặc định: chỉ hiển thị [WavyThreeDot]
  final Widget Function(BuildContext, Set<int>)? builder;

  @override
  Widget build(BuildContext context) {
    final _typingDetectorBloc = context.read<TypingDetectorBloc>();
    return BlocBuilder<TypingDetectorBloc, TypingDetectorState>(
      bloc: _typingDetectorBloc,
      builder: (context, state) {
        if (state.typingUserIds.isNotEmpty)
          return builder != null
              ? builder!(context, state.typingUserIds)
              : WavyThreeDot();
        return const SizedBox.shrink();
      },
    );
  }
}
