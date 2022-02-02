import 'package:e_learning/modules/groups/student/group_tabs/discover_student_groups_tab.dart';
import 'package:e_learning/modules/groups/student/group_tabs/my_groups_tab.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return responsiveWidget(
          responsive: (context, deviceInfo) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TabBar(
                  controller: tabController,
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  tabs: [
                    Tab(text: text.my_groups),
                    Tab(text: text.discover),
                  ],
                ),
                SizedBox(height: 22.h),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      MyGroupsTab(),
                      DiscoverStudentGroupsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
