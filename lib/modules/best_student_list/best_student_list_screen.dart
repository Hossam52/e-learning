import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/best_avatar_build_item.dart';
import 'package:e_learning/shared/componants/widgets/other_places_avatar_item.dart';
import 'package:e_learning/shared/componants/widgets/student_lead_board_build_item.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BestStudentListScreen extends StatelessWidget {
  const BestStudentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            image: DecorationImage(
              image: AssetImage('assets/images/Winners-bg.png'),
            )
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text('الأعلى نقاطاً'),
              centerTitle: true,
              leading: defaultBackButton(context, deviceInfo.screenHeight),
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'المستخدمين الأعلى نقاطا ',
                      style: thirdTextStyle(deviceInfo).copyWith(color: Colors.black),
                      children: const <TextSpan>[
                        TextSpan(text: 'الترم الاول', style: TextStyle(color: primaryColor)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OtherPlacesAvatarItem(
                        deviceInfo: deviceInfo,
                        image: 'https://www.tlnt.com/wp-content/uploads/sites/4/2015/04/graduate.jpg',
                        name: 'صالح احمد',
                        points: '250',
                        place: 'المركز الثاني',
                      ),
                      BestAvatarBuildItem(
                        deviceInfo: deviceInfo,
                        image: 'https://img.freepik.com/free-photo/teenager-student-girl-yellow-pointing-finger-side_1368-40175.jpg?size=626&ext=jpg',
                        name: 'سمر محمد محمد',
                        points: '1505',
                      ),
                      OtherPlacesAvatarItem(
                        deviceInfo: deviceInfo,
                        image: 'https://st.depositphotos.com/1594308/2419/i/950/depositphotos_24196475-stock-photo-student-with-copybook.jpg',
                        name: 'غيداء خليل',
                        points: '850',
                        place: 'المركز الثالث',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.5.h,),
                defaultDivider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: 10,
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) => StudentLeadBoardBuildItem(
                      deviceInfo: deviceInfo,
                      name: 'عبدالرحمن ابراهيم',
                      place: 'المركز الاول',
                      image: 'https://img.freepik.com/free-photo/female-student-with-books-paperworks_1258-48204.jpg?size=626&ext=jpg',
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
