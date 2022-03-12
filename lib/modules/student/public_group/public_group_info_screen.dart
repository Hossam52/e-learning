import 'package:e_learning/models/teacher/groups/group_response_model.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublicGroupInfoScreen extends StatelessWidget {
  const PublicGroupInfoScreen({Key? key, required this.groupInfo})
      : super(key: key);

  final Group groupInfo;
  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (_, deviceInfo) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(groupInfo.title!),
          centerTitle: true,
          // leading: Container(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 10.w),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.group_description,
                      style: secondaryTextStyle(deviceInfo),
                    ),
                    SizedBox(
                      height: deviceInfo.screenHeight * 0.04,
                    ),
                    Text(
                      groupInfo.description!,
                      style: thirdTextStyle(deviceInfo),
                    ),
                    SizedBox(
                      height: deviceInfo.screenHeight * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
