import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    Key? key,
    required this.validation,
    required this.controller,
    this.hintText,
    this.secure = false,
    this.isClickable = true,
    this.enableBorders = false,
    this.type,
    this.onChanged,
    this.size,
    this.labelText,
    this.suffix,
    this.suffixPressed,
    this.actionBtn,
    this.onSubmit,
    this.onTape,
    this.prefix,
    this.haveBackground = false,
    this.inputFormatters,
    this.maxLines,
    this.borderColor = primaryColor,
    this.readOnly = false,
    this.focusNode,
  }) : super(key: key);

  final String? Function(String?) validation;
  final TextEditingController controller;
  final TextInputType? type;
  final Icon? prefix;
  final IconData? suffix;
  final String? hintText;
  final Function(String)? onSubmit;
  final void Function()? onTape;
  final bool secure;
  final Function? suffixPressed;
  final bool isClickable;
  final Function(String)? onChanged;
  final TextInputAction? actionBtn;
  final bool enableBorders;
  final bool haveBackground;
  final double? size;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final Color borderColor;
  final int? maxLines;
  final bool readOnly;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (haveBackground && labelText != null) Text(labelText!),
        SizedBox(height: 3),
        Container(
          padding: haveBackground ? EdgeInsets.symmetric(horizontal: 16) : null,
          decoration: haveBackground
              ? BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(13))
              : null,
          child: TextFormField(
            validator: validation,
            cursorColor: primaryColor,
            controller: controller,
            keyboardType: type,
            textInputAction: actionBtn,
            onTap: onTape,
            enabled: isClickable,
            onFieldSubmitted: onSubmit,
            obscureText: secure,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            maxLines: secure ? 1 : maxLines,
            minLines: secure ? null : 1,
            readOnly: readOnly,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: hintText,
              labelText: haveBackground ? null : labelText,
              prefixIcon: prefix,
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38),
              ),
              suffixIcon: suffix != null ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                  size: size,
                ),
              ) : null,
              border: enableBorders
                  ? OutlineInputBorder(
                      borderSide: haveBackground
                          ? BorderSide.none
                          : BorderSide(width: 5.0),
                    )
                  : haveBackground
                      ? UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        )
                      : null,
            ),
          ),
        ),
      ],
    );
  }
}
