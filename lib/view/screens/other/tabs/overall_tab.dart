import 'package:flutter/material.dart';
import '../../../../utils/constant/color_constants.dart';
import '../../../widget/app_outlined_buttons.dart';

class OverAllTab extends StatefulWidget {
  final VoidCallback nextTab;
  final VoidCallback moveToWriteTab;
  const OverAllTab({Key? key, required this.nextTab,  required this.moveToWriteTab}) : super(key: key);

  @override
  State<OverAllTab> createState() => _OverAllTabState();
}

class _OverAllTabState extends State<OverAllTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Welcome to NFC Scanner",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: ColorConstants.redColor),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: ColorConstants.casesBorderColor,
            child: const Center(
              child: Text(
                "How does it work ?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            "assets/images/first.png",
          ),
          const SizedBox(height: 25,),
          const Padding(
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Column(
              children: [
                Text(
                    "NFC Scanner is an app which allows you to read and write  task on your NFC tags",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               SizedBox(height: 25,),
                Text("We recommend using NFC tags compatible with your device",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppOutlinedButton(
                      const Text("Skip"),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      onPressed: widget.moveToWriteTab,
                      outlineColor: ColorConstants.redColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppOutlinedButton(
                      const Text(
                        "Next"
                      ),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      onPressed: widget.nextTab,
                      outlineColor: ColorConstants.casesBorderColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
