import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class DefaultAppButton extends StatelessWidget {
  DefaultAppButton({Key? key,
    required this.text,
    this.isLoading = false,
    required this.textStyle,
    this.isDisabled = false,
    this.width = double.infinity,
    this.height = 50,
    this.background,
    this.onPressed,
    this.border,
    this.textColor = Colors.white,
  }) : super(key: key);

  double width;
  double height;
  Color? background = primaryColor;
  Color? border = Colors.transparent;
  Color textColor;
  Function()? onPressed;
  final String text;
  bool isLoading;
  bool isDisabled;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: background != null ? background : primaryColor,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            width: 1.5,
            color: border != null ? border! : Colors.transparent,
          ),
        ),
        onPressed: isDisabled ? null : isLoading ? null : onPressed,
        child: isLoading ? Center(child: Container(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
              color: Colors.white,
          ),
        )) : Text(
          text,
          style: textStyle.copyWith(color:textColor),
        ),
        disabledColor: Colors.grey,
      ),
    );
  }
}
