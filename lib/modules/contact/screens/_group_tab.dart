import 'dart:async';
import 'dart:io';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/custom_refresh_indicator.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
import 'package:chat_365/modules/contact/widget/text_header.dart';
import 'package:chat_365/modules/new_conversation/conversation_creation_repo.dart';
import 'package:chat_365/modules/new_conversation/create_conversation_cubit/create_conversation_cubit.dart';
import 'package:chat_365/modules/new_conversation/models/group_conversation_creation_kind.dart';
import 'package:chat_365/modules/search/screens/search_contact_screen.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'schedule_reminder_screen.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({Key? key}) : super(key: key);

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab>
    with AutomaticKeepAliveClientMixin {
  late final ContactListCubit _contactListCubit;
  final double kBottomHeight = 135 + 25;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    var userInfo = context.userInfo();
    _contactListCubit = ContactListCubit(
      ContactListRepo(
        userInfo.id,
        companyId: userInfo.companyId ?? 0,
      ),
      initFilter: FilterContactsBy.conversations,
      searchGroupConversationOnly: true,
    );
    _scrollController.addListener(_listener);
  }

  _listener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _timer?.cancel();
      });
    }
  }

  Widget _buildFeatureButton(
    String assetPath,
    String label,
    Color color, {
    VoidCallback? onPressed,
  }) =>
      Padding(
        padding: const EdgeInsets.only(right: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: onPressed,
              child: Ink(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: context.theme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  assetPath,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.regularW400(
                context,
                size: 13,
                lineHeight: 15,
              ),
            ),
          ],
        ),
      );

  Widget _features() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: context.theme.messageBoxColor, thickness: 8, height: 8),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextHeader(
            text: 'Tính năng nổi bật',
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: [
              // _buildFeatureButton(
              //   Images.ic_calendar,
              //   'Lịch',
              //   AppColors.primary,
              //   onPressed: () {},
              // ),
              _buildFeatureButton(
                Images.ic_alarm_clock,
                'Nhắc hẹn',
                AppColors.red,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SheduleReminderScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Divider(
          color: context.theme.messageBoxColor,
          thickness: 8,
          height: 8,
        ),
      ],
    );
  }

  Widget _addGroupButton() {
    return TextButton.icon(
      label: Text(
        'Tạo nhóm mới',
        style: AppTextStyles.regularW400(
          context,
          size: 16,
          lineHeight: 18.75,
          // color: context.theme.primaryColor,
        ),
      ),
      icon: CircleAvatar(
        radius: 40 / 2,
        backgroundColor: AppColors.primary.withOpacity(0.3),
        child: SvgPicture.asset(
          Images.ic_fluent_people_add,
          color: AppColors.primary,
          height: 26,
          width: 26,
        ),
      ),
      style: TextButton.styleFrom(alignment: Alignment.centerLeft),
      onPressed: () {
        var cubit = CreateConversationCubit(
          repo: ConversationCreationRepo(),
        );
        AppRouter.toPage(
          context,
          AppPages.NewConversation_CreateGroup,
          blocValue: cubit,
          arguments: {
            'type': GroupConversationCreationKind.public,
            // 'chatMessagesRepo': context.read<ChatMessagesRepo>(),
            // 'userNameRepo': context.read<UserNameRepo>(),
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var countGroup = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: BlocBuilder<ContactListCubit, ContactListState>(
        builder: (context, state) {
          String count = '...';
          if (state is LoadSuccessState)
            count = state.contactList.length.toString();
          else if (state is LoadingState)
            count = '...';
          else if (state is LoadFailedState) count = '';
          return TextHeader(
            text: 'Nhóm đang tham gia $count',
          );
        },
      ),
    );
    return BlocProvider.value(
      value: _contactListCubit,
      child: CustomRefreshIndicator(
        notificationPredicate: (notification) {
          bool depth;
          // if (Platform.isIOS) {
          //   depth = notification.depth == 3;
          // } else
          //   depth = notification.depth == 2;

          if (Platform.isIOS) {
            depth = notification.depth == 2;
          } else
            depth = notification.depth == 1;
          return depth && _timer?.isActive == false;
        },
        edgeOffset: 46,
        displacement: 20,
        onRefresh: () async => _contactListCubit.loadContact(),
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              collapsedHeight: 0,
              toolbarHeight: 0,
              expandedHeight: kBottomHeight + 56 + 56,
              pinned: true,
              floating: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                centerTitle: false,
                stretchModes: [],
                background: Padding(
                  padding: EdgeInsets.only(bottom: kBottomHeight, top: 46),
                  child: _addGroupButton(),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kBottomHeight),
                child: Container(
                  height: kBottomHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _features()),
                      countGroup,
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: BlocConsumer<ContactListCubit, ContactListState>(
            buildWhen: (previous, current) =>
                current is LoadSuccessState || current is LoadingState,
            listener: (_, state) {
              Fluttertoast.cancel();
              if (state is LoadFailedState) AppDialogs.toast(state.message);
            },
            builder: (context, state) {
              final List<ConversationBasicInfo> list = [];
              if (state is LoadSuccessState) list.addAll(state.contactList);
              return ListView.separated(
                itemCount: list.length,
                physics: const AlwaysScrollableScrollPhysics(),
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                padding: EdgeInsets.symmetric(horizontal: 15),
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  var item = list[index];
                  return GroupConversationItemBuilder(
                    info: item,
                    avatarSize: 50,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
