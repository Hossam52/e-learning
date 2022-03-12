import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/teacher/results/results_view/result_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

// ignore: must_be_immutable
class HomeWorkResultScreen extends StatelessWidget {
  HomeWorkResultScreen({Key? key, this.results}) : super(key: key);

  List<Result>? results;
  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) => Scaffold(
        appBar: AppBar(
          title: Text(context.tr.results),
          elevation: 1,
          centerTitle: true,
          leading: defaultBackButton(context, deviceInfo.screenHeight),
        ),
        body: Conditional.single(
          context: context,
          conditionBuilder: (context) => results != null && results!.isNotEmpty,
          fallbackBuilder: (context) => noData(context.tr.no_answers),
          widgetBuilder: (context) => ListView.separated(
            itemCount: results!.length,
            padding: EdgeInsets.all(22),
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
            ),
            itemBuilder: (context, index) => ResultBuildItem(
              name: results![index].student!,
              image: results![index].student!,
              result: results![index].rightAnswerNum ?? 'لم يحل',
            ),
          ),
        ),
      ),
    );
  }
}
