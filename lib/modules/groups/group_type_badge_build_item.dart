import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupTypeBadgeBuildItem extends StatelessWidget {
  const GroupTypeBadgeBuildItem({Key? key, required this.isFree}) : super(key: key);

  final bool isFree;
  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Text(
        isFree ? text.public : text.private,
        style: thirdTextStyle(null).copyWith(
          color: Colors.white,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: BoxDecoration(
        color: isFree ? Colors.deepOrange : Color(0xff8A2600),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
