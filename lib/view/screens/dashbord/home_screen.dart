import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../../../utils/constant/color_constants.dart';
import '../../widget/custom_tab_bar.dart';
import '../other/other_tab.dart';
import '../read_data/read_nfc_data.dart';
import '../write_data/write_nfc_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> selectedTab = ValueNotifier(0);
  late final List<Widget> widgetList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    widgetList = [ const ReadData(),
      const WriteData(),
      OtherTab(moveToReadTab: moveToReadTab, moveToWriteTab: moveToWriteTab),
    ];
    _checkNfcAvailability();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Scanner',style: TextStyle(color: ColorConstants.blackColor),),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryColor,
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: const [
        //     Tab(text: 'Read Data'),
        //     Tab(text: 'Write Data'),
        //     Tab(text: 'Other'),
        //   ],
        // ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 0.2,
            child: CustomTabBar(
              tabController: _tabController,
              selectedTab: selectedTab,
              tabList: const [
                Text("Read Data"),
                Text("Write Data"),
                Text("Other"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: selectedTab,
              builder: (context, value, _) =>
              widgetList[selectedTab.value],
            ),
          )
        ],
      ),
    );
  }

  void moveToReadTab() {
    _tabController.animateTo(0);
    selectedTab.value = 0;
  }

  void moveToWriteTab() {
    _tabController.animateTo(1);
    selectedTab.value = 1;
  }

  Future<void> _checkNfcAvailability() async {
    final isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      bool isNfcEnabled = false;
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enable NFC'),
            content: const Text(
                'Please first enable NFC in your device settings'),
            actions: [
              TextButton(
                onPressed: () async {
                  var isNfcOn = await NfcManager.instance.isAvailable();
                  if (isNfcOn) {
                    isNfcEnabled = true;
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    isNfcEnabled = false;
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ).then((_) {
        if (!isNfcEnabled) {
          _checkNfcAvailability(); // Show the dialog again if the NFC is still not enabled
        }
      });
    }
  }

}
