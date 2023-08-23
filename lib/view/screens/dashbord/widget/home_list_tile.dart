import 'package:flutter/material.dart';

class HomeListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData iconData; // Add this line
  final VoidCallback onPressed;

  const HomeListTile({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.iconData, // Add this line
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed,
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 19,
          ),
          leading: Icon(iconData,size: 40,), // Use the provided icon data
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subTitle,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
