import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/champions/champion_response_model.dart';
import 'package:e_learning/models/student/group/friends_response_model.dart';
import 'package:e_learning/models/student/home/general_apis/students_list_response_model.dart';
import 'package:e_learning/models/teacher/groups/homework/homework_response_model.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/student_test/exam_screen.dart';
import 'package:e_learning/modules/test_module/student_test/student_champion/student_challenge_screen.dart';
import 'package:e_learning/modules/test_module/student_test/student_challenges/student_my_challenges.dart';
import 'package:e_learning/modules/test_module/student_test/student_invitations_screen.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_quetion.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:e_learning/shared/network/services/test_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_state_button/progress_button.dart';

class TestLayoutCubit extends Cubit<TestLayoutStates> {
  TestLayoutCubit() : super(TestLayoutInitialState());

  static TestLayoutCubit get(context) => BlocProvider.of(context);

  // Current nav index
  int currentIndex = 0;

  // List of nav screens
  List<Widget> selectedScreens = [
    StudentExamScreen(),
    StudentChallengeScreen(),
    StudentMyChallenges(),
    StudentMyInvitationsScreen(),
  ];

  String selectedTitle() {
    if (currentIndex == 0)
      return 'اختبار';
    else if (currentIndex == 1)
      return 'منافسة';
    else if (currentIndex == 2)
      return 'بطولات';
    else
      return 'دعواتي';
  }

