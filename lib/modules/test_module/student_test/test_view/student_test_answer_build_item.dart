import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class StudentTestAnswerBuildItem extends StatelessWidget {
  StudentTestAnswerBuildItem({
    Key? key,
    required this.value,
    this.groupValue,
    required this.title,
    required this.onChanged,
    this.image,
  }) : super(key: key);

  final String value;
  String? groupValue;
  final String title;
  final Function(String) onChanged;
  String? image;

  @override
  Widget build(BuildContext context) {
    if (image != null) image = image!.split('.').last != 'txt' ? image : null;
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onChanged: (value) => onChanged(value.toString()),
      subtitle: image != null
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        groupValue == value ? primaryColor : Colors.transparent,
                    width: 2),
              ),
              child: Image.network(
                image!,
              ),
            )
          : null,
      activeColor: primaryColor,
      title: Padding(
        padding: image != null ? EdgeInsets.all(8.0) : EdgeInsets.zero,
        child: Text(title),
      ),
    );
  }
}
