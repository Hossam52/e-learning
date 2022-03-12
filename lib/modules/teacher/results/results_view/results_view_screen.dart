import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/teacher/results/results_view/home_work_result_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/homework_build_item.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class ResultViewScreen extends StatefulWidget {
  const ResultViewScreen({Key? key, required this.groupId}) : super(key: key);

  final int groupId;

  @override
  _ResultViewScreenState createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  @override
  void initState() {
    GroupCubit.get(context).getGroupHomework(widget.groupId, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) => BlocConsumer<GroupCubit, GroupStates>(
        listener: (context, state) {},
        builder: (context, state) {
          GroupCubit cubit = GroupCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(context.tr.results),
              elevation: 1,
              centerTitle: true,
              leading: defaultBackButton(context, deviceInfo.screenHeight),
            ),
            body: Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! GroupGetHomeworkLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noHomeworkData
                  ? NoDataWidget(
                      onPressed: () =>
                          cubit.getGroupHomework(widget.groupId, false))
                  : ListView.builder(
                      itemCount: cubit.homeWorkResponseModel!.homework!.length,
                      padding: EdgeInsets.all(22),
                      itemBuilder: (context, index) {
                        var homework =
                            cubit.homeWorkResponseModel!.homework![index];
                        return HomeworkBuildItem(
                          deviceInfo: deviceInfo,
                          title: homework.name!,
                          buttonText: context.tr.homework_results,
                          onPressed: () {
                            navigateTo(
                                context,
                                HomeWorkResultScreen(
                                  results: homework.resultTeacher,
                                ));
                          },
                          onDelete: () {},
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
