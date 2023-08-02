import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/gradient_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/contact_service/contact_service.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/screens/suggest_contact_full_list_screen.dart';
import 'package:chat_365/modules/contact/widget/suggest_contact_item.dart';
import 'package:chat_365/utils/data/enums/contact_source.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'all_suggest_contact_screen.dart';

class SuggestContactWidget extends StatefulWidget {
  const SuggestContactWidget({Key? key}) : super(key: key);

  @override
  State<SuggestContactWidget> createState() => _SuggestContactWidgetState();
}

class _SuggestContactWidgetState extends State<SuggestContactWidget> {
  late final SuggestContactCubit suggestContactCubit;

  @override
  void initState() {
    super.initState();
    suggestContactCubit = context.read<SuggestContactCubit>();
  }

  @override
  Widget build(BuildContext context) {
    // final SuggestContactCubit suggestContactCubit;

    return BlocBuilder<SuggestContactCubit, SuggestContactState>(
      builder: (context, state) {
        if (state is SuggestContactSuccess) {
          final List<ApiContact> displayContacts = [];
          for (var item in state.contacts)
            if (displayContacts.length < 5 &&
                (item.friendStatus == FriendStatus.request ||
                    item.friendStatus == FriendStatus.send ||
                    item.friendStatus == FriendStatus.unknown))
              displayContacts.add(item);
          Map<ApiContact, ValueNotifier<bool>> visibles = Map.fromIterable(
            displayContacts,
            value: (element) => ValueNotifier(true),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                ...displayContacts
                    .map(
                      (e) => ValueListenableBuilder<bool>(
                        valueListenable: visibles[e]!,
                        builder: (context, value, child) {
                          return Visibility(
                            visible: value,
                            child: child!,
                          );
                        },
                        child: SuggestContactItem(
                          contact: e,
                          // style2: true,
                          trailing: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              onPressed: () {
                                visibles[e]?.value = false;
                              },
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              constraints:
                                  BoxConstraints.tight(Size.square(16)),
                              icon: SvgPicture.asset(
                                Images.ic_x,
                                color: context.theme.iconColor,
                                height: 14,
                                width: 14,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            e.contactSource.source,
                            style: AppTextStyles.regularW400(
                              context,
                              size: 14,
                              lineHeight: 20,
                            ),
                          ),
                          bottom: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(
                              color: context.theme.dividerDefaultColor,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider.value(
                                value: suggestContactCubit,
                                child: SuggestContactFullListScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Xem thêm',
                        style: AppTextStyles.regularW400(
                          context,
                          size: 16,
                          lineHeight: 21.6,
                        ).copyWith(
                          foreground: Paint()
                            ..shader = context.theme.gradient
                                .createShader(Rect.largest),
                        ),
                      ),
                    ),
                    Divider(
                      color: context.theme.dividerDefaultColor,
                      height: 1,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Dễ dàng tìm kiếm và trò chuyện với bạn bè',
                    style: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      lineHeight: 22,
                    ),
                  ),
                ),
                GradientButton(
                  onPressed: () {
                    if (ContactService().contacts == null)
                      ContactService().getLocalContactWithPermissionRequest(
                        callBack: _navigateCallback,
                      );
                    else
                      _navigateCallback();
                  },
                  gradientColor: context.theme.gradient,
                  shadows: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                      color: AppColors.black.withOpacity(0.25),
                    ),
                  ],
                  child: Text(
                    'TÌM THÊM BẠN',
                    style: AppTextStyles.regularW500(
                      context,
                      size: 16,
                      lineHeight: 22,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  void _navigateCallback() {
    if (ContactService().contacts == null)
      ContactService().getLocalContactWithPermissionRequest();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: suggestContactCubit,
          child: AllSuggestContactScreen(),
        ),
      ),
    );
  }
}
