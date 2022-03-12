import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class DefaultProgressButton extends StatelessWidget {
  DefaultProgressButton({
    Key? key,
    required this.buttonState,
    this.onPressed,
    this.borderRadius = 100.0,
    required this.idleText,
    required this.loadingText,
    required this.failText,
    required this.successText,
  }) : super(key: key);

  final ButtonState buttonState;
  Function? onPressed;
  final String idleText;
  final String loadingText;
  final String failText;
  final String successText;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: onPressed == null ? Clip.antiAliasWithSaveLayer : Clip.none,
      decoration: onPressed == null
          ? BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : null,
      child: ProgressButton.icon(
        radius: borderRadius,
        textStyle: thirdTextStyle(null),
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: idleText,
              icon: Icon(
                Icons.send,
                size: 0,
              ),
              color: primaryColor),
          ButtonState.loading:
              IconedButton(text: context.tr.loading, color: primaryColor),
          ButtonState.fail: IconedButton(
              text: failText,
              icon: Icon(Icons.cancel, color: Colors.white),
              color: errorColor),
          ButtonState.success: IconedButton(
              text: successText,
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: successColor)
        },
        onPressed: onPressed,
        state: buttonState,
      ),
    );
  }
}
