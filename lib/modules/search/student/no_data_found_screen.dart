import 'package:flutter/material.dart';

class NoResultFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/14_No Search Results.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}