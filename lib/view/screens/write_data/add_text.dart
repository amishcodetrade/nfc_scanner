import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_scanner/utils/constant/color_constants.dart';

import '../../widget/app_outlined_buttons.dart';
import '../../widget/outlined_text_form_field.dart';

class AddText extends StatefulWidget {
  const AddText({Key? key}) : super(key: key);

  @override
  State<AddText> createState() => _AddTextState();
}

class _AddTextState extends State<AddText> {
  TextEditingController dataController = TextEditingController();

  @override
  void dispose() {
    dataController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Text'),
        elevation: 5,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: ColorConstants.casesBorderColor,
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.book,
                    color: ColorConstants.whiteColor,
                    size: 35,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "Enter your Text ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  OutlinedTextFormField(
                    controller: dataController,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    hintText: 'Hello World! ',
                    verticalPadding: 10,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppOutlinedIconButton(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              icon: const Icon(Icons.cancel, size: 20),
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppOutlinedIconButton(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              icon: const Icon(Icons.verified, size: 20),
                              onPressed: textData,
                              outlineColor: ColorConstants.casesBorderColor,
                              child: const Text("Add Text"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void textData() async{
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      String data = dataController.text;
      NdefMessage message = NdefMessage([NdefRecord.createText(data)]);
      await Ndef.from(tag)?.write(message);
      Uint8List payload = message.records.first.payload;
      String text = String.fromCharCodes(payload);
      debugPrint("Written data: $text");
      NfcManager.instance.stopSession();
    });
  }
}
