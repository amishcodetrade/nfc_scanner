import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        title: const Text('Add Text',
            style: TextStyle(color: ColorConstants.blackColor)),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstants.blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Enter your Text ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
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
  Future<void> textData() async {
    if (dataController.text.isNotEmpty) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        try {
          NdefMessage message =
              NdefMessage([NdefRecord.createText(dataController.text)]);
          await Ndef.from(tag)?.write(message);
          Fluttertoast.showToast(msg: 'Data emitted successfully');
          Uint8List payload = message.records.first.payload;
          String text = String.fromCharCodes(payload);
          debugPrint("Written data: $text");
          NfcManager.instance.stopSession();
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error emitting NFC data: $e');
        }
      });
    } else {
      Fluttertoast.showToast(msg: 'Please enter data to emit');
    }
  }
}
