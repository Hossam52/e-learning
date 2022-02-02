import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/layout/teacher/teacher_layout.dart';
import 'package:e_learning/models/teacher/test/test_model.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/student_test/student_champion/champion_end_screen.dart';
import 'package:e_learning/modules/test_module/student_test/test_view/student_test_result/student_result_statistics_screen/student_test_result_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_state_button/progress_button.dart';

import 'states.dart';

class TestCubit extends Cubit<TestStates> {
  // Cubit Constructor
  TestCubit() : super(AppInitialState());

  // Cubit methode
  static TestCubit get(context) => BlocProvider.of(context);

  /// Add question method
  List<QuestionDataModel> questionList = [];

  File? questionImage;
  List<File?> answerImages = List.generate(4, (index) => null);

  void addQuestion({
    required bool isEdit,
    int? currentIndex,
    required String questionText,
    List<Choose>? chooseList,
    required int answerIndex,
  }) {
    if (isEdit) {
      questionList[currentIndex!] = QuestionDataModel(
        questionText: questionText,
        questionImage: questionImage,
        chooseList: chooseList,
        answerIndex: answerIndex,
      );
    } else {
      questionList.add(
        QuestionDataModel(
          questionText: questionText,
          questionImage: questionImage,
          chooseList: chooseList,
          answerIndex: answerIndex,
        ),
      );
    }
    print(questionList.last.questionImage);
    print(questionList.last.chooseList!.first.chooseImage);
    emit(TestChangeState());
  }

  /// Teacher Add Test methods
  int answerNumber = 2;

  void addAnswer() {
    if (answerNumber < 4) {
      answerNumber++;
    }
    emit(TestChangeState());
  }

  /// Add correct answer
  int? correctAnswerIndex;
  bool hasAnswer = false;

  void onChangeCorrectAnswer(int answerIndex) {
    correctAnswerIndex = correctAnswerIndex != null ? null : answerIndex;
    hasAnswer = !hasAnswer;
    print(correctAnswerIndex);
    emit(TestChangeState());
  }

  ///______________________________________________________________________
  /// get image
  final imagePicker = ImagePicker();
  File? imageFile;
  String? imageName;
  bool isImageAdded = false;