  // Change nav function
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeTestBottomNavState());
  }

  /// --------------------------------------------
  /// student
  /// Get Student tests method
  List<Test> studentTestsList = [];
  List<Test> studentChallengeList = [];
  List<Test> studentLatestTests = [];
  bool isGetTestsLoading = false;
  bool noStudentTestsData = false;
  bool noStudentChallengeData = false;
  bool noStudentChampionData = false;
  bool noLatestTestsData = false;

  void getStudentTests(TestType type) async {
    isGetTestsLoading = true;
    emit(StudentTestsLoadingState());
    try {
      Response response = await DioHelper.getData(
        url: generateTestUrl(type),
        token: studentToken,
      );
      if (response.data['status']) {
        insertTestLists(type, response);
        emit(StudentTestsSuccessState());
      } else {
        addErrorStates(type);
        print(response.data['message']);
        emit(StudentTestsErrorState());
      }
    } catch (e) {
      addErrorStates(type);
      emit(StudentTestsErrorState());
      throw e;
    } finally {
      isGetTestsLoading = false;
      emit(ChangeTestState());
    }
  }

  void addErrorStates(TestType type) {
    switch (type) {
      case TestType.Test:
        noStudentTestsData = true;
        break;
      case TestType.Challenge:
        noStudentChallengeData = true;
        break;
      case TestType.Champion:
        noStudentChampionData = true;
        break;
      case TestType.latestTest:
        noLatestTestsData = true;
        break;
    }
  }

  String generateTestUrl(TestType type) {
    String url;
    switch (type) {
      case TestType.Test:
        url = STUDENT_GET_TESTS;
        break;
      case TestType.Champion:
        url = STUDENT_GET_CHAMPIONS;
        break;
      case TestType.Challenge:
        url = STUDENT_GET_CHALLENGE;
        break;
      case TestType.latestTest:
        url = STUDENT_GET_LATEST_TEST;
        break;
    }
    return url;
  }

  ChampionResponseModel? championResponseModel;

  void insertTestLists(TestType type, Response response) {
    List tests = [];
    switch (type) {
      case TestType.Test:
        tests = response.data['tests'];
        studentTestsList = List.generate(tests.length,
            (index) => Test.fromJson(response.data['tests'][index], false));
        noStudentTestsData = false;
        break;
      case TestType.Champion:
        championResponseModel = ChampionResponseModel.fromJson(response.data);
        noStudentChampionData = false;
        break;
      case TestType.Challenge:
        tests = response.data['tests'];
        studentChallengeList = List.generate(tests.length,
            (index) => Test.fromJson(response.data['tests'][index], false));
        noStudentChallengeData = false;
        break;
      case TestType.latestTest:
        tests = response.data['tests'];
        studentLatestTests = List.generate(tests.length,
            (index) => Test.fromJson(response.data['tests'][index], false));
        noLatestTestsData = false;
        break;
    }
  }

  ///
  int? selectedTestIndex;
  int? selectedTestId;

  void changeSelectedTest(int index) {
    selectedTestIndex = index;
    selectedTestId = studentTestsList[selectedTestIndex!].id;
    emit(ChangeTestState());
  }

  ///
  FriendsResponseModel? friendsResponseModel;
  bool noFriendsData = false;

  void getStudentChampionFriends(int testId) async {
    noFriendsData = false;
    emit(StudentFriendLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: STUDENT_GET_CHAMPION_FRIENDS,
        token: studentToken,
        formData: FormData.fromMap({
          'test_id': testId,
        }),
      );
      if (response.data['status']) {
        friendsResponseModel = FriendsResponseModel.fromJson(response.data);
        chooseFriends = List.generate(
            friendsResponseModel!.friends!.friendsData!.length,
            (index) => false);
        noFriendsData = false;
        emit(StudentFriendSuccessState());
      } else {
        noFriendsData = true;
        print(response.data['message']);
        emit(StudentFriendErrorState());
      }
    } catch (e) {
      noFriendsData = true;
      emit(StudentFriendErrorState());
      throw e;
    }
  }

  List<bool> chooseFriends = [];
  List<int> selectedFriendsId = [];

  void chooseFriend(bool value, int index) {
    chooseFriends[index] = value;
    if (value)
      selectedFriendsId
          .add(friendsResponseModel!.friends!.friendsData![index].id!);
    else
      selectedFriendsId.removeAt(index);
    print(selectedFriendsId);
    emit(ChangeTestState());
  }

  ///
  ButtonState championCreateButtonState = ButtonState.idle;

  void createChampion({
    required BuildContext context,
    required test,
    required int testId,
    required List<int> studentIds,
  }) async {
    championCreateButtonState = ButtonState.loading;
    emit(StudentCreateChampionLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: STUDENT_CREATE_CHAMPION_FRIENDS,
        token: studentToken,
        formData: FormData.fromMap({
          'test_id': testId,
          'student_id[]': studentIds,
        }),
      );
      if (response.data['status']) {
        championCreateButtonState = ButtonState.success;
        Future.delayed(
            Duration(milliseconds: 300),
            () => navigateTo(
                context,
                StudentTestQuestion(
                  test: test,
                  isChampion: true,
                )));
        emit(StudentCreateChampionSuccessState());
      } else {
        championCreateButtonState = ButtonState.fail;
        print(response.data['message']);
        emit(StudentCreateChampionErrorState());
      }
    } catch (e) {
      championCreateButtonState = ButtonState.fail;
      emit(StudentCreateChampionErrorState());
      throw e;
    }
  }

  StudentsListResponseModel? championInvitationsModel;

  void getAllInvitations() async {
    try {
      emit(GetAllInvitationsLoadingState());
      championInvitationsModel = await TestServices.getAllMembers();
      if (championInvitationsModel!.status!) {
        emit(GetAllInvitationsSuccessState());
      } else {
        emit(GetAllInvitationsErrorState());
      }
    } catch (e) {
      emit(GetAllInvitationsErrorState());
      throw e;
    }
  }

  HomeworkResponseModel? homeworkResponseModel;
  void getScheduleHomework(String date) async {
    try {
      emit(ScheduleHomeworkLoadingState());
      Response response = await DioHelper.postFormData(
        url: STUDENT_GET_SCHEDULE_HOMEWORK,
        token: studentToken,
        formData: FormData.fromMap({"day": date}),
      );
      if(response.data['status']) {
        homeworkResponseModel = HomeworkResponseModel.fromJson(response.data, true);
        emit(ScheduleHomeworkSuccessState());
      } else {
        emit(ScheduleHomeworkErrorState());
      }
    } catch (e) {
      emit(ScheduleHomeworkErrorState());
      rethrow;
    }
  }
}
