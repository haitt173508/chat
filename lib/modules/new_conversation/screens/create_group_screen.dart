import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/border_button.dart';
import 'package:chat_365/common/widgets/custom_scaffold.dart';
import 'package:chat_365/common/widgets/text_field_theme.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/modules/new_conversation/create_conversation_cubit/create_conversation_cubit.dart';
import 'package:chat_365/modules/new_conversation/create_conversation_cubit/create_conversation_state.dart';
import 'package:chat_365/modules/new_conversation/models/group_conversation_creation_kind.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'select_contact_view.dart';

extension on GroupConversationCreationKind {
  String get title {
    switch (this) {
      case GroupConversationCreationKind.public:
        return StringConst.createNewGroupConversation;
      case GroupConversationCreationKind.needModeration:
        return StringConst.createNewBrowseGroup;
    }
  }
}

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({
    Key? key,
    required this.conversationType,
    this.userInfo,
    this.setGroupName = true,
  }) : super(key: key);

  final GroupConversationCreationKind conversationType;
  final IUserInfo? userInfo;
  final bool setGroupName;

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late final PageController _controller;
  late final ChatBloc _chatBloc;

  late int currentPage;
  late final CreateConversationCubit _createConversationCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _chatBloc = context.read<ChatBloc>();
    _createConversationCubit = context.read<CreateConversationCubit>();
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateConversationCubit, CreateConversationState>(
      listener: (_, state) {
        AppRouter.removeAllDialog(context);
        if (state is ConversationCreationSuccess) {
          _chatBloc.tryToChatScreen(
            chatInfo: state.model.conversationBasicInfo,
            isGroup: true,
            isNeedToFetchChatInfo:
                state.model.conversationBasicInfo.name.isEmpty,
          );
          context
              .read<ChatConversationBloc>()
              .add(ChatConversationEventAddData([state.model]));
        } else if (state is ConversationCreationInProgress) {
          AppDialogs.showLoadingCircle(context);
        } else if (state is ConversationCreationFailure) {
          AppDialogs.toast(state.message);
        }
      },
      child: CustomScaffold(
        title: widget.conversationType.title,
        backBtnPressedHandler: () {
          if (currentPage == 0) {
            AppRouter.back(context);
          } else {
            _controller.previousPage(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
            );
          }
        },
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          controller: _controller,
          itemCount: widget.setGroupName ? 2 : 1,
          itemBuilder: (_, int index) {
            if (index == 0 && widget.setGroupName)
              return _InputInfo(
                formKey: _formKey,
              );

            return SelectContactView(
              userInfo: widget.userInfo,
              onChanged: (value) =>
                  _createConversationCubit.selectedContacts = [...value],
            );
          },
          onPageChanged: (val) => setState(() => currentPage = val),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            RoundedButton(
              label: currentPage == 0 ? StringConst.cont : StringConst.done,
              fillStyle: true,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              onPressed: () {
                if (currentPage == 0 && widget.setGroupName) {
                  if (_formKey.currentState!.validate())
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                    );
                } else {
                  _createConversationCubit.createGroup(
                    widget.conversationType,
                  );
                }
              },
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class _InputInfo extends StatelessWidget {
  const _InputInfo({
    Key? key,
    this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.gray,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(Images.ic_camera),
            ),
          ),
          SizedBox(height: 35),
          CustomTextFieldTheme(
            keyText: formKey,
            isTitle: false,
            // validator: (value) =>
            //     Validator.validateStringBlank(value, ' tên nhóm'),
            hintText: StringConst.groupName,
            isShowIcon: true,
            iconSuffix: Images.ic_pencil,
            onChanged: (val) {
              context.read<CreateConversationCubit>().model.name.value = val;
            },
          ),
        ],
      ),
    );
  }
}