  Future<void> getImage(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);
    imageFile = null;
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      imageName = imageFile!.path.split('/').last;
      isImageAdded = true;
      emit(GetImageSuccessState());
    } else {
      isImageAdded = false;
      showToast(state: ToastStates.WARNING, msg: 'No Image Selected ...');
      print('No Image Selected ...');
      emit(NoGetImageState());
    }
  }

  /// Add image method
  void addImageDataMethod(bool isQuestion, int? index) {
    if (isImageAdded) {
      if (isQuestion) {
        questionImage = imageFile;
      } else {
        answerImages[index!] = imageFile;
        print(answerImages);
      }
      emit(TestChangeState());
    }
  }

  /// remove image data method
  void removeImageDataMethod(bool isQuestion, int? index) {
    if (isQuestion) {
      questionImage = null;
    } else {
      answerImages[index!] = null;
    }
    print(answerImages);
    emit(TestChangeState());
  }

  /// Add Test method
  TestResponseModel? testResponseModel;
  ButtonState uploadTestButtonState = ButtonState.idle;

  void addTestMethod({
    required TestDataModel testDataModel,
    required bool isEdit,
    required BuildContext context,
    int? groupId,
    int? testId,
  }) async {
    uploadTestButtonState = ButtonState.loading;
    emit(AddTestLoadingState());
    try {
      FormData formData = await generateTestFormData(testDataModel, groupId: groupId, testId: testId);
      Response response = await DioHelper.postFormData(
        url: groupId != null ? TEACHER_ADD_HOMEWORK : isEdit ? TEACHER_EDIT_TEST : TEACHER_ADD_TEST,
        token: teacherToken,
        formData: formData,
      );
      print(response);
      if (response.data['status']) {
        testResponseModel = TestResponseModel.fromJson(response.data, true);
        uploadTestButtonState = ButtonState.success;
        emit(AddTestSuccessState());
        Future.delayed(Duration(seconds: 1), () {
          navigateToAndFinish(context, TeacherLayout());
        });
      } else {
        showSnackBar(context: context, text: response.data['message']);
        uploadTestButtonState = ButtonState.fail;
        emit(AddTestErrorState());
      }
    } catch (error) {
      uploadTestButtonState = ButtonState.fail;
      emit(AddTestErrorState());
      throw error;
    }
  }

  List generateChooseTextList(
      List<QuestionDataModel> questionDataModel, int currentIndex) {
    List<String?> chooseTextList = [];
    questionDataModel.forEach((element) {
      chooseTextList.add(element.chooseList!.asMap().containsKey(currentIndex)
          ? element.chooseList![currentIndex].chooseText
          : '');
    });

    print(chooseTextList);
    return chooseTextList;
  }

  Future<List> generateChooseImageList(
      List<QuestionDataModel> questionDataModel, int currentIndex) async {
    File file = await _localFile;
    List<MultipartFile> chooseImageList = [];
    questionDataModel.forEach((element) {
      if (element.chooseList!.asMap().containsKey(currentIndex)) {
        chooseImageList.add(element.chooseList![currentIndex].chooseImage !=
                null
            ? MultipartFile.fromFileSync(
                element.chooseList![currentIndex].chooseImage!.path,
                filename: element.chooseList![currentIndex].chooseImage!.path
                    .split('/')
                    .last)
            : MultipartFile.fromFileSync(file.path));
      } else {
        chooseImageList.add(MultipartFile.fromFileSync(file.path));
      }
    });
    return chooseImageList;
  }

  /// Create Dummy file methods
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    File file = await File('$path/counter.txt').writeAsString('0');
    return file;
  }

  ///

  Future<FormData> generateTestFormData(TestDataModel testDataModel, {int? groupId, int? testId}) async {
    File file = await _localFile;
    FormData formData = FormData.fromMap({
      'name': testDataModel.name,
      'stage_id': testDataModel.stageId,
      'classroom_id': testDataModel.classroomId,
      'term_id': testDataModel.termId,
      'subject_id': testDataModel.subjectId,
      'minute_num': testDataModel.minuteNumber,
      if(groupId != null)
        'group_id' : groupId,
      'test_id' : testId,
      'question_text[]': List.generate(testDataModel.questionDataModel.length,
          (index) => testDataModel.questionDataModel[index].questionText),
      'question_image[]': List.generate(
          testDataModel.questionDataModel.length,
          (index) => testDataModel.questionDataModel[index].questionImage !=
                  null
              ? MultipartFile.fromFileSync(
                  testDataModel.questionDataModel[index].questionImage!.path,
                  filename: testDataModel
                      .questionDataModel[index].questionImage!.path
                      .split('/')
                      .last,
                )
              : MultipartFile.fromFileSync(file.path)),
      'chose1_text[]':
          generateChooseTextList(testDataModel.questionDataModel, 0),
      'chose2_text[]':
          generateChooseTextList(testDataModel.questionDataModel, 1),
      'chose3_text[]':
          generateChooseTextList(testDataModel.questionDataModel, 2),
      'chose4_text[]':
          generateChooseTextList(testDataModel.questionDataModel, 3),
      'chose1_image[]':
          await generateChooseImageList(testDataModel.questionDataModel, 0),
      'chose2_image[]':
          await generateChooseImageList(testDataModel.questionDataModel, 1),
      'chose3_image[]':
          await generateChooseImageList(testDataModel.questionDataModel, 2),
      'chose4_image[]':
          await generateChooseImageList(testDataModel.questionDataModel, 3),
      'answer[]': List.generate(testDataModel.questionDataModel.length,
          (index) => testDataModel.questionDataModel[index].answerIndex),
    });
    return formData;
  }

  void changeTestDuration() {
    emit(TestChangeState());
  }

  /// -------------------------------------------------
  /// Get Teacher tests method
  List<Test> teacherTestsList = [];
  bool noTeacherTestsData = false;

  void getTeacherTestsMethod(int subjectId) async {
    teacherTestsList.clear();
    List tests = [];
    emit(GetTeacherTestsLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: TEACHER_GET_TEST_BY_SUBJECT_ID,
        token: teacherToken,
        formData: FormData.fromMap({
          'subject_id': subjectId,
        }),
      );
      if (response.data['status']) {
        tests = response.data['Test'];
        teacherTestsList = List.generate(tests.length,
            (index) => Test.fromJson(response.data['Test'][index], true));
        noTeacherTestsData = false;
        emit(GetTeacherTestsSuccessState());
      } else {
        noTeacherTestsData = true;
        print(response.data['message']);
        emit(GetTeacherTestsErrorState());
      }
    } catch (e) {
      print(e.toString());
      noTeacherTestsData = true;
      emit(GetTeacherTestsErrorState());
    }
  }

  /// Delete Test with id
  void deleteTeacherTestWithId({
    required int testId,
    required BuildContext context,
    required int subjectId,
  }) async {
    emit(TestDeleteLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: TEACHER_DELETE_TEST_WITH_ID,
        token: teacherToken,
        formData: FormData.fromMap({'test_id': testId}),
      );
      if (response.data['status']) {
        getTeacherTestsMethod(subjectId);
        showSnackBar(context: context, text: response.data['message']);
        emit(TestDeleteSuccessState());
      } else {
        emit(TestDeleteErrorState());
        print(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      emit(TestDeleteErrorState());
    }
  }

  /// ---------------------------------------------
  /// Student

  /// Test Timer
  Timer? testStudentTimer;
  Duration maxTestTime = Duration();
  Duration testTime = Duration();
  String testMinutes = '00';
  String testSeconds = '00';
  Color testTimerColor = thirdColor;

  void startTimer({
    required int time,
    required BuildContext context,
    required Test test,
    required bool isChampion,
  }) {
    maxTestTime = Duration(minutes: time);
    testTime = Duration(minutes: time);
    testStudentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (testTime.inSeconds > 0)
        startCountdownTime();
      else
        endStudentTest(context: context, test: test, isChampion: isChampion);
    });
  }

  void startCountdownTime() {
    final seconds = testTime.inSeconds - 1;
    testTime = Duration(seconds: seconds);
    assignTestTimeAndColor();
    emit(TestChangeState());
  }

  // Convert duration
  String twoDigits(int time) => time.toString().padLeft(2, '0');

  // assign test time and timer color
  void assignTestTimeAndColor() {
    testMinutes = twoDigits(testTime.inMinutes.remainder(60));
    testSeconds = twoDigits(testTime.inSeconds.remainder(60));
    if (testTime.inMinutes < 5 && testTime.inMinutes > 2)
      testTimerColor = Colors.orangeAccent;
    else if (testTime.inMinutes < 2) testTimerColor = errorColor;
  }

  /// Test Answer Method

  List<String?> studentChooseAnswerList = [];

  void initStudentTestAnswerList(int length) {
    studentChooseAnswerList = List.generate(length, (index) => null);
  }

  void onChangeTestAnswer(String value, int index) {
    studentChooseAnswerList[index] = value;
    print(studentChooseAnswerList);
    emit(TestChangeState());
  }

  /// Student question navigation
  PageController studentQuestionController = PageController();
  int studentCurrentIndex = 0;

  void navigateStudentToNextQuestion({required bool isNext}) {
    final int addNumber = isNext ? 1 : -1;
    studentCurrentIndex = studentCurrentIndex + addNumber;
    studentQuestionController.animateToPage(
      studentCurrentIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    emit(TestChangeState());
  }

  ///
  void endStudentTest(
      {required BuildContext context, required Test test, required isChampion}) async {
    final progress = ProgressHUD.of(context);
    testStudentTimer!.cancel();
    correctionStudentTest(test.questions!);
    sendStudentResult(
      context: context,
      isChampion: isChampion,
      test: test,
      result: correctAnswersCount,
      elapsedTime: elapsedTime,
      progress: progress,
    );
  }

  ///
  Map<int, bool> testCorrectionStudent = {};

  int correctAnswersCount = 0;
  int wrongAnswersCount = 0;
  int elapsedTime = 0;
  List<int> wrongQuestionsIndex = [];

  void correctionStudentTest(List<Question> questions) {
    testCorrectionStudent.clear();
    wrongQuestionsIndex.clear();
    elapsedTime = maxTestTime.inMinutes - testTime.inMinutes;
    addTestResults(questions);
  }

  void addTestResults(List<Question> questions) {
    List correctAnswersList = [];
    List wrongAnswersList = [];
    for (int i = 0; i < studentChooseAnswerList.length; i++) {
      var question = questions[i];
      testCorrectionStudent.addAll({
        i: question.answer == studentChooseAnswerList[i] ? true : false,
      });
    }
    testCorrectionStudent.forEach((key, value) {
      if (value == true)
        correctAnswersList.add(value);
      else {
        wrongAnswersList.add(value);
        wrongQuestionsIndex.add(key);
      }
    });
    correctAnswersCount = correctAnswersList.length;
    wrongAnswersCount = wrongAnswersList.length;
  }

  /// Send results method
  ///
  bool hasStudentEndTestError = false;

  void sendStudentResult({
    required BuildContext context,
    required bool isChampion,
    required Test test,
    required int result,
    required int elapsedTime,
    var progress,
    bool isTryAgain = false,
  }) async {
    if(isTryAgain == false) progress!.show();
    hasStudentEndTestError = false;
    emit(StudentTestEndLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isChampion ? STUDENT_SEND_CHAMPION_RESULT : STUDENT_SEND_TEST_RESULT,
        token: studentToken,
        formData: FormData.fromMap({
          'test_id': test.id,
          'result': result,
          'use_period': elapsedTime.toInt(),
        }),
      );
      print(response.data);
      if (response.data['status']) {
        if(isTryAgain == false) progress.dismiss();
        hasStudentEndTestError = false;
        navigateToAndFinish(
            context,
            isChampion
                ? ChampionEndScreen(testName: test.name!)
                : StudentTestResultScreen(
              test: test,
              cubit: TestCubit.get(context),
            ));
        emit(StudentTestEndSuccessState());
      } else {
        hasStudentEndTestError = true;
        print(response.data['message']);
        emit(StudentTestEndErrorState());
      }
    } catch (e) {
      hasStudentEndTestError = true;
      emit(StudentTestEndErrorState());
      throw e;
    }
  }

  void changeTestCounter(bool isChampion) {
    if(isChampion) {
      challengesCounter = challengesCounter + 1;
      CacheHelper.saveData(key: 'challengesCounter', value: challengesCounter);
    } else {
      testCounter = testCounter + 1;
      CacheHelper.saveData(key: 'testCounter', value: testCounter);
    }
  }
  @override
  Future<void> close() {
    studentQuestionController.dispose();
    return super.close();
  }
}
