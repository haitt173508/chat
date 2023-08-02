import 'dart:io';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/social_textfield/controller/social_text_editing_controller.dart';
import 'package:chat_365/common/widgets/form/social_textfield/model/social_content_detection_model.dart';
import 'package:chat_365/common/widgets/reply_message_builder.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/widgets/_chat_bar_feature_bottom_sheet.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_field.dart';
import 'package:chat_365/modules/chat/widgets/feature_item.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/auto_delete_time.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/permission_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    Key? key,
    required this.conversationId,
    required this.onSend,
    required this.chatDetailBloc,
    required this.onChangedAutoDeleteTime,
    this.onTypingChanged,
    this.onTapDetectedContentDetection,
    this.onDetectListener,
  }) : super(key: key);

  final int conversationId;

  final ChatDetailBloc chatDetailBloc;

  /// Callback khi nhấn nút Gửi
  final ValueChanged<List<ApiMessageModel>> onSend;
  final ValueChanged<SocialContentDetection>? onTapDetectedContentDetection;
  final ValueChanged<SocialContentDetection>? onDetectListener;
  final ValueChanged<int> onChangedAutoDeleteTime;

  /// Callback khi trạng thái editing thay đổi
  ///
  /// VD: Emit [ChatSocketEvent.Typing] và [ChatSocketEvent.StopTyping]
  final ValueChanged<bool>? onTypingChanged;

  @override
  State<ChatInputBar> createState() => ChatInputBarState();
}

