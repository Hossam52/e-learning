import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultAppSearchField extends StatelessWidget {
  DefaultAppSearchField({Key? key,
    required this.controller,
    required this.onChanged,
    this.padding = 16.0,
  }) : super(key: key);

  final TextEditingController controller;
  final double padding;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.newline,
                maxLines: 3,
                minLines: 1,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: text!.search,
                  border:  OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Icon(
              CupertinoIcons.search,
              color: Colors.grey,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
