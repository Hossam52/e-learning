import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/profile/student/profile_tabs/edit_profile_tab.dart';
import 'package:e_learning/modules/profile/student/profile_tabs/friend_request_tab.dart';
import 'package:e_learning/modules/profile/student/profile_tabs/profile_posts_tab.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabsBuildItem extends StatefulWidget {
  const TabsBuildItem({Key? key, required this.student}) : super(key: key);

  final Student student;
  @override
  _TabsBuildItemState createState() => _TabsBuildItemState();
}

class _TabsBuildItemState extends State<TabsBuildItem>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int index = 0;
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                )),
            child: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              onTap: (value) {
                index = value;
                AuthCubit.get(context).emit(AuthChangeState());
              },
              indicator: BoxDecoration(
                color: thirdColor,
              ),
              unselectedLabelStyle:
                  TextStyle(fontSize: 13.sp, fontFamily: 'NeoSansArabic'),
              tabs: [
                Tab(text: 'حسابي'),
                Tab(text: 'طلبات الصداقه'),
                Tab(text: 'المنشورات'),
              ],
            ),
          ),
          generateStudentProfileTab(index),
        ],
      ),
    );
  }

  Widget generateStudentProfileTab(int index) {
    List<Widget> widgets = [
      EditProfileTab(student: widget.student),
      FriendRequestTab(),
      ProfilePostsTab(),
    ];
    return widgets[index];
  }
}
