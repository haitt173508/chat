import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/blocs/chat_library_cubit/cubit/chat_library_cubit.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/file_display.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/enums/choice_dialog_type.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextStyle _style(
  BuildContext context,
) =>
    AppTextStyles.regularW700(
      context,
      size: 14,
      lineHeight: 22,
      color: context.theme.textColor,
    );

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({
    Key? key,
    required this.userInfo,
    required this.libraryCubit,
    this.initMessageType = MessageType.image,
  }) : super(key: key);

  final IUserInfo userInfo;
  final MessageType initMessageType;
  final ChatLibraryCubit libraryCubit;

  static const String userInfoArg = 'userInfoArg';
  static const String initMessageTypeArg = 'initMessageTypeArg';
  static const String libraryCubitArg = 'libraryCubitArg';

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initMessageType.libraryTabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.libraryCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Thư viện',
          ),
          elevation: 1,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TabBar(
                indicatorColor: context.theme.primaryColor,
                controller: _tabController,
                tabs: MessageTypeExt.libraryType
                    .map(
                      (e) => Tab(
                        child: Text(
                          e.libraryTabLabel,
                          style: _style(context),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: MessageTypeExt.libraryType
                    .map(
                      (e) => _TabBarBodyBuilder(
                        messageType: e,
                        itemBuilder: (context, message, prevMessage) =>
                            _LibraryMessageTypeItemBuilder(
                          key: ValueKey(
                            message.files?.first.fullFilePath ??
                                message.infoLink?.link,
                          ),
                          messageModel: message,
                          prevMessageModel: prevMessage,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarBodyBuilder extends StatefulWidget {
  const _TabBarBodyBuilder({
    Key? key,
    required this.messageType,
    required this.itemBuilder,
  }) : super(key: key);

  final MessageType messageType;
  final Widget Function(
    BuildContext,
    SocketSentMessageModel,
    SocketSentMessageModel?,
  ) itemBuilder;

  @override
  State<_TabBarBodyBuilder> createState() => _TabBarBodyBuilderState();
}

class _TabBarBodyBuilderState extends State<_TabBarBodyBuilder> {
  final ScrollController _scrollController = ScrollController();
  late final ChatLibraryCubit _libraryCubit;

  @override
  void initState() {
    super.initState();
    _libraryCubit = context.read<ChatLibraryCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatLibraryCubit, ChatLibraryState>(
      buildWhen: (previous, current) =>
          current is ChatLibraryStateLoadSuccess &&
          (current.messageType == widget.messageType ||
              current.messageType == null),
      builder: (context, state) {
        var messageFiles = _libraryCubit.files[widget.messageType]!;
        return widget.messageType.isImage
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 120,
                ),
                itemBuilder: (_, index) => widget.itemBuilder(
                  _,
                  messageFiles[index],
                  index == 0 ? null : messageFiles[index - 1],
                ),
                controller: _scrollController,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                itemCount: messageFiles.length,
              )
            : ListView.builder(
                itemBuilder: (_, index) => widget.itemBuilder(
                  _,
                  messageFiles[index],
                  index == 0 ? null : messageFiles[index - 1],
                ),
                controller: _scrollController,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                itemCount: messageFiles.length,
                padding: EdgeInsets.symmetric(horizontal: 15),
              );
      },
    );
  }
}

class _LibraryMessageTypeItemBuilder extends StatelessWidget {
  const _LibraryMessageTypeItemBuilder({
    Key? key,
    required this.messageModel,
    this.prevMessageModel,
  }) : super(key: key);

  final SocketSentMessageModel messageModel;
  final SocketSentMessageModel? prevMessageModel;

  MessageType get type => messageModel.type!;

  @override
  Widget build(BuildContext context) {
    final ChatLibraryCubit chatLibraryCubit = context.read<ChatLibraryCubit>();
    late final Widget child;
    VoidCallback? onTap;
    var senderInfo = chatLibraryCubit.conversationDetail.memberList.firstWhere(
      (e) => e.id == messageModel.senderId,
      orElse: () => ChatMemberModel(
        id: messageModel.senderId,
        name: 'Người dùng ${messageModel.senderId}',
        avatar: '',
        unReader: 0,
      ),
    );

    if (type == MessageType.image) {
      onTap = () {
        var imageMessages = chatLibraryCubit.files[MessageType.image]!;
        AppRouterHelper.toImageSlidePage(
          context,
          imageMessages: imageMessages,
          initIndex: imageMessages.indexWhere(
            (e) => e.files!.first == messageModel.files!.first,
          ),
        );
      };

      child = CachedNetworkImage(
        imageUrl: messageModel.files!.first.fullFilePath,
        height: double.infinity,
        width: double.infinity,
        memCacheHeight: 500,
        // memCacheWidth: 500,
        fit: BoxFit.contain,
        placeholder: (_, __) => ShimmerLoading(),
        errorWidget: (_, __, ___) => const SizedBox(),
      );
    } else if (type == MessageType.link) {
      var isSentByCurrentUser = messageModel.senderId == context.userInfo().id;

      onTap = () => SystemUtils.openUrlInBrowser(
            messageModel.infoLink!.fullLink,
          );

      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prevMessageModel == null ||
              prevMessageModel!.createAt.toDmY() !=
                  messageModel.createAt.toDmY())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                messageModel.createAt.diffWith(
                  showSpecialTime: true,
                  showTimeStamp: false,
                ),
                style: AppTextStyles.regularW500(
                  context,
                  size: 16,
                  lineHeight: 22,
                  color: context.theme.isDarkTheme
                      ? AppColors.white
                      : AppColors.black,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayAvatar(
                  isGroup: chatLibraryCubit.conversationDetail.isGroup,
                  model: senderInfo,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${senderInfo.name}, ${messageModel.createAt.toHmString()}',
                        style: context.theme.chatConversationDropdownTextStyle,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? null
                              : context.theme.messageBoxColor,
                          gradient: isSentByCurrentUser
                              ? context.theme.gradient
                              : null,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          messageModel.infoLink?.link ??
                              messageModel.infoLink?.linkHome ??
                              '',
                          style: context.theme.messageTextStyle.copyWith(
                            color: isSentByCurrentUser
                                ? AppColors.white
                                : AppColors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // if (messageModel.type!.isFile) {
    else {
      var senderInfo = chatLibraryCubit.conversationDetail.memberList
          .firstWhere((e) => e.id == messageModel.senderId);

      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prevMessageModel == null ||
              prevMessageModel!.createAt.toDmY() !=
                  messageModel.createAt.toDmY())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                messageModel.createAt.diffWith(
                  showSpecialTime: true,
                  showTimeStamp: false,
                ),
                style: AppTextStyles.regularW500(
                  context,
                  size: 16,
                  lineHeight: 22,
                  color: context.theme.isDarkTheme
                      ? AppColors.white
                      : AppColors.black,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayAvatar(
                  isGroup: chatLibraryCubit.conversationDetail.isGroup,
                  model: senderInfo,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${senderInfo.name}, ${messageModel.createAt.toHmString()}',
                        style: context.theme.chatConversationDropdownTextStyle,
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: FileDisplay(
                          file: messageModel.files!.first,
                          messageId: messageModel.messageId,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      child: child,
      onLongPress: () {
        AppDialogs.showChoicesDialog(
          context,
          choices: [
            if (type.isLink)
              ChoiceDialogTypes.copy(
                context,
                content: messageModel.message,
                text: StringConst.copyUrl,
              )
            else if (type.isImage || type.isFile) ...[
              ChoiceDialogTypes.forward(
                context,
                message: messageModel,
                senderInfo: senderInfo,
              ),
              ChoiceDialogTypes.save(
                context,
                file: messageModel.files!.first,
                messageId: type.isFile ? messageModel.messageId : null,
              ),
            ],
          ],
        );
      },
    );
  }
}
