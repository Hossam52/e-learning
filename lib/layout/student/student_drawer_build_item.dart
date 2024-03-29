import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/auth/student_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/best_student_list/best_student_list_screen.dart';
import 'package:e_learning/modules/following_list/following_list_screen.dart';
import 'package:e_learning/modules/settings_screen/settings_screen.dart';
import 'package:e_learning/modules/student/my_friend_list/my_friend_list_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/widgets/classroom_dropdown.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentDrawerBuildItem extends StatefulWidget {
  const StudentDrawerBuildItem(
      {Key? key, required this.text, required this.appCubit})
      : super(key: key);

  final AppLocalizations text;
  final AppCubit appCubit;

  @override
  State<StudentDrawerBuildItem> createState() => _StudentDrawerBuildItemState();
}

class _StudentDrawerBuildItemState extends State<StudentDrawerBuildItem> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final authCubit = AuthCubit.get(context);
    if (authCubit.countryNamesList.isEmpty)
      await authCubit.getAllCountriesAndStages();
    // log(authCubit.studentProfileModel!.student!.country!);
    // log(authCubit.countryNamesList.toString());

    authCubit.onChangeCountry(authCubit.studentProfileModel!.student!.country!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      bloc: AuthCubit.get(context),
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
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
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 81.h,
                                width: 77.17.w,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: CachedNetworkImage(
                                  imageUrl: studentModel.image!,
                                  fit: BoxFit.cover,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
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
                                  style: TextButton.styleFrom(
                                      primary: Colors.black87),
                                  child: Text(studentModel.classroom!
                                      // 'الصف التاسع',
                                      ),
                                  onPressed: () {
                                    showDialogClassroomAndStagges(
                                      child: ClassRoomDropDown(
                                        authCubit: AuthCubit.get(context),
                                      ),
                                    );

                                    // Navigator.pop(context);
                                    // appCubit.changeBottomNav(3);
                                  },
                                ),
                              ),
                              VerticalDivider(thickness: 1),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Colors.black87),
                                  child: Text(context.tr.class_nine),
                                  onPressed: () async {
                                    log('Data ${authCubit.classesNameList}');
                                    showDialogClassroomAndStagges(
                                      child: SemsterDropDown(
                                        authCubit: AuthCubit.get(context),
                                      ),
                                    );
                                    // Navigator.pop(context);
                                    // appCubit.changeBottomNav(3);
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
                                      text: '${widget.text.my_points} :  ',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15
                                          // fontSize: 20
                                          )),
                                  TextSpan(
                                      text: studentModel.points.toString(),
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
                              title: widget.text.my_profile,
                              onTap: () {
                                Navigator.pop(context);
                                widget.appCubit.changeBottomNav(3);
                              }),
                          buildListItem(
                            icon: Icons.people,
                            title: widget.text.my_friends,
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(context, MyFriendListScreen());
                            },
                          ),
                          buildListItem(
                            icon: Icons.branding_watermark,
                            title: widget.text.list_of_the_best,
                            onTap: () {
                              Navigator.pop(context);
                              navigateTo(context, BestStudentListScreen());
                            },
                          ),
                          buildListItem(
                            icon: Icons.people,
                            title: widget.text.who_following,
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
                              title: widget.text.how_to_use,
                              onTap: () {}),
                          buildListItem(
                              icon: Icons.privacy_tip_outlined,
                              title: widget.text.privacy_policy,
                              onTap: () {}),
                          buildListItemCustom(
                              icon: FontAwesomeIcons.mobileAlt,
                              title: widget.text.contact_us,
                              onTap: () {}),
                          buildListItem(
                              icon: Icons.info_outline,
                              title: widget.text.about_app,
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
                              widget.text.golden_membership,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          buildListItem(
                              icon: Icons.settings,
                              title: widget.text.settings,
                              onTap: () {
                                Navigator.pop(context);
                                navigateTo(context, SettingsScreen());
                              }),
                          buildListItem(
                            icon: Icons.logout,
                            title: widget.text.logout,
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
      },
    );
  }

  void showDialogClassroomAndStagges({required Widget child}) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    child,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        defaultTextButton(
                            text: 'Done',
                            onPressed: () {
                              final user = AuthCubit.get(context)
                                  .studentProfileModel!
                                  .student!;
                              AuthCubit.get(context).studentRegisterAndEdit(
                                  context: context,
                                  type: AuthType.Edit,
                                  model: StudentModel(
                                    name: user.name!,
                                    email: user.email,
                                    countryId: AuthCubit.get(context)
                                        .selectedCountryId!,
                                    classroomId:
                                        AuthCubit.get(context).selectedClassId,
                                  ));
                              Navigator.pop(context);
                            },
                            textColor: Colors.green),
                        defaultTextButton(
                            text: 'Cancel',
                            textColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
