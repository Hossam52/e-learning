import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/layout/teacher/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/best_student_list/best_student_list_screen.dart';
import 'package:e_learning/modules/settings_screen/settings_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeacherDrawerBuildItem extends StatelessWidget {
  const TeacherDrawerBuildItem({Key? key, required this.appCubit})
      : super(key: key);

  final TeacherLayoutCubit appCubit;
  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);
    final teacher = AuthCubit.get(context).teacherProfileModel!.teacher!;
    return Container(
      width:0.75.sw,
      color: Color(0xffEFF0FC),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.29,
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.29,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.21,
                  decoration: BoxDecoration(
                    color: Color(0xffD8DCFC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(170.r),
                      bottomRight: Radius.circular(170.r),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(top: 30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 81.h,
                            width: 77.17.w,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CachedNetworkImage(
                              imageUrl: teacher.image!,
                              fit: BoxFit.cover,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            teacher.name!,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 20),
                      //   child: Row(
                      //     children: [
                      //   //    Image.asset('assets/images/points.png'),
                      //     //  SizedBox(width: 30),
                      //       // RichText(
                      //       //     text: TextSpan(children: [
                      //       //   TextSpan(
                      //       //       text: '${text!.my_points} :  ',
                      //       //       style: TextStyle(
                      //       //           color: Colors.black87,
                      //       //           fontWeight: FontWeight.w800,
                      //       //           fontSize: 15
                      //       //           // fontSize: 20
                      //       //           )),
                      //       //   TextSpan(
                      //       //       text: teacher.authStudentRate.toString(),
                      //       //       style: TextStyle(
                      //       //         color: Colors.lightBlue,
                      //       //         fontWeight: FontWeight.bold,
                      //       //         // fontSize: 20
                      //       //       )),
                      //       // ]))
                      //     ],
                      //   ),
                      // ),
                      buildListItem(
                        icon: Icons.person,
                        title: text!.my_profile,
                        onTap: () {
                          Navigator.pop(context);
                          appCubit.changeBottomNav(3);
                        },
                      ),
                      buildListItem(
                        icon: Icons.branding_watermark,
                        title: text.list_of_the_best,
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, BestStudentListScreen());
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    children: [
                      buildListItemCustom(
                          icon: FontAwesomeIcons.handPeace,
                          title: text.how_to_use,
                          onTap: () {}),
                      buildListItem(
                          icon: Icons.privacy_tip_outlined,
                          title: text.privacy_policy,
                          onTap: () {}),
                      buildListItemCustom(
                          icon: FontAwesomeIcons.mobileAlt,
                          title: text.contact_us,
                          onTap: () {}),
                      buildListItem(
                          icon: Icons.info_outline,
                          title: text.about_app,
                          onTap: () {}),
                    ],
                  ),
                  Divider(),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.solidStar,
                          color: Color(0xffFDBF03),
                        ),
                        title: Text(
                          text.golden_membership,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {},
                      ),
                      buildListItem(
                        icon: Icons.settings,
                        title: text.settings,
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, SettingsScreen());
                        },
                      ),
                      buildListItem(
                        icon: Icons.logout,
                        title: text.logout,
                        onTap: () {
                          signOutTeacher(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
