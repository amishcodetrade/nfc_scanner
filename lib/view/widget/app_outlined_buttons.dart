import 'package:flutter/material.dart';

import '../../utils/constant/color_constants.dart';

class AppOutlinedButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final double width, height;
  final Color outlineColor;

  const AppOutlinedButton(
    this.child, {
    super.key,
    required this.onPressed,
    this.outlineColor = ColorConstants.casesBorderColor,
    this.width = double.infinity,
    this.height = 35,
  });

  @override
  OutlinedButton build(BuildContext context) => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          maximumSize: Size(width, height),
          minimumSize: Size(width, height),
          side: BorderSide(color: outlineColor, width: 1),
          foregroundColor: outlineColor,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: child,
      );
}
class AppOutlinedIconButton extends StatelessWidget {
  final Widget child, icon;
  final void Function() onPressed;
  final double width, height;
  final Color outlineColor;

  const AppOutlinedIconButton({
    super.key,
    required this.child,
    required this.icon,
    required this.onPressed,
    this.outlineColor = ColorConstants.redColor,
    this.width = 50,
    this.height = 35,
  });

  @override
  OutlinedButton build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      maximumSize: Size(width, height),
      minimumSize: Size(width, height),
      side: BorderSide(color: outlineColor, width: 1),
      foregroundColor: outlineColor,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    icon: icon,
    label: child,
  );
}