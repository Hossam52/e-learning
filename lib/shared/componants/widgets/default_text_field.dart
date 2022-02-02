import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  DefaultTextField({Key? key,
    required this.controller,
    required this.hint,
    required this.bgColor,
    this.validator,
    this.suffix,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final Color bgColor;
  final String? Function(String?)? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: TextFormField(
        validator: validator,
        controller: controller,
        textInputAction: TextInputAction.newline,
        maxLines: 10,
        minLines: 1,
        decoration: InputDecoration(
          hintText: hint,
          border:  OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          suffix: suffix,
        ),
      ),
    );
  }
}
