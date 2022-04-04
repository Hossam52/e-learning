import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_learning/modules/groups/teacher/teacher_public_groups_screen.dart';
import 'package:e_learning/modules/home_screen/student/build_best_teacher_item.dart';
import 'package:e_learning/modules/home_screen/student/build_top_students.dart';
import 'package:e_learning/modules/home_screen/student/category_home_build_item.dart';
import 'package:e_learning/modules/pdfs_module/teacher/teacher_subjects_pdf_screen.dart';
import 'package:e_learning/modules/profile/student/student_profile_info_build.dart';
import 'package:e_learning/modules/profile/student_profile_view.dart';
import 'package:e_learning/modules/student/public_group/public_grouo_home_screen.dart';
import 'package:e_learning/modules/test_module/teacher/test_subjects_screen.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/subjects_video_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/widgets/confirm_exit.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  void initState() {
    AppCubit.get(context).getHighRateTeachersList(false);
    AppCubit.get(context).getBestStudentsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return responsiveWidget(
      responsive: (_, deviceInfo) => SingleChildScrollView(
        child: Column(
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.26)),
              onPressed: () => navigateTo(context, TeacherPublicGroupsScreen()),
              icon: Icon(
                Icons.people,
                color: primaryColor,
              ),
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  context.tr.official_groups_for_my_subjects,
                  style: subTextStyle(deviceInfo).copyWith(
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildTitleHome(deviceInfo: deviceInfo, title: text.best_teachers),
            SizedBox(
              height: 10,
            ),
            //static
            Container(
              height: 120.h,
              child: BlocBuilder<AppCubit, AppStates>(
                builder: (context, state) {
                  return AppCubit.get(context).isStudentHighRateLoading
                      ? Center(child: CircularProgressIndicator())
                      : Swiper(
                          itemCount: AppCubit.get(context)
                              .studentHighRateTeachersModel!
                              .teachers!
                              .data!
                              .length,
                          viewportFraction: 1.0,
                          itemHeight: 120.h,
                          pagination: new SwiperPagination(),
                          itemBuilder: (BuildContext context, int index) {
                            return new BuildBestTeacherItem(
                              text: text,
                              subjects: [],
                              image: AppCubit.get(context)
                                  .studentHighRateTeachersModel!
                                  .teachers!
                                  .data![index]
                                  .image!,
                              name: AppCubit.get(context)
                                  .studentHighRateTeachersModel!
                                  .teachers!
                                  .data![index]
                                  .name!,
                              onTap: () {},
                              followersCount: AppCubit.get(context)
                                  .studentHighRateTeachersModel!
                                  .teachers!
                                  .data![index]
                                  .followersCount!,
                            );
                          },
                        );
                },
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            buildTitleHome(deviceInfo: deviceInfo, title: text.best_students),
            SizedBox(
              height: 12.h,
            ),

            BlocBuilder<AppCubit, AppStates>(
              builder: (context, state) {
                return AppCubit.get(context).isBestStudentsListLoading ||
                        state is BestStudentsLoadingState
                    ? CircularProgressIndicator()
                    : CarouselSlider.builder(
                        itemCount: AppCubit.get(context)
                            .bestStudentsModel!
                            .students!
                            .length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            BuildTopStudent(
                          deviceInfo: deviceInfo,
                          text: text,
                          image: AppCubit.get(context)
                              .bestStudentsModel!
                              .students![itemIndex]
                              .image!,
                          name: AppCubit.get(context)
                              .bestStudentsModel!
                              .students![itemIndex]
                              .name!,
                          pointsCount: AppCubit.get(context)
                              .bestStudentsModel!
                              .students![itemIndex]
                              .points!,
                          onTap: () {
                            // navigateTo(
                            //     context,
                            //     StudentProfileView(
                            //       isFriend: false,
                            //       isTeacher: true,
                            //       id: AppCubit.get(context)
                            //           .bestStudentsModel!
                            //           .students![itemIndex]
                            //           .id,
                            //       // student: AppCubit.get(context)
                            //       //     .bestStudentsModel!
                            //       //     .students![itemIndex],
                            //     ));
                          },
                        ),
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          height: 100.h,
                          viewportFraction: 0.65,
                        ),
                      );
              },
            ),
            SizedBox(
              height: 16.h,
            ),
            buildTitleHome(deviceInfo: deviceInfo, title: text.categories),
            SizedBox(
              height: 14.h,
            ),
            GridView(
              padding: EdgeInsets.symmetric(horizontal: 21.w),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8.w, //horizontal,
                mainAxisSpacing: 8.h,
                crossAxisCount: 3,
              ),
              children: [
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.teacher_Guides,
                  image: 'assets/images/blackboard.png',
                  onPressed: () {
                    navigateTo(
                      context,
                      TeacherSubjectsPdfScreen(
                        title: text.teacher_Guides,
                        type: 'teacher_guide',
                      ),
                    );
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.reviews,
                  image: 'assets/images/revision.png',
                  onPressed: () {
                    navigateTo(
                      context,
                      TeacherSubjectsPdfScreen(
                        title: text.reviews,
                        type: 'reviews',
                      ),
                    );
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.notes,
                  image: 'assets/images/book.png',
                  onPressed: () {
                    navigateTo(
                      context,
                      TeacherSubjectsPdfScreen(
                        title: text.notes,
                        type: 'booklet',
                      ),
                    );
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.ministry_books,
                  image: 'assets/images/books.png',
                  onPressed: () {
                    navigateTo(
                        context,
                        TeacherSubjectsPdfScreen(
                          title: text.ministry_books,
                          type: 'books',
                        ));
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.tests,
                  image: 'assets/images/exam.png',
                  onPressed: () {
                    navigateTo(context, TestSubjectsScreen());
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.exams,
                  image: 'assets/images/exam-2.png',
                  onPressed: () {
                    navigateTo(
                      context,
                      TeacherSubjectsPdfScreen(
                        title: text.exams,
                        type: 'exams',
                      ),
                    );
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.records,
                  image: 'assets/images/folder.png',
                  onPressed: () {
                    navigateTo(
                        context,
                        TeacherSubjectsPdfScreen(
                          title: text.records,
                          type: 'records',
                        ));
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.videos,
                  image: 'assets/images/youtube.png',
                  onPressed: () {
                    navigateTo(context, SubjectsVideoScreen(isStudent: false));
                  },
                ),
                CategoryHomeBuildItem(
                  deviceInfo: deviceInfo,
                  title: text.preparation_book,
                  image: 'assets/images/notes.png',
                  onPressed: () {
                    navigateTo(
                      context,
                      TeacherSubjectsPdfScreen(
                        title: text.preparation_book,
                        type: 'preparation_notebook',
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
