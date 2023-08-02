import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/open_url.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListNotifyItem extends StatelessWidget {
  ListNotifyItem({
    Key? key,
    this.avatar,
    this.badge,
    this.title,
    this.subtitle,
    this.time,
    this.checkNotify,
    this.source,
    required String? link,
    this.checkLink,
  })  : _link = getLink(link),
        super(key: key);

  // final InfoLink? infoLink;
  final String _link;

  static String getLink(String? link) {
    if (link != null) {
      return GeneratorService.generate365Link(link);
    }
    return '';
  }

  _onTapLink() async {
    if (_link.contains('www.google.com/maps')) _link.replaceAll('www', '');
    print('link đâu: ${_link}');
    return openUrl(_link);
  }

  final String? avatar;
  final Widget? badge;
  final String? title;
  final String? subtitle;
  final String? time;
  final String? source;
  final String? checkNotify;
  final String? checkLink;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: checkLink!.isNotEmpty ? _onTapLink : () {},
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: 53,
                width: 53,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: avatar!.split('.').last == 'svg'
                      ? SvgPicture.network(
                          avatar!,
                          height: 53,
                          width: 53,
                          placeholderBuilder: (BuildContext context) => const SizedBox(
                            width: 23,
                            height: 23,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: avatar ?? '',
                          height: 53,
                          width: 53,
                          placeholder: (context, url) => const SizedBox(
                            child: CircularProgressIndicator(),
                            width: 23,
                            height: 23,
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                          ),
                        ),
                ),
              ),
              if (checkNotify != 'Timekeeing')
                Positioned(
                  bottom: 0,
                  left: 30,
                  child: Container(
                    height: 23,
                    width: 23,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: checkNotify == 'ChangeSalary'
                          ? AppColors.orange
                          : checkNotify == 'DecilineOffer'
                              ? AppColors.red
                              : checkNotify == 'AcceptOffer'
                                  ? AppColors.lawnGreen
                                  : checkNotify == 'NTD'
                                      ? AppColors.primary
                                      // : checkNotify == 'Timekeeing'
                                      //     ? Colors.transparent
                                      : AppColors.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        checkNotify == 'ChangeSalary'
                            ? Images.ic_notify_money
                            : checkNotify == 'DecilineOffer'
                                ? Images.ic_notify_offer_refuse
                                : checkNotify == 'AcceptOffer'
                                    ? Images.ic_notify_offer
                                    : checkNotify == 'NTD'
                                        ? Images.ic_notify_user
                                        // : checkNotify == 'Timekeeing'
                                        //     ? Images.ic_notify_user
                                        : Images.ic_notify_user,
                        height: 10,
                        width: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBoxExt.w10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source ?? "",
                  style: AppTextStyles.regularW400(context, size: 14),
                ),
                SizedBox(height: 6),
                Text(
                  title ?? "",
                  style: AppTextStyles.regularW500(
                    context,
                    size: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
                // RichText(
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 3,
                //   text: TextSpan(
                //     text: title,
                //     style: AppTextStyles.regularW500(
                //       context,
                //       size: 16,
                //       lineHeight: 14 * 1.2,
                //     ),
                //   ),
                //   // TextSpan(
                //   //   text: '',
                //   //   style: AppTextStyles.regularW400(context, size: 16),
                //   // ),
                // ),
                const SizedBox(height: 6),
                Text(
                  time ?? "",
                  style: AppTextStyles.regularW400(
                    context,
                    size: 12,
                    lineHeight: 15,
                    color: context.theme.isDarkTheme ? AppColors.white : AppColors.doveGray,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
