import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/best_student_list/best_student_list_screen.dart';
import 'package:e_learning/modules/following_list/following_list_screen.dart';
import 'package:e_learning/modules/settings_screen/settings_screen.dart';
import 'package:e_learning/modules/student/my_friend_list/my_friend_list_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentDrawerBuildItem extends StatelessWidget {
  const StudentDrawerBuildItem(
      {Key? key, required this.text, required this.appCubit})
      : super(key: key);

  final AppLocalizations text;
  final AppCubit appCubit;

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthCubit.get(context);
    final studentModel = authCubit.studentProfileModel!.student!;
    print('-------------${authCubit.studentProfileModel!.student!.name}');
    return Container(
      color: Color(0xffEFF0FC),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Color(0xffD8DCFC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(170),
                      bottomRight: Radius.circular(170),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(top: 30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              studentModel.image!,
                            ),
                            radius: MediaQuery.of(context).size.width * 0.1,
                          ),
                          SizedBox(height: 5),
                          Text(studentModel.name!),
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
                  Container(
                    color: Colors.white,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(primary: Colors.black87),
                              child: Text(studentModel.classroom!
                                  // 'الصف التاسع',
                                  ),
                              onPressed: () {
                                Navigator.pop(context);
                                appCubit.changeBottomNav(3);
                              },
                            ),
                          ),
                          VerticalDivider(thickness: 1),
                          Expanded(
                            child: TextButton(
                              style:
                                  TextButton.styleFrom(primary: Colors.black87),
                              child: Text('الترم التاني'),
                              onPressed: () {
                                Navigator.pop(context);
                                appCubit.changeBottomNav(3);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Image.asset('assets/images/points.png'),
                            SizedBox(width: 30),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '${text.my_points} :  ',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15
                                      // fontSize: 20
                                      )),
                              TextSpan(
                                  text: studentModel.points,
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 20
                                  )),
                            ]))
                          ],
                        ),
                      ),
                      buildListItem(
                          icon: Icons.person,
                          title: text.my_profile,
                          onTap: () {
                            Navigator.pop(context);
                            appCubit.changeBottomNav(3);
                          }),
                      buildListItem(
                        icon: Icons.people,
                        title: text.my_friends,
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, MyFriendListScreen());
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
                      buildListItem(
                        icon: Icons.people,
                        title: text.who_following,
                        onTap: () {
                          Navigator.pop(context);
                          navigateTo(context, FollowingListScreen());
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
                          Icons.star,
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
                          }),
                      buildListItem(
                        icon: Icons.logout,
                        title: text.logout,
                        onTap: () {
                          signOutStudent(context);
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
