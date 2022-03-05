import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultLoader extends StatelessWidget {
  const DefaultLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/images/lottie/default-loader.json',
        width: 220,
        height: 220,
      ),
    );
  }
}