class ChatInputBarState extends State<ChatInputBar>
    with TickerProviderStateMixin {
  late Widget _sendButton;
  late Widget _iconSend;
  late final userInfo;
  late final theme;

  late final Widget featureBottomSheet = Container(
    decoration: BoxDecoration(
      color: theme.backgroundColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 30,
    ),
    child: ChatBarFeatureBottomSheet(
      items: features,
    ),
  );
  late final Widget _optionButtons = Row(
    children: [
      _OptionButton(
        onPressed: _onTapCameraButton,
        pathToSvgIcon: Images.ic_camera_1,
      ),
      _OptionButton(
        onPressed: _onTapPickImageFromGallery,
        pathToSvgIcon: Images.ic_ei_image,
      ),
      _OptionButton(
        onPressed: _onTapPickFileFromGallery,
        pathToSvgIcon: Images.ic_file_add,
      ),
      _OptionButton(
        onPressed: _showToolMBS,
        pathToSvgIcon: Images.ic_chat_options,
      )
    ],
  );

  late final AnimationController _permissionAnimatedController;
  late final AnimationController _featureBottomSheetController;
  int _autoDeleteTime = AutoDeleteTime.never.inSeconds;

  _onTapCameraButton() {
    _hideToolMBS();
    SystemUtils.permissionCallback(
      Permission.camera,
      _pickImgFromCamera,
    );
  }

  _hideToolMBS() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_featureBottomSheetController.isCompleted)
      _featureBottomSheetController.reverse();
  }

  void _showToolMBS() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_permissionAnimatedController.isCompleted)
      _permissionAnimatedController.reverse();
    if (_featureBottomSheetController.isCompleted)
      _featureBottomSheetController.reverse();
    else
      _featureBottomSheetController.forward(
        from: _featureBottomSheetController.value,
      );
  }

  late final List<FeatureItem> features;

  // late final Widget _addFileButton;

  SocketSentMessageModel? originMessage;

  String? get messageId => originMessage?.messageId;

  final ValueNotifier<bool> _isEditing = ValueNotifier(false);
  final ValueNotifier<List<File>> _pickedFiles = ValueNotifier([]);
  final ValueNotifier<ApiRelyMessageModel?> _isReplying = ValueNotifier(null);
  final ValueNotifier<OptionType?> _selectedOptionType = ValueNotifier(null);

  late final SocialTextEditingController _inputController;

  ApiRelyMessageModel? get replyingMessage => _isReplying.value;
  bool get isEditing => _isEditing.value;

  SocialTextEditingController get inputController => _inputController;
  FocusNode get focusNode => _focusNode;

  final _picker = ImagePicker();
  final _focusNode = FocusNode();

  _pickImgFromCamera() async {
    XFile? result = await _picker.pickImage(source: ImageSource.camera);

    if (result == null) return;

    _addToPickedFiles([File(result.path)]);
  }

  _pickFileFromGallery() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        allowMultiple: true,
        withData: false,
        allowedExtensions: AppConst.supportNonImageFileTypes,
        type: FileType.custom,
        onFileLoading: (status) {
          logger.log(status);
        },
      );

      if (result == null) return;

      _addToPickedFiles(result.files.map((e) => File(e.path!)));
    } catch (e) {
      _permissionAnimatedController.forward();
    }
  }

  _onTapPickFileFromGallery() async {
    _hideToolMBS();
    _onPressedCallbackWithPermission(
      context,
      permission: PermissionExt.libraryPermission,
      controller: _permissionAnimatedController,
      callBack: _pickFileFromGallery,
    );

    // SystemUtils.permissionCallback(
    //   Permission.mediaLibrary,
    //   _pickFileFromGallery,
    // );
  }

  _pickImageFromGallery() async {
    try {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 10,

          // selectedAssets: _pickedAssetEntity.toList(),
          requestType: RequestType.image,
          textDelegate: VietnameseAssetPickerTextDelegate(),
        ),
      );

      if (result != null) {
        // _pickedAssetEntity.addAll(result);
        var files = <File>[];
        for (var e in result) {
          var file = await e.file;
          files.add(file!);
        }
        _addToPickedFiles(files);
      }
    } catch (e) {
      _permissionAnimatedController.forward();
    }
  }

  _onTapPickImageFromGallery() async {
    _hideToolMBS();
    _onPressedCallbackWithPermission(
      context,
      permission: Permission.mediaLibrary,
      controller: _permissionAnimatedController,
      callBack: _pickImageFromGallery,
    );
    // SystemUtils.permissionCallback(
    //   Permission.accessMediaLocation,
    //   _pickImageFromGallery,
    // );
  }

  _addToPickedFiles(Iterable<File> files) {
    _pickedFiles.value = [..._pickedFiles.value, ...files];
    _onTapSendButton();
  }

  // _removePickedFilesAt(int index) =>
  //     _pickedFiles.value = [..._pickedFiles.value..removeAt(index)];

  _cancelReply() {
    _isReplying.value = null;
    _isEditing.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
  }

  _computeIsEditing(String value) {
    if (value.isEmpty) return _isEditing.value = false;
    if (!_isEditing.value) {
      if (value.isNotEmpty && !_isEditing.value) {
        _isEditing.value = true;
      } else if (value.isEmpty && _isEditing.value) {
        _isEditing.value = false;
      }
    }
  }

  void _onTapSendButton() {
    var messageId = originMessage?.messageId ??
        GeneratorService.generateMessageId(userInfo.id);
    var replyMsg = _isReplying.value;
    var conversationId = widget.conversationId;

    var messages = SystemUtils.getListApiMessageModels(
      senderInfo: userInfo,
      conversationId: conversationId,
      files: _pickedFiles.value,
      messageId: messageId,
      replyModel: replyMsg,
      text: _inputController.text,
      createdAt: originMessage?.createAt,
    );

    widget.onSend(messages);

    // FilePicker.platform.clearTemporaryFiles();

    _pickedFiles.value = [];

    if (_isReplying.value != null) _isReplying.value = null;

    if (!isEditMode) _inputController.clear();

    setState(() {});
  }

  exitEditMode() {
    logger.log('Exit edit mode');
    originMessage = null;
    _isEditing.value = false;
    _isReplying.value = null;
    _inputController.clear();
    // setState(() {});
  }

  replyMessage(ApiRelyMessageModel replyModel) {
    _isReplying.value = replyModel;
    _isEditing.value = true;
    _focusNode.requestFocus();
  }

  editMessage(SocketSentMessageModel message) {
    var _message = message.message ?? '';
    _inputController..text = _message;
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: _inputController.text.length),
    );
    originMessage = message;
    _isEditing.value = true;
    _isReplying.value = message.relyMessage;
    _pickedFiles.value = [];
    _focusNode.requestFocus();
  }

  bool get isEditMode => _isEditing.value && originMessage != null;

  @override
  void initState() {
    super.initState();
    userInfo = context.userInfo();
    theme = context.theme;

    _autoDeleteTime = widget.chatDetailBloc.autoDeleteTimeMessage;
    _permissionAnimatedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _featureBottomSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    features = [
      FeatureItem(
        label: StringConst.location,
        assetPath: Images.ic_location,
        onTap: () {
          AppRouterHelper.toSendLocationPage(
            context,
            chatDetailBloc: widget.chatDetailBloc,
          );
        },
        gradient: LinearGradient(
          colors: [
            Color(0xFF70CAFF),
            Color(0xFFB0E2FD),
          ],
        ),
      ),
      FeatureItem(
        label: StringConst.sendContactCard,
        assetPath: Images.ic_contact_card,
        onTap: () {
          AppRouterHelper.toSendContactPage(
            context,
            conversationBasicInfo: widget.conversationId,
          );
        },
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7B3BE),
            Color(0xFFFCC3CC),
          ],
        ),
      ),
      FeatureItem(
        label: 'Tạo nhắc hẹn',
        assetPath: Images.ic_alarm_clock,
        onTap: () => AppRouterHelper.toCreateAppointmentPage(context),
        gradient: LinearGradient(
          colors: [
            Color(0xFFB2CB62),
            Color(0xFF9AD6B2),
          ],
        ),
      ),
      FeatureItem(
        label: StringConst.autoDeleteMessage,
        assetPath: Images.ic_trash_2,
        onTap: () async {
          final AutoDeleteTime? seleted = await AppDialogs.showRadioDialog(
            context,
            items: AutoDeleteTime.values,
            init: AutoDeleteTime.values.firstWhere(
              (e) => e.inSeconds == _autoDeleteTime,
              orElse: () => AutoDeleteTime.never,
            ),
          );
          if (seleted != null) {
            widget.onChangedAutoDeleteTime(seleted.inSeconds);
            _autoDeleteTime = seleted.inSeconds;
          }
        },
        gradient: LinearGradient(
          colors: [
            Color(0xFFEF5DA8),
            Color(0xFFEF5DA8),
          ],
        ),
      ),
    ];
    _setupSendButton();
    // _addFileButton = SizedBox(
    //   height: double.infinity,
    //   width: 40,
    //   child: ElevatedButton(
    //     onPressed: _pickFileFromGallery,
    //     child: Icon(Icons.add),
    //     style: ElevatedButton.styleFrom(
    //       padding: EdgeInsets.zero,
    //       minimumSize: Size.fromWidth(40),
    //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //     ),
    //   ),
    // );
    _inputController = SocialTextEditingController(
      onTapDetectedContentDetection: widget.onTapDetectedContentDetection,
    )
      // ..setTextStyle(
      //   DetectedType.mention,
      //   TextStyle(
      //     color: Colors.purple,
      //     backgroundColor: Colors.purple.withAlpha(50),
      //   ),
      // )
      ..addListener(_inputListener);
    if (widget.onDetectListener != null)
      _inputController.subscribeToDetection(widget.onDetectListener!);

    _focusNode.addListener(_focusNodeListener);
  }

  _focusNodeListener() {
    _editModeListener();
    _featureBottomSheetListener();
  }

  _featureBottomSheetListener() {
    if ((_focusNode.hasFocus || _focusNode.hasPrimaryFocus) &&
        _featureBottomSheetController.isCompleted)
      _featureBottomSheetController.reverse(from: 0);
  }

  _editModeListener() {
    try {
      if (!_focusNode.hasFocus &&
          _inputController.text.isEmpty &&
          originMessage != null) exitEditMode();
    } catch (e) {}
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setupSendButton();
  }

  @override
  void dispose() {
    // FilePicker.platform.clearTemporaryFiles();
    _inputController.removeListener(_inputListener);
    _inputController.dispose();
    _focusNode.removeListener(_focusNodeListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _inputListener() {
    _tagListner();
  }

  void _tagListner() {
    // logger.log(_inputController.selection.base.offset);
  }

  void _setupSendButton() {
    _iconSend = Container(
      height: 48,
      width: 48,
      margin: EdgeInsets.only(left: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: theme.gradient,
      ),
      child: SvgPicture.asset(
        Images.ic_send,
        color: Colors.white,
      ),
    );
    _sendButton = InkWell(
      onTap: _onTapSendButton,
      child: _iconSend,
    );
  }

  @override
  Widget build(BuildContext context) {
    var originMessageTextColor = theme.replyOriginTextStyle.color;
    _computeIsEditing(_inputController.text);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation:
                Listenable.merge([_isEditing, _pickedFiles, _isReplying]),
            builder: (context, child) {
              var _isTyping = _isEditing.value ||
                  _pickedFiles.value.isNotEmpty ||
                  _isReplying.value != null;
              if (widget.onTypingChanged != null) {
                widget.onTypingChanged!(_isTyping);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.chatInputBarColor,
                        borderRadius: _isTyping
                            ? BorderRadius.circular(15)
                            : AppBorderAndRadius.chatInputFieldBorderRadius,
                      ),
                      child: Column(
                        children: [
                          if (isEditMode)
                            Align(
                              alignment: Alignment.topRight,
                              child: _ExitModeButton(onPressed: exitEditMode),
                            )
                          else if (_isReplying.value != null)
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 23,
                                    right: 23,
                                    top: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: ReplyMessageBuilder(
                                          replyModel: _isReplying.value!,
                                          originMessageTextColor:
                                              originMessageTextColor,
                                          replyInfoTextColor:
                                              originMessageTextColor,
                                          originMessageMaxLines: 3,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                        color: AppColors.dustyGray,
                                        height: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: _ExitModeButton(
                                    onPressed: _cancelReply,
                                  ),
                                ),
                              ],
                            ),
                          child!,
                        ],
                      ),
                    ),
                  ),
                  if (!_isTyping) _optionButtons else _sendButton,
                ],
              );
            },
            child: ChatInputField(
              key: ValueKey('ChatInputField'),
              controller: _inputController,
              focusNode: _focusNode,
              onChanged: _computeIsEditing,
            ),
          ),
          AnimatedPermissionWidget(
            animation: _permissionAnimatedController,
            child: LibraryPermissonWidget(
              controller: _permissionAnimatedController,
              callback: () {
                if (_selectedOptionType == OptionType.file)
                  return _pickFileFromGallery();
                if (_selectedOptionType == OptionType.image)
                  return _pickImageFromGallery();
                _permissionAnimatedController.reverse();
              },
            ),
          ),
          AnimatedBuilder(
            animation: _featureBottomSheetController,
            builder: (_, child) {
              return ClipRRect(
                child: Align(
                  heightFactor: _featureBottomSheetController.value,
                  child: child!,
                ),
              );
            },
            child: featureBottomSheet,
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    Key? key,
    this.onPressed,
    required this.pathToSvgIcon,
  }) : super(key: key);

  final void Function()? onPressed;
  final String pathToSvgIcon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SizedBox(
        height: 24,
        width: 24,
        child: SvgPicture.asset(
          pathToSvgIcon,
          color: context.theme.iconColor,
        ),
      ),
    );
  }
}

