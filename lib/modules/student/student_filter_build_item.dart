import 'dart:developer';

import 'package:e_learning/models/general_apis/subjects_data_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class StudentFilterBuildItem extends StatefulWidget {
  StudentFilterBuildItem({Key? key, this.subjects, this.defaultSelected})
      : super(key: key);
  final List<Subjects>? subjects;
  final String? defaultSelected;

  @override
  State<StudentFilterBuildItem> createState() => _StudentFilterBuildItemState();
}

class _StudentFilterBuildItemState extends State<StudentFilterBuildItem> {
  String all = 'All';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupStates>(
      builder: (context, state) {
        String selectedValue = widget.defaultSelected ?? 'All';
        log(selectedValue);
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: DefaultDropDown(
            label: 'Subject',
            onChanged: (value) {
              GroupCubit.get(context).updateSelectedSubjectID(context, value);
              GroupCubit.get(context).discoverGroupsBySubjectId();
            },
            validator: (value) {},
            items: [all, ...widget.subjects!.map((e) => e.name!).toList()],
            haveBackground: true,
            selectedValue: selectedValue,
          ),
        );
      },
    );
  }
}
