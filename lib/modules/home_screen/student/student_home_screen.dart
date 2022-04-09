import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/layout/student/test_layout.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/home_screen/student/build_best_teacher_item.dart';
import 'package:e_learning/modules/home_screen/student/category_home_build_item.dart';
import 'package:e_learning/modules/home_screen/student/build_top_students.dart';
import 'package:e_learning/modules/home_screen/student/latest_test_build_item.dart';
import 'package:e_learning/modules/pdfs_module/student/student_subjects_screen.dart';
import 'package:e_learning/modules/profile/student/profile_screen.dart';
import 'package:e_learning/modules/profile/student_profile_view.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/public_group/public_grouo_home_screen.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/test_start_alert_screen.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/subjects_video_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/shared_methods.dart';
import 'package:e_learning/shared/componants/widgets/confirm_exit.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final PageController teacherController = new PageController();

  @override
  void initState() {
    AppCubit.get(context).getHighRateTeachersList(true);
    AppCubit.get(context).getBestStudentsListAuthorized();
    AppCubit.get(context).getBestStudentsList();
    TestLayoutCubit.get(context).getStudentTests(TestType.latestTest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return ConfirmExit(
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AuthCubit authCubit = AuthCubit.get(context);
          return BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return BlocConsumer<TestLayoutCubit, TestLayoutStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        authCubit.profileDataLoading == false,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) => authCubit.noProfileData
                        ? NoDataWidget(
                            onPressed: () => authCubit.getProfile(true))
                        : responsiveWidget(
                            responsive: (_, deviceInfo) =>
                                SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            primaryColor.withOpacity(0.26)),
                                    onPressed: () => navigateTo(
                                        context,
                                        PublicGroupHomeScreen(
                                          isStudent: true,
                                        )),
                                    icon: Icon(
                                      Icons.people,
                                      color: primaryColor,
                                    ),
                                    label: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: Text(
                                        text.public_group,
                                        style:
                                            subTextStyle(deviceInfo).copyWith(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  buildTitleHome(
                                      deviceInfo: deviceInfo,
                                      title: text.best_teachers),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Conditional.single(
                                    context: context,
                                    conditionBuilder: (context) =>
                                        cubit.isStudentHighRateLoading == false,
                                    fallbackBuilder: (context) => loader(),
                                    widgetBuilder: (context) => cubit
                                                .studentHighRateTeachersModel ==
                                            null
                                        ? noData(context.tr.no_data)
                                        : Container(
                                            height: 130.h,
                                            child: Swiper(
                                              itemCount: cubit
                                                  .studentHighRateTeachersModel!
                                                  .teachers!
                                                  .data!
                                                  .length,
                                              viewportFraction: 1.0,
                                              itemHeight: 120.h,
                                              pagination:
                                                  new SwiperPagination(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var teacher = cubit
                                                    .studentHighRateTeachersModel!
                                                    .teachers!
                                                    .data![index];
                                                return new BuildBestTeacherItem(
                                                  text: text,
                                                  name: teacher.name!,
                                                  image: teacher.image!,
                                                  subjects: List.generate(
                                                      teacher.subjects!.length,
                                                      (index) => teacher
                                                          .subjects![index]
                                                          .name),
                                                  followersCount:
                                                      teacher.followersCount!,
                                                  onTap: () {
                                                    navigateTo(
                                                        context,
                                                        TeacherProfileView(
                                                          // teacher: teacher,
                                                          teacherId: teacher.id,
                                                          isAdd: false,
                                                          cubit:
                                                              StudentCubit.get(
                                                                  context),
                                                        ));
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  buildTitleHome(
                                      deviceInfo: deviceInfo,
                                      title: text.best_students),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Conditional.single(
                                    context: context,
                                    conditionBuilder: (context) =>
                                        cubit.isBestStudentsListLoading ==
                                        false,
                                    fallbackBuilder: (context) => loader(),
                                    widgetBuilder: (context) => cubit
                                                .bestStudentsModelAuthorized ==
                                            null
                                        ? noData(context.tr.no_data)
                                        : CarouselSlider.builder(
                                            itemCount: cubit
                                                .bestStudentsModelAuthorized!
                                                .students!
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int itemIndex,
                                                int pageViewIndex) {
                                              var student = cubit
                                                  .bestStudentsModelAuthorized!
                                                  .students![itemIndex];
                                              return BuildTopStudent(
                                                deviceInfo: deviceInfo,
                                                text: text,
                                                name: student.name!,
                                                image: student.image!,
                                                pointsCount:
                                                    student.points.toString(),
                                                onTap: () {
                                                  SharedMethods
                                                      .navigateToProfile(
                                                          true,
                                                          true,
                                                          context,
                                                          student.id!);
                                                  return;
                                                },
                                              );
                                            },
                                            options: CarouselOptions(
                                              enlargeCenterPage: true,
                                              height: 100.h,
                                              viewportFraction: 0.65,
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildTitleHome(
                                          deviceInfo: deviceInfo,
                                          title: text.latest_test),
                                      TextButton(
                                          onPressed: () {
                                            navigateTo(context, TestLayout());
                                          },
                                          child: Text(
                                            text.view_all,
                                            style: thirdTextStyle(deviceInfo)
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        deviceInfo.screenwidth *
                                                            0.032),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Conditional.single(
                                    context: context,
                                    conditionBuilder: (context) =>
                                        TestLayoutCubit.get(context)
                                            .isGetTestsLoading ==
                                        false,
                                    fallbackBuilder: (context) => loader(),
                                    widgetBuilder: (context) => TestLayoutCubit
                                                .get(context)
                                            .noLatestTestsData
                                        ? noData(context.tr.no_found)
                                        : Container(
                                            height: 75.h,
                                            child: ListView.separated(
                                              itemCount:
                                                  TestLayoutCubit.get(context)
                                                      .studentLatestTests
                                                      .length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 22),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(width: 5),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                var test = TestLayoutCubit.get(
                                                        context)
                                                    .studentLatestTests[index];
                                                return LatestTestBuildItem(
                                                  title: test.name!,
                                                  subject: test.subject!,
                                                  onPressed: () {
                                                    final startTestBefore =
                                                        CacheHelper.getData(
                                                            key:
                                                                'test${test.id!}');
                                                    if (test.result == null) {
                                                      navigateTo(
                                                          context,
                                                          TestStartAlertScreen(
                                                              test: test));
                                                    } else {
                                                      showSnackBar(
                                                        context: context,
                                                        text: context.tr
                                                            .taken_exam_before,
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  buildTitleHome(
                                      deviceInfo: deviceInfo,
                                      title: text.categories),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  GridView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 21),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 8.w,
                                      mainAxisSpacing: 8.h,
                                      crossAxisCount: 3,
                                    ),
                                    children: [
                                      CategoryHomeBuildItem(
                                        deviceInfo: deviceInfo,
                                        title: text.tests,
                                        image: 'assets/images/exam.png',
                                        onPressed: () {
                                          navigateTo(context, TestLayout());
                                        },
                                      ),
                                      CategoryHomeBuildItem(
                                        deviceInfo: deviceInfo,
                                        title: text.videos,
                                        image: 'assets/images/youtube.png',
                                        onPressed: () {
                                          navigateTo(
                                              context,
                                              SubjectsVideoScreen(
                                                  isStudent: true));
                                        },
                                      ),
                                      CategoryHomeBuildItem(
                                        deviceInfo: deviceInfo,
                                        title: text.notes,
                                        image: 'assets/images/book.png',
                                        onPressed: () {
                                          navigateTo(
                                              context,
                                              StudentSubjectsScreen(
                                                title: text.notes,
                                                type: 'booklet',
                                              ));
                                        },
                                      ),
                                      CategoryHomeBuildItem(
                                        deviceInfo: deviceInfo,
                                        title: text.ministry_books,
                                        image: 'assets/images/books.png',
                                        onPressed: () {
                                          navigateTo(
                                              context,
                                              StudentSubjectsScreen(
                                                title: text.ministry_books,
                                                type: 'books',
                                              ));
                                        },
                                      ),
                                      CategoryHomeBuildItem(
                                        deviceInfo: deviceInfo,
                                        title: text.reviews,
                                        image: 'assets/images/revision.png',
                                        onPressed: () {
                                          navigateTo(
                                              context,
                                              StudentSubjectsScreen(
                                                title: text.reviews,
                                                type: 'reviews',
                                              ));
                                        },
                                      ),
                                      CategoryHomeBuildItem(
                                        deviceInfo: deviceInfo,
                                        title: text.exams,
                                        image: 'assets/images/exam-2.png',
                                        onPressed: () {
                                          navigateTo(
                                              context,
                                              StudentSubjectsScreen(
                                                title: text.exams,
                                                type: 'exams',
                                              ));
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget loader() => Container(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(),
      );
}
