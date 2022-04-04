import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/best_avatar_build_item.dart';
import 'package:e_learning/shared/componants/widgets/other_places_avatar_item.dart';
import 'package:e_learning/shared/componants/widgets/student_lead_board_build_item.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestStudentListScreen extends StatelessWidget {
  const BestStudentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bestStudents = AppCubit.get(context).bestStudentsModel!.students;

    return responsiveWidget(
      responsive: (_, deviceInfo) {
        return Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              image: DecorationImage(
                image: AssetImage('assets/images/Winners-bg.png'),
              )),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                context.tr.highest_points,
                // 'الأعلى نقاطاً'
              ),
              centerTitle: true,
              leading: defaultBackButton(context, deviceInfo.screenHeight),
            ),
            backgroundColor: Colors.transparent,
            body: bestStudents!.isEmpty
                ? Center(
                    child: Text(context.tr.empty),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (bestStudents.length > 1)
                              OtherPlacesAvatarItem(
                                deviceInfo: deviceInfo,
                                image: bestStudents[1].image!,
                                name: bestStudents[1].name!,
                                points: bestStudents[1].points!.toString(),
                                place: '2.st',
                              ),
                            BestAvatarBuildItem(
                              deviceInfo: deviceInfo,
                              image: bestStudents[0].image!,
                              name: bestStudents[0].name!,
                              points: bestStudents[0].points!.toString(),
                            ),
                            if (bestStudents.length > 2)
                              OtherPlacesAvatarItem(
                                deviceInfo: deviceInfo,
                                image: bestStudents[2].image!,
                                name: bestStudents[2].name!,
                                points: bestStudents[2].points!.toString(),
                                place: '3.st',
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22.5.h,
                      ),
                      defaultDivider(),
                      Expanded(
                        child: ListView.separated(
                          itemCount: bestStudents.length,
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) =>
                              StudentLeadBoardBuildItem(
                            deviceInfo: deviceInfo,
                            name: bestStudents[index].name!,
                            place: '${index + 1}.st',
                            image: bestStudents[index].image!,
                            points: bestStudents[index].points!.toString(),
                            profileId: bestStudents[index].id!,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
