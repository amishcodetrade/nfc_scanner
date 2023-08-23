import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_scanner/utils/constant/color_constants.dart';

import '../../widget/app_outlined_buttons.dart';
import '../../widget/outlined_text_form_field.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
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
        title: const Text('Add Url'),
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
                    Icons.phone_in_talk_sharp,
                    color: ColorConstants.whiteColor,
                    size: 35,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "Enter your Phone Number ",
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
                    hintText: '0123456789',
                    verticalPadding: 10,
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppOutlinedIconButton(
                            height: 40,
                            width: MediaQuery.of(context).size.width ,
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
                            onPressed: numberData,
                            outlineColor: ColorConstants.casesBorderColor,
                            child: const Text("Add Contact"),
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
  void numberData() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      String data = dataController.text;
      NdefMessage message = NdefMessage([
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList(data.codeUnits)),
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
      debugPrint("Written number: $text");
      NfcManager.instance.stopSession();
    });
  }
}
