import 'package:flutter/material.dart';

import '../../../../utils/constant/color_constants.dart';
import '../../../widget/app_outlined_buttons.dart';

class WriteTab extends StatefulWidget {
  final VoidCallback goToPreviousTab;
  final VoidCallback moveToReadTab;
  const WriteTab({Key? key, required this.goToPreviousTab, required this.moveToReadTab}) : super(key: key);

  @override
  State<WriteTab> createState() => _WriteTabState();
}

class _WriteTabState extends State<WriteTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Share information",
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
                "Write an NFC tag",
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
            "assets/images/write.png",
          ),
          const SizedBox(height: 25,),
          const Padding(
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: Column(
              children: [
                Text(
                  "Go to the Write Data tab for write data to your NFC tag",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                SizedBox(height: 25,),
                Text("The available records are standard and allow your NFC tag to be readable by everyone",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                          "Close"
                      ),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      onPressed: widget.moveToReadTab,
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
