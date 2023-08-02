import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditRegionScreen extends StatefulWidget {
  const EditRegionScreen({Key? key}) : super(key: key);

  @override
  State<EditRegionScreen> createState() => _EditRegionScreenState();
}

class _EditRegionScreenState extends State<EditRegionScreen> {
  List region = [
    'Ấn Độ',
    'Áo',
    'Ả Rập Xê Út',
    'Afghanistan',
    'Bỉ',
    'Ba Lan',
    'Việt Nam',
    'Thái Lan',
  ];

  late List<bool> regionTick = [];

  late List<List<String>> regionSort = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < alphabet.length; i++) {
      regionSort.add([]);
    }
    for (int i = 0; i < region.length; i++) {
      regionTick.add(false);
      switch (region[i][0].toString().toLowerCase()) {
        case 'a':
        case 'á':
        case 'à':
        case 'ả':
        case 'ã':
        case 'ạ':
          regionSort[0].add(region[i]);
          break;
        case 'ă':
        case 'ắ':
        case 'ằ':
        case 'ẳ':
        case 'ẵ':
        case 'ặ':
          regionSort[1].add(region[i]);
          break;
        case 'â':
        case 'ấ':
        case 'ầ':
        case 'ẩ':
        case 'ẫ':
        case 'ậ':
          regionSort[2].add(region[i]);
          break;
        case 'b':
          regionSort[3].add(region[i]);
          break;
        case 'c':
          regionSort[4].add(region[i]);
          break;
        case 'd':
          regionSort[5].add(region[i]);
          break;
        case 'đ':
          regionSort[6].add(region[i]);
          break;
        case 'e':
        case 'é':
        case 'ẻ':
        case 'è':
        case 'ẹ':
        case 'ẽ':
          regionSort[7].add(region[i]);
          break;
        case 'ê':
        case 'ế':
        case 'ề':
        case 'ể':
        case 'ễ':
        case 'ệ':
          regionSort[8].add(region[i]);
          break;
        case 'f':
          regionSort[9].add(region[i]);
          break;
        case 'g':
          regionSort[10].add(region[i]);
          break;
        case 'h':
          regionSort[11].add(region[i]);
          break;
        case 'i':
        case 'í':
        case 'ỉ':
        case 'ĩ':
        case 'ị':
        case 'ì':
          regionSort[12].add(region[i]);
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(regionTick);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa quốc gia/khu vực'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hoàn thành'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
            padding: AppDimens.paddingHorizontal16,
            shrinkWrap: true,
            children: List.generate(
              alphabet.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppDimens.paddingVertical16,
                    child: Text(
                      alphabet[index],
                      style: context.theme.chatConversationDropdownTextStyle,
                    ),
                  ),
                  Container(
                    height: regionSort[index].length * 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        regionSort[index].length,
                        (i) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                regionTick =
                                    List.filled(regionTick.length, false);
                                regionTick[region
                                    .indexOf(regionSort[index][i])] = true;
                              });
                            },
                            child: Padding(
                              padding: AppPadding.paddingVertical8,
                              child: Row(
                                children: [
                                  regionTick[
                                          region.indexOf(regionSort[index][i])]
                                      ? SvgPicture.asset(
                                          Images.ic_tick,
                                          color: context.theme.iconColor,
                                          width: 30,
                                        )
                                      : SizedBox(width: 30),
                                  Expanded(
                                    child: Text(
                                      regionSort[index][i],
                                      style: context.theme
                                          .chatConversationDropdownTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