class _ExitModeButton extends StatelessWidget {
  const _ExitModeButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.cancel_outlined,
      ),
    );
  }
}

class AnimatedPermissionWidget extends AnimatedWidget {
  AnimatedPermissionWidget({
    required this.animation,
    required this.child,
  }) : super(listenable: animation);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return ClipRRect(
          child: Align(
            heightFactor: animation.value,
            child: child!,
          ),
        );
      },
      child: child,
    );
  }
}

_onPressedCallbackWithPermission(
  BuildContext context, {
  required VoidCallback callBack,
  required AnimationController controller,
  required Permission permission,
}) async {
  if (controller.isCompleted)
    controller.reverse();
  else {
    final status = await permission.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.restricted) {
      controller.forward();
    } else
      callBack.call();
  }
}

class LibraryPermissonWidget extends StatelessWidget {
  const LibraryPermissonWidget({
    Key? key,
    this.controller,
    this.callback,
  }) : super(key: key);

  final AnimationController? controller;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    final Permission permission = PermissionExt.libraryPermission;
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            'Cho phép Chat365 truy cập vào bộ nhớ',
            style: AppTextStyles.regularW500(
              context,
              size: 16,
              lineHeight: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bạn cần cấp quyền truy cập ảnh có thể chia sẻ ảnh từ thư viện và lưu trữ ảnh vào thiết bị',
            textAlign: TextAlign.center,
            style: AppTextStyles.regularW400(
              context,
              size: 14,
              lineHeight: 20,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => SystemUtils.permissionCallback(
              permission,
              callback!,
            ),
            child: Text(
              'CHO PHÉP TRUY CẬP',
            ),
          ),
        ],
      ),
    );
  }
}

