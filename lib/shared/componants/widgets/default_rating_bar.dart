import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DefaultRatingBar extends StatelessWidget {
  const DefaultRatingBar({
    Key? key,
    required this.rate,
    this.itemSize = 18,
  }) : super(key: key);

  final double rate;
  final double itemSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RatingBar.builder(
          initialRating: rate,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: itemSize,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        SizedBox(width: 3),
        Text(
          '($rate)',
          style: subTextStyle(null).copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
