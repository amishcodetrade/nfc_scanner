import 'package:flutter/material.dart';

import '../../utils/constant/color_constants.dart';

class OutlinedTextFormField extends StatelessWidget {
  final bool isGovId, isEmail, isNumeric, isRequired, isMobile;
  final GlobalKey<FormFieldState>? textFieldKey;
  final double verticalPadding, horizontalPadding;
  final TextEditingController controller;
  final String hintText, errorText;
  final String? labelText;
  final TextStyle hintStyle, labelStyle;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final Widget prefix, suffix;
  final int? maxLength;
  final int minLines, maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final AutovalidateMode? autoValidateMode;
  final void Function()? onTap;
  final String? Function(String? val)? validator;
  final TextCapitalization textCapitalization;

  const OutlinedTextFormField({
    super.key,
    required this.controller,
    this.isRequired = true,
    this.isMobile = false,
    this.textFieldKey,
    this.isGovId = false,
    this.isEmail = false,
    this.isNumeric = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.hintText = "",
    this.autoValidateMode = AutovalidateMode.disabled,
    this.hintStyle = const TextStyle(fontWeight: FontWeight.normal),
    this.errorText = "Please enter a value",
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.prefix = const SizedBox(),
    this.suffix = const SizedBox(),
    this.validator,
    this.onTap,
    this.horizontalPadding = 8,
    this.verticalPadding = 8,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.labelText,
    this.labelStyle = const TextStyle(color: ColorConstants.primaryColor),
  });

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: ColorConstants.lightGreyColor,
        width: 1,
      ),
    );

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: TextFormField(
        key: textFieldKey,
        readOnly: onTap != null,
        onChanged: onChanged,
        controller: controller,
        onTap: onTap,
        maxLines: maxLines,
        minLines: minLines,
        autovalidateMode: autoValidateMode,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          hintText: hintText,
          hintStyle: hintStyle ,
          labelText: labelText,
          labelStyle: labelStyle,
          prefixIcon: prefix is SizedBox
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, end: 5),
                  child: prefix,
                ),
          suffixIcon: suffix is SizedBox
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: suffix,
                ),
          prefixIconConstraints: const BoxConstraints(
            maxWidth: 35,
            minHeight: 40,
          ),
          suffixIconConstraints: const BoxConstraints(
            maxWidth: 35,
            minHeight: 40,
          ),
        ),
        keyboardType: textInputType,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        onSaved: (val) => controller.text = val!,
      ),
    );
  }
}