enum OptionType {
  image,
  file,
}

extension OptionTypeExt on OptionType {
  Permission get permission {
    switch (this) {
      case OptionType.image:
        return Permission.mediaLibrary;
      case OptionType.file:
        return Permission.mediaLibrary;
    }
  }
}

class VietnameseAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const VietnameseAssetPickerTextDelegate();

  @override
  String get languageCode => 'vi';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy';

  @override
  String get edit => 'Thoát';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Tải thất bại';

  @override
  String get original => 'Origin';

  @override
  String get preview => 'Xem trước';

  @override
  String get select => 'Chọn';

  @override
  String get emptyList => 'Danh sách trống';

  @override
  String get unSupportedAssetType => 'Kiểu tệp không được hỗ trợ';

  @override
  String get unableToAccessAll => 'Không thể truy cập dữ liệu';

  @override
  String get viewingLimitedAssetsTip =>
      'Chỉ hiển thị những tệp phương tiện được phép truy cập bới ứng dụng';

  @override
  String get changeAccessibleLimitedAssets => 'Chọn để cập nhật quyền truy cập';

  @override
  String get accessAllTip =>
      'Ứng dụng đã bị giới hạn truy cập phương tiện. \nVào cài đặt để cho phép ứng dụng truy cập đầy đủ phương tiện trên thiết bị';

  @override
  String get goToSystemSettings => 'Chuyển đến cài đặt';

  @override
  String get accessLimitedAssets => 'Tiếp tục trong khi bị giới hạn';

  @override
  String get accessiblePathName => 'Accessible assets';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Ảnh';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Khác';

  @override
  String get sActionPlayHint => 'play';

  @override
  String get sActionPreviewHint => 'preview';

  @override
  String get sActionSelectHint => 'select';

  @override
  String get sActionSwitchPathLabel => 'switch path';

  @override
  String get sActionUseCameraHint => 'use camera';

  @override
  String get sNameDurationLabel => 'duration';

  @override
  String get sUnitAssetCountLabel => 'count';
}
