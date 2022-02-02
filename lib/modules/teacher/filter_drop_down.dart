import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilterDropDown extends StatelessWidget {
  FilterDropDown({Key? key,
    required this.onChanged,
    required this.items,
    this.hint,
    this.selectedValue,
    required this.width,
    required this.label,
  }) : super(key: key);

  String? hint;
  String? selectedValue;
  final Function onChanged;
  final List<String> items;
  final double width;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: thirdTextStyle(null),),
        Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(13)),
          child: DropdownButton<String>(
              value: selectedValue,
              underline: SizedBox(),
              onChanged: (value) {
                onChanged(value);
              },
              isExpanded: true,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
          ),
        ),
      ],
    );
  }
}
