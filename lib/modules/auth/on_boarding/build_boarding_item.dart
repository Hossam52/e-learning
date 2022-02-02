import 'package:e_learning/models/onboarding_model.dart';
import 'package:flutter/material.dart';

class BuildBoardingItem extends StatelessWidget {

  BuildBoardingItem({
    required this.model,
  });

  final BoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 250,
            child: Image(
              image: AssetImage('${model.image}'),
            ),
          ),
          SizedBox(height: 60),
          Text(
            '${model.title}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          // SizedBox(height: 50),
        ],
      ),
    );
  }
}
