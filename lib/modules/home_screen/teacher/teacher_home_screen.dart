import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_learning/modules/home_screen/student/build_best_teacher_item.dart';
import 'package:e_learning/modules/home_screen/student/build_top_students.dart';
import 'package:e_learning/modules/home_screen/student/category_home_build_item.dart';
import 'package:e_learning/modules/pdfs_module/teacher/teacher_subjects_pdf_screen.dart';
import 'package:e_learning/modules/test_module/teacher/test_subjects_screen.dart';
import 'package:e_learning/modules/video_module/video_teacher_screens/subjects_video_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/home_components.dart';
import 'package:e_learning/shared/componants/widgets/confirm_exit.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
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
    return ConfirmExit(
      child: responsiveWidget(
        responsive: (context, deviceInfo) => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              buildTitleHome(deviceInfo: deviceInfo, title: text.best_teachers),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120.h,
                child: Swiper(
                  itemCount: 4,
                  viewportFraction: 1.0,
                  itemHeight: 120.h,
                  pagination: new SwiperPagination(),
                  itemBuilder: (BuildContext context, int index) {
                    return new BuildBestTeacherItem(
                      text: text,
                      subjects: [],
                      image:
                          'https://userstock.io/data/wp-content/uploads/2020/06/robert-godwin-cdksyTqEXzo.jpg',
                      name: 'ا احمد',
                      onTap: () {},
                      followersCount: 2,
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
              CarouselSlider.builder(
                itemCount: 4,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        BuildTopStudent(
                  deviceInfo: deviceInfo,
                  text: text,
                  image:
                      'https://userstock.io/data/wp-content/uploads/2020/06/jack-finnigan-rriAI0nhcbc.jpg',
                  name: 'عبدرحمن',
                  pointsCount: '5',
                  onTap: () {},
                ),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 100.h,
                  viewportFraction: 0.65,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              buildTitleHome(deviceInfo: deviceInfo, title: text.categories),
              SizedBox(
                height: 14.h,
              ),
              GridView(
                padding: EdgeInsets.symmetric(horizontal: 21),
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
                    image: 'assets/images/exam-2.png',
                    onPressed: () {
                      navigateTo(context, TestSubjectsScreen());
                    },
                  ),
                  CategoryHomeBuildItem(
                    deviceInfo: deviceInfo,
                    title: text.exams,
                    image: 'assets/images/exam.png',
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
                      navigateTo(
                          context, SubjectsVideoScreen(isStudent: false));
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
      ),
    );
  }
}
