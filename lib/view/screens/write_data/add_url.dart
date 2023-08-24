import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_scanner/utils/constant/color_constants.dart';

import '../../widget/app_outlined_buttons.dart';
import '../../widget/outlined_text_form_field.dart';

class AddUrl extends StatefulWidget {
  const AddUrl({Key? key}) : super(key: key);

  @override
  State<AddUrl> createState() => _AddUrlState();
}

class _AddUrlState extends State<AddUrl> {
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
        title: const Text('Add Url',style: TextStyle(color: ColorConstants.blackColor)),
        backgroundColor: ColorConstants.primaryColor,
        centerTitle: true,
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
                    Icons.link,
                    color: ColorConstants.whiteColor,
                    size: 35,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "Enter your URL ",
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
                    hintText: 'https://flutter.dev',
                    verticalPadding: 10,
                  ),
                  const Spacer(),
                  Row(
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
                            onPressed: urlData,
                            outlineColor: ColorConstants.casesBorderColor,
                            child: const Text("Add Url"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void urlData() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      String data = dataController.text;
      NdefMessage message = NdefMessage([
        NdefRecord.createUri(Uri.parse(data)),
      ]);
      try {
        await ndef?.write(message);
        debugPrint('Success to "Ndef Write"');
        NfcManager.instance.stopSession();
      } catch (e) {
        debugPrint('error $e');
        String? error;
        NfcManager.instance.stopSession(errorMessage: error);
        debugPrint('NfcManager error $error');
        return;
      }
      Uint8List payload = message.records.first.payload;
      String text = String.fromCharCodes(payload);
      debugPrint("Written url: $text");
      NfcManager.instance.stopSession();
    });
  }
}
