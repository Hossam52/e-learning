import 'package:e_learning/modules/teacher/results/results_tab.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) => Column(
        children: [
          ListTile(title: Text('الواجبات')),
          Expanded(child: ResultsTab(deviceInfo: deviceInfo)),
        ],
      ),
    );
  }
}
