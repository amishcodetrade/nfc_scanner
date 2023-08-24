import 'package:flutter/material.dart';

import '../../utils/constant/color_constants.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final ValueNotifier selectedTab;
  final List<Widget> tabList;
  final bool isScrollable, isDecoration;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.selectedTab,
    required this.tabList,
    this.isScrollable = true,
    this.isDecoration = false,
  });

  @override
  DecoratedBox build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          border: isDecoration
              ? const Border(
                  bottom: BorderSide(
                      color: ColorConstants.casesBorderColor, width: 0.5),
                )
              : null,
        ),
        child: TabBar(
          onTap: (int index) => selectedTab.value = index,
          isScrollable: isScrollable,
          unselectedLabelColor: ColorConstants.unselectedLabelColor,
          labelStyle: Theme.of(context).textTheme.titleSmall,
          indicator: BoxDecoration(
            border: const Border(
              bottom: BorderSide(
                color: ColorConstants.casesBorderColor,
                width: 1.5,
              ),
            ),
            gradient: LinearGradient(
              colors: [
                ColorConstants.lightPrimaryColor,
                ColorConstants.lightPrimaryColor
              ],
            ),
          ),
          controller: tabController,
          dividerColor: ColorConstants.redColor,
          labelColor: ColorConstants.casesBorderColor,
          tabs: List.generate(
            tabList.length,
            (index) => Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.25,
              alignment: Alignment.center,
              child: tabList[index],
            ),
          ),
        ),
      );
}
