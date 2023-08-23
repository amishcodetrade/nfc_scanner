import 'package:flutter/material.dart';

import '../../../../utils/constant/color_constants.dart';
import '../../../widget/app_outlined_buttons.dart';

class ReadTab extends StatefulWidget {
  final VoidCallback nextTab;
  final VoidCallback goToPreviousTab;

  const ReadTab({Key? key, required this.nextTab, required this.goToPreviousTab}) : super(key: key);

  @override
  State<ReadTab> createState() => _ReadTabState();
}

class _ReadTabState extends State<ReadTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Discover NFC",
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
                "Read an NFC tag",
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
            "assets/images/read.jpg",
          ),
          const SizedBox(height: 25,),
          const Padding(
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Column(
              children: [
                Text(
                  "Go to the Read Data tab of the app and tap your NFC tag under your device",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                SizedBox(height: 25,),
                Text("Then NFC Tool shows you all the technical information of your NFC chip and data it contains",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                      const Text("Back"),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      onPressed: widget.goToPreviousTab,
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
