  import 'package:flutter/material.dart';
  import 'package:nfc_scanner/view/screens/write_data/add_contact.dart';
  import 'package:nfc_scanner/view/screens/write_data/add_url.dart';
  import '../dashbord/widget/home_list_tile.dart';
  import 'add_text.dart';

  class WriteData extends StatelessWidget {
    const WriteData({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: ListView(
          children: [
            HomeListTile(
                title: "Text",
                subTitle: "Add a text record",
                iconData: Icons.book,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddText(),
                      ));
                }),
            HomeListTile(
                title: "URL/URI",
                subTitle: "Add a URI record",
                iconData: Icons.link,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddUrl(),
                      ));
                }),
            HomeListTile(
                title: "Phone number",
                subTitle: "Add a Phone number record",
                iconData: Icons.contacts,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddContact(),
                      ));
                }),
          ],
        ),
      );
    }
  }
