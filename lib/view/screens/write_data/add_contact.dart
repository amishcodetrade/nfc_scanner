import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
        title: const Text('Add contact'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          ElevatedButton(
            onPressed: numberData,
            child: const Text("Add Contact"),
          ),
        ],
      ),
    );
  }

  void numberData() {
    String data = dataController.text;
    _writeToNfc(data);
  }

  Future<void> _writeToNfc(String data) async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      NdefMessage message = NdefMessage([
        NdefRecord.createMime('text/plain', Uint8List.fromList(data.codeUnits)),
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
