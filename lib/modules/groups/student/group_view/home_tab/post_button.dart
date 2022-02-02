import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostButton extends StatelessWidget {
  PostButton({
    Key? key,
    required this.svg,
    required this.text,
    required this.onPressed,
    required this.isLiked,
  }) : super(key: key);

  final Function() onPressed;
  final String svg;
  final String text;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isLiked ? primaryColor : null,
      child: MaterialButton(
        onPressed: onPressed,
        textColor: Colors.grey,
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svg,
              width: 27,
              color: isLiked ? Colors.white : primaryColor,
            ),
            SizedBox(width: 12),
            Text(
              text,
              style: thirdTextStyle(null).copyWith(
                  color: isLiked ? Colors.white : primaryColor,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
