import 'package:e_learning/modules/following_list/teachers_tab.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingListScreen extends StatelessWidget {
  FollowingListScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) {
        return BlocProvider(
          create: (context) => StudentCubit(),
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(context.tr.who_i_follow),
                centerTitle: true,
                leading: defaultBackButton(context, deviceInfo.screenHeight),
                bottom: TabBar(
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: context.tr.teachers_list),
                    Tab(text: context.tr.suggested_teachers),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        TeachersTab(controller: controller, isAdd: false),
                        TeachersTab(controller: controller, isAdd: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
