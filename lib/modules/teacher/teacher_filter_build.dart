import 'package:e_learning/modules/teacher/filter_drop_down.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherFilterBuild extends StatelessWidget {
  TeacherFilterBuild({
    Key? key,
    required this.deviceInfo,
    required this.stageItems,
    required this.classItems,
    this.selectedStage,
    this.selectedClass,
    required this.onStageChanged,
    required this.onClassChanged,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final List<String> stageItems;
  final List<String> classItems;
  String? selectedStage;
  String? selectedClass;
  final Function onStageChanged;
  final Function onClassChanged;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('تصنيف'),
      trailing: selectedStage != null
          ? Chip(label: Text(selectedStage!),) : null,
      childrenPadding: EdgeInsets.symmetric(horizontal: 22),
      tilePadding: EdgeInsets.symmetric(horizontal: 22),
      children:[
        FilterDropDown(
          width: double.infinity,
          onChanged: (value) {
            onStageChanged(value);
          },
          label: 'المرحلة',
          items: stageItems,
          selectedValue: selectedStage,
        ),
        SizedBox(height: 17.h),
        FilterDropDown(
          width: double.infinity,
          onChanged: (value) {
            onStageChanged(value);
          },
          label: 'السنة الدراسية',
          items: stageItems,
          selectedValue: selectedStage,
        ),
        SizedBox(height: 17.h),
        FilterDropDown(
          width: double.infinity,
          onChanged: (value) {
            onStageChanged(value);
          },
          label: 'الترم',
          items: stageItems,
          selectedValue: selectedStage,
        ),
        SizedBox(height: 17.h),
      ]
    );
  }
}
