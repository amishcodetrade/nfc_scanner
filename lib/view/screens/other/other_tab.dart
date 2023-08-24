import 'package:flutter/material.dart';
import 'package:nfc_scanner/utils/constant/color_constants.dart';
import 'package:nfc_scanner/view/screens/other/tabs/overall_tab.dart';
import 'package:nfc_scanner/view/screens/other/tabs/read_tab.dart';
import 'package:nfc_scanner/view/screens/other/tabs/write_tab.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OtherTab extends StatefulWidget {
  final VoidCallback moveToReadTab;
  final VoidCallback moveToWriteTab;

  const OtherTab(
      {Key? key, required this.moveToReadTab, required this.moveToWriteTab})
      : super(key: key);

  @override
  State<OtherTab> createState() => _OtherTabState();
}

class _OtherTabState extends State<OtherTab> {
  final PageController _controller = PageController(initialPage: 0);
  late final List<Widget Function(VoidCallback, VoidCallback)> _pageBuilders;
  final colors = [
    ColorConstants.cardBlueForeground,
    ColorConstants.casesBorderColor,
    ColorConstants.greenColor,
  ];

  @override
  void initState() {
    super.initState();
    _pageBuilders = [
      (goToPreviousTab, nextTab) =>
          OverAllTab(nextTab: nextTab, moveToWriteTab: widget.moveToWriteTab),
      (goToPreviousTab, nextTab) =>
          ReadTab(goToPreviousTab: goToPreviousTab, nextTab: nextTab),
      (goToPreviousTab, nextTab) => WriteTab(
            goToPreviousTab: goToPreviousTab,
            moveToReadTab: widget.moveToReadTab,
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pageBuilders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _pageBuilders[index](goToPreviousTab, () {
                      if (index < _pageBuilders.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    });
                  },
                ),
              ),
              Container(
                color: ColorConstants.primaryColor,
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: _pageBuilders.length,
                    effect: CustomizableEffect(
                      activeDotDecoration: DotDecoration(
                        width: 32,
                        height: 12,
                        color: Colors.indigo,
                        rotationAngle: 180,
                        verticalOffset: -10,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      dotDecoration: DotDecoration(
                        width: 24,
                        height: 12,
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                        verticalOffset: 0,
                      ),
                      spacing: 6.0,
                      activeColorOverride: (i) => colors[i],
                      inActiveColorOverride: (i) => colors[i],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToPreviousTab() {
    if (_controller.page != null && _controller.page! > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
