import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentStar extends StatelessWidget {
  const StudentStar({Key? key, this.width = 25.0}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      child: SvgPicture.asset('assets/images/icons/star.svg'),
    );
  }
}
