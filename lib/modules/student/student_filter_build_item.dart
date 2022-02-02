import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentFilterBuildItem extends StatelessWidget {
  StudentFilterBuildItem({Key? key}) : super(key: key);

  final List<String> items = [
    'الكل',
    'المرحلة الاعدادية',
    'المرحلة الابتدأية',
  ];
  String selectedValue = 'الكل';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: DefaultDropDown(
        label: 'مادة',
        onChanged: (value) {},
        validator: (value) {},
        items: items,
        haveBackground: true,
        selectedValue: selectedValue,
      ),
    );
  }
}
