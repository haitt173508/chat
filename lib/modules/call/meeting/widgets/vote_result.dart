import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class VoteResult extends StatefulWidget {
  const VoteResult({Key? key}) : super(key: key);

  @override
  State<VoteResult> createState() => _VoteResultState();
}

class _VoteResultState extends State<VoteResult> {
  late double _width = MediaQuery.of(context).size.width;
  late double _height = MediaQuery.of(context).size.height;
  int voteItemCount = 4;
  int _page = 0;
  var controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: _width,
      padding: AppDimens.paddingHorizontal10,
      child: Column(
        children: [
          Row(
            children: List.generate(
              voteItemCount + 1,
              (index) => Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _page = index;
                      controller.jumpToPage(_page);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    height: 44,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: _page == index
                                    ? AppColors.black50
                                    : AppColors.greyCC))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'aaaaaaaaaaaaaaaaaaaaaaa',
                            style: context
                                .theme.chatConversationDropdownTextStyle
                                .copyWith(
                                    color: _page == index
                                        ? AppColors.black
                                        : AppColors.greyCC),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '10',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(
                                  color: _page == index
                                      ? AppColors.black
                                      : AppColors.greyCC),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (i){
                setState(() {
                  _page=i;
                });
              },
              // physics: const NeverScrollableScrollPhysics(),
              children: List.generate(5, (i) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppPadding.paddingVertical8,
                      child: Text('10/20 Lượt bình chọn'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (_,index)=>ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.orange.withBlue(_page*50),
                          ),
                          title: Padding(
                            padding: AppDimens.paddingHorizontal10,
                            child: Text('Nguyễn Văn Nam'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
