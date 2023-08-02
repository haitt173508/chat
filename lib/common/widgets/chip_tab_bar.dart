import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class ChipTabBar<T> extends StatefulWidget {
  const ChipTabBar({
    Key? key,
    required this.tabs,
    required this.tabController,
    required this.name,
    this.counts,
  }) : super(key: key);

  final List<T> tabs;
  final TabController tabController;
  final String Function(T) name;
  final List<ValueNotifier<int>>? counts;

  @override
  State<ChipTabBar<T>> createState() => _ChipTabBarState<T>();
}

class _ChipTabBarState<T> extends State<ChipTabBar<T>> {
  late final ValueNotifier<T> _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = ValueNotifier(widget.tabs[_tabController.index]);
    _tabController.addListener(_listener);
  }

  TabController get _tabController => widget.tabController;

  _listener() => _selectedValue.value = widget.tabs[_tabController.index];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: widget.tabController,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        labelColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        unselectedLabelColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.asMap().entries.map((e) {
          var count = widget.counts?[e.key];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimatedBuilder(
                animation: Listenable.merge([_selectedValue, count]),
                builder: (context, _) {
                  final bool isSelected = _selectedValue.value == e.value;
                  return ChoiceChip(
                    selected: isSelected,
                    label: Text(
                        '${widget.name(e.value)} (${count?.value.clamp(0, double.infinity) ?? ''})'),
                    selectedColor: AppColors.grayDCDCDC,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: BorderSide(color: AppColors.grayDCDCDC),
                    labelStyle: AppTextStyles.regularW400(
                      context,
                      size: 14,
                      lineHeight: 16,
                      color: AppColors.black,
                    ),
                    // onSelected: (value) {
                    //   if (value) _selectedChoiceChip.value = e;
                    // },
                  );
                }),
          );
        }).toList(),
      ),
    );
  }
}
