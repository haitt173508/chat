import 'package:chat_365/common/blocs/typing_detector_bloc/typing_detector_bloc.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/common/widgets/form/social_textfield/model/detected_type_enum.dart';
import 'package:chat_365/common/widgets/form/social_textfield/model/social_content_detection_model.dart';
import 'package:chat_365/common/widgets/typing_detector.dart';
import 'package:chat_365/common/widgets/user_list_tile.dart';
import 'package:chat_365/common/widgets/wavy_three_dot.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_bar.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/overlay_extension.dart';
import 'package:chat_365/utils/data/extensions/text_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreenInputBar extends StatefulWidget {
  const ChatScreenInputBar({
    Key? key,
    required this.chatInputBarKey,
    required this.onSend,
    this.onTypingChanged,
  }) : super(key: key);

  final GlobalKey<ChatInputBarState> chatInputBarKey;
  final ValueChanged<List<ApiMessageModel>> onSend;
  final ValueChanged<bool>? onTypingChanged;

  @override
  State<ChatScreenInputBar> createState() => _ChatScreenInputBarState();
}

class _ChatScreenInputBarState extends State<ChatScreenInputBar>
    with SingleTickerProviderStateMixin {
  late final ChatDetailBloc _chatDetailBloc;
  late final TypingDetectorBloc _typingDetectorBloc;
  late final Text typingText;
  late final double typingTextWidth;
  late final double typingUserMaxWidth;
  late final Widget typingRowWidget;
  late final AnimationController _featureBottomSheetController;
  Widget? featureBottomSheet;

  TextEditingController get inputController =>
      widget.chatInputBarKey.currentState!.inputController;

  List<IUserInfo> _suggestTag = [];

  SocialContentDetection? _detection;

  Widget tagSuggestBuilder(BuildContext context) => Material(
        color: context.theme.isDarkTheme ? AppColors.black : AppColors.white,
        shadowColor: AppColors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.greyCC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        elevation: 8.0,
        child: Container(
          constraints: BoxConstraints(maxHeight: 200),
          padding:
              _suggestTag.isEmpty ? null : EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(),
          child: ListView.separated(
            itemCount: _suggestTag.length,
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemBuilder: _suggestTagBuilder,
          ),
        ),
      );

  Widget _suggestTagBuilder(BuildContext context, int index) {
    var item = _suggestTag[index];
    return UserListTile(
      avatar: DisplayAvatar(
        isGroup: false,
        model: item,
      ),
      userName: item.name,
      onTapUserName: () {
        var text2 = inputController.text;
        var newText = text2.substring(0, _detection!.range.start) +
            '@' +
            item.name.replaceAll(' ', '') +
            ' ';
        inputController
          ..text = newText + '  '
          ..selection = TextSelection.fromPosition(
            TextPosition(
              offset: newText.length + 1,
            ),
          );
      },
    );
  }

  // The OverlayEntry containing the options.
  OverlayEntry? _floatingOptions;
  final LayerLink _optionsLayerLink = LayerLink();
  // Called when the field's FocusNode changes.
  void _onChangedFocus() {
    _updateOverlay();
  }

  // True iff the state indicates that the options should be visible.
  bool get _shouldShowOptions =>
      (widget.chatInputBarKey.currentState!.focusNode.hasFocus &&
          _suggestTag.isNotEmpty);

  void _updateOverlay() {
    if (_shouldShowOptions) {
      try {
        _floatingOptions?.removeIfExistInObserveOverlay();
      } catch (e) {}
      _floatingOptions = OverlayEntry(
        builder: (BuildContext context) {
          return Center(
            child: CompositedTransformFollower(
              link: _optionsLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.bottomLeft,
              // offset: Offset(0, -inputBarHeight),
              child: tagSuggestBuilder(context),
            ),
          );
        },
      );
      Overlay.of(context, rootOverlay: true)!
          .insertWithObserve(_floatingOptions!);
    } else if (_floatingOptions != null) {
      _floatingOptions!.removeIfExistInObserveOverlay();
      _floatingOptions = null;
    }
  }

  int get _conversationId => _chatDetailBloc.conversationId;
  Iterable<int> get listMemeberIds => _chatDetailBloc.listUserInfoBlocs.keys;

  @override
  void initState() {
    _featureBottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          // isShowFeatureBottomSheet = false;
        }
      });
    _chatDetailBloc = context.read<ChatDetailBloc>();
    _typingDetectorBloc = context.read<TypingDetectorBloc>();
    typingText = Text(
      ' đang nhập ',
      style: context.theme.typingTextStyle,
    );

    typingTextWidth = typingText.getSize().width;

    typingRowWidget = Row(
      children: [
        typingText,
        WavyThreeDot(),
      ],
    );

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.chatInputBarKey.currentState!.focusNode
          .addListener(_onChangedFocus);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    try {
      typingUserMaxWidth =
          context.mediaQuerySize.width - WavyThreeDot.width - typingTextWidth;
    } catch (e) {}
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _floatingOptions?.remove();
    _floatingOptions = null;
    widget.chatInputBarKey.currentState?.focusNode
        .removeListener(_onChangedFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _optionsLayerLink,
          child: const Divider(height: 1, color: AppColors.greyCC),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: DefaultTextStyle(
            style: context.theme.typingTextStyle,
            child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
              bloc: _chatDetailBloc,
              buildWhen: (prev, current) =>
                  current is ChatDetailStateLoadDetailDone,
              builder: (context, state) {
                return BlocProvider.value(
                  value: _typingDetectorBloc,
                  child: TypingDetector(
                    conversationId: _conversationId,
                    builder: (context, userIds) {
                      final List<String> list = [];
                      for (var id in userIds) {
                        for (var info
                            in _chatDetailBloc.listUserInfoBlocs.values) {
                          var currentInfo = info.state.userInfo;
                          if (currentInfo.id == id) {
                            list.add(info.state.userInfo.name);
                            break;
                          }
                        }
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: typingUserMaxWidth,
                              ),
                              child: Text(
                                list.join(', '),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          typingRowWidget,
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        ChatInputBar(
          key: widget.chatInputBarKey,
          conversationId: _conversationId,
          chatDetailBloc: _chatDetailBloc,
          onSend: widget.onSend,
          onChangedAutoDeleteTime: (autoDeleteTime) {
            if (_chatDetailBloc.detail != null) {
              _chatDetailBloc
                ..detail!.autoDeleteMessageTimeModel =
                    AutoDeleteMessageTimeModel(
                  deleteTime: autoDeleteTime,
                  deleteType: AutoDeleteMessageType.autoDelete.index,
                )
                ..autoDeleteTimeMessage = autoDeleteTime;
            }
          },
          onDetectListener: (detection) {
            // logger.log(detection);
            if (detection.type == DetectedType.mention) {
              _detection = detection;
              final Iterable<IUserInfo> userInfos =
                  _chatDetailBloc.listUserInfoBlocs.values.map(
                (e) => e.state.userInfo,
              );
              _suggestTag = [
                ...SystemUtils.searchFunction(
                  detection.text.replaceAll('@', ''),
                  userInfos,
                ),
              ];
            } else
              _suggestTag = [];
            _updateOverlay();
          },
          onTypingChanged: (value) => widget.onTypingChanged?.call(value),
        ),
      ],
    );
  }
}

class _FeatureBottomSheetOverlayBuilder extends AnimatedWidget {
  final AnimationController controller;
  final Widget child;

  _FeatureBottomSheetOverlayBuilder({
    required this.controller,
    required this.child,
  }) : super(
          listenable: controller,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black.withOpacity(0.5),
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Align(
              heightFactor: controller.value,
              child: FadeTransition(
                child: child!,
                opacity: controller,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
