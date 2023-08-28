import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constant/color_constants.dart';

class ReadData extends StatefulWidget {
  const ReadData({Key? key}) : super(key: key);

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  ValueNotifier<List<List<int>>> identifierNotifier = ValueNotifier([]);
  ValueNotifier<List<List<int>>> payloadNotifier = ValueNotifier([]);
  ValueNotifier<List<String>> userDetailsNotifier = ValueNotifier([]);
  @override
  void initState() {
    super.initState();
    _loadData();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder(
      valueListenable: identifierNotifier,
      builder: (context, value, child) => Center(
        child: identifierNotifier.value.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.nfc,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Approach an NFC Tag",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.63,
                    height: 2.5,
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    color: ColorConstants.greyColor,
                  ),
                  const Text(
                    "Welcome to NFC Scanner",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.63,
                    height: 2.5,
                    margin: const EdgeInsets.only(top: 15, bottom: 5),
                    color: ColorConstants.greyColor,
                  ),
                ],
              )
            : ListView.builder(
                itemCount: identifierNotifier.value.length,
                itemBuilder: (context, index) {
                  List<int> identifier = identifierNotifier.value[index];
                  String serialNumberHex = convertToSerialNumber(identifier);
                  List<int> payload = payloadNotifier.value[index];
                  String payloadString =
                      payload.map((byte) => String.fromCharCode(byte)).join('');
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          subtitle: Text(
                              "Other Information : ${userDetailsNotifier.value[index]}"),
                          title: Column(
                            children: [
                              Text("payload : $payloadString"),
                              Text(
                                'Serial Number : $serialNumberHex',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    ));
  }

  initial(){
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      bool serviceEnabled;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: 'please keep your location on');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: 'location permission denied forever');
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Fluttertoast.showToast(msg: 'Lat: ${position.latitude}, Long: ${position.longitude}');
      userDetailsNotifier.value.add(tag.data.toString());
      debugPrint(tag.data.toString());
      List<int> identifier = extractIdentifier(tag.data.toString());
      identifierNotifier.value.add(identifier);
      List<int> payload = extractPayload(tag.data.toString());
      payloadNotifier.value.add(payload);
      debugPrint("payload  $payloadNotifier");
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      identifierNotifier.notifyListeners();
      _saveData();
    });
  }

  List<int> extractPayload(String tagData) {
    final payloadStartIndex = tagData.indexOf("payload: [");

    // Check if payload data is found
    if (payloadStartIndex ==   -1) {
      return []; // Payload data not available
    }

    final payloadStart = payloadStartIndex + "payload: [".length;
    final payloadEndIndex = tagData.indexOf("]", payloadStart);

    // Check if payloadEndIndex is valid
    if (payloadEndIndex == -1) {
      return []; // Payload data not available
    }

    final payloadString = tagData.substring(payloadStart, payloadEndIndex);

    List<int> payloadBytes = payloadString.split(', ').map(int.parse).toList();
    return payloadBytes;
  }

  List<int> extractIdentifier(String tagData) {
    final identifierString = tagData.substring(
        tagData.indexOf("identifier: [") + 13,
        tagData.indexOf("]", tagData.indexOf("identifier: [") + 13));
    return identifierString.split(', ').map(int.parse).toList();
  }

  String convertToSerialNumber(List<int> identifierBytes) {
    final serialNumberHex = identifierBytes
        .map((byte) => byte.toRadixString(16).toUpperCase().padLeft(2, '0'))
        .join(':');
    return serialNumberHex.isNotEmpty
        ? serialNumberHex
        : "Serial Number not available";
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> identifiersStringList =
        prefs.getStringList('identifiers') ?? [];
    List<String> payloadStringList = prefs.getStringList('payload') ?? [];
    List<String> userDetailsList = prefs.getStringList('userDetails') ?? [];

    List<List<int>> loadedIdentifiers = identifiersStringList.map((list) {
      return list.split(', ').map((string) => int.parse(string)).toList();
    }).toList();

    List<List<int>> loadedPayloads = payloadStringList.map((list) {
      if (list.isEmpty) {
        return [0];
      }
      return list.split(', ').map((string) => int.parse(string)).toList();
    }).toList();

    setState(() {
      identifierNotifier.value = loadedIdentifiers;
      userDetailsNotifier.value = userDetailsList;
      payloadNotifier.value = loadedPayloads;
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> identifiersStringList = identifierNotifier.value.map((list) {
      return list.map((intVal) => intVal.toString()).join(', ');
    }).toList();

    List<String> payloadStringList = payloadNotifier.value.map((list) {
      if (list.isEmpty) {
        return ''; // Use an empty string for empty payload lists
      }
      return list.map((intVal) => intVal.toString()).join(', ');
    }).toList();

    prefs.setStringList('identifiers', identifiersStringList);
    prefs.setStringList('payload', payloadStringList);
    prefs.setStringList('userDetails', userDetailsNotifier.value);
  }
}
