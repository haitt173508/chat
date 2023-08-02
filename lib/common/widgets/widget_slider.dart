import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WidgetSlider extends StatefulWidget {
  const WidgetSlider({
    Key? key,
    required this.images,
    this.tabBarImages,
    this.initIndex = -1,
    // this.onDownload,
    // this.onForward,
  }) : super(key: key);

  final List<Widget> images;
  final List<Widget>? tabBarImages;
  final int initIndex;

  /// Callback khi chọn nút Option trên AppBar
  ///
  /// [index] => index hiện tại của [TabController]
  // final ValueChanged<int>? onDownload;
  // final ValueChanged<int>? onForward;

  @override
  State<WidgetSlider> createState() => WidgetSliderState();
}

class WidgetSliderState extends State<WidgetSlider>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  ScrollPhysics _scrollPhysics = const AlwaysScrollableScrollPhysics();
  late final List<Widget> _tabBarWidgets;

  changePhysics(ScrollPhysics scrollPhysics) {
    setState(() => _scrollPhysics = scrollPhysics);
  }

  bool get isScrollable => _scrollPhysics is! NeverScrollableScrollPhysics;

  int get tabIndex => _tabController.index;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.images.length,
      vsync: this,
      initialIndex: widget.initIndex != -1 ? widget.initIndex : 0,
    );
    _tabBarWidgets = widget.tabBarImages ?? widget.images;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: TabBarView(
              children: widget.images,
              controller: _tabController,
              physics: _scrollPhysics,
            ),
          ),
        ),
        TabBar(
          tabs: _tabBarWidgets
              .asMap()
              .keys
              .map(
                (e) => Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(4),
                  child: widget.images[e],
                ),
              )
              .toList(),
          controller: _tabController,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppColors.white,
                width: 2,
              )),
          labelPadding: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 5),
          indicatorColor: Colors.transparent,
          isScrollable: true,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
