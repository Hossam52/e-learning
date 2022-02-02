import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class TestImageRemoveButton extends StatelessWidget {
  TestImageRemoveButton({
    Key? key,
    required this.onPressed,
    required this.image,
    this.index
  }) : super(key: key);

  final Function() onPressed;
  final Widget image;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image,
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 15,
          child: IconButton(
            color: errorColor,
            padding: EdgeInsets.zero,
            iconSize: 20,
            onPressed: onPressed,
            icon: Icon(Icons.close_rounded),
          ),
        ),
      ],
    );
  }
}
