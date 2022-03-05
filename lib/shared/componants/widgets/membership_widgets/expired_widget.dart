import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpiredWidget extends StatelessWidget {
  const ExpiredWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_rounded, size: 60),
          SizedBox(height: 15),
          Text(text.you_reached_limit),
        ],
      ),
    );
  }
}
