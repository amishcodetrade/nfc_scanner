import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../other/other_tab.dart';
import '../read_data/read_nfc_data.dart';
import '../write_data/write_nfc_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
        title: const Text('NFC Scanner'),
        elevation: 15,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Read Data'),
            Tab(text: 'Write Data'),
            Tab(text: 'Other'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const ReadData(),
          const WriteData(),
          OtherTab(moveToReadTab: moveToReadTab,moveToWriteTab: moveToWriteTab),
        ],
      ),
    );
  }
  void moveToReadTab() {
    _tabController.animateTo(0);
  }
  void moveToWriteTab() {
    _tabController.animateTo(1);
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
            content: const Text('Please first enable NFC in your device settings'),
            actions: [
              TextButton(
                onPressed: () async{
                  var isNfcOn = await NfcManager.instance.isAvailable();
                  if(isNfcOn) {
                    isNfcEnabled = true;
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }else{
                    isNfcEnabled = false;
                  }
                  _checkNfcAvailability();
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
