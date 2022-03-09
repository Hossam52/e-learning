import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/models/general_apis/subjects_data_model.dart';
import 'package:e_learning/models/student/home/general_apis/students_list_response_model.dart';
import 'package:e_learning/models/student/home/general_apis/teachers_response_model.dart';
import 'package:e_learning/models/student/home/general_apis/who_teach_subject_model.dart';
import 'package:e_learning/models/teacher/general_apis/teacher_stages_model.dart';
import 'package:e_learning/modules/groups/student/groups_screen.dart';
import 'package:e_learning/modules/home_screen/student/student_home_screen.dart';
import 'package:e_learning/modules/profile/student/profile_screen.dart';
import 'package:e_learning/modules/student/schedule/schedule_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppCubit extends Cubit<AppStates> {
  // Cubit Constructor
  AppCubit() : super(AppInitialState());

  // Cubit methode
  static AppCubit get(context) => BlocProvider.of(context);

  // variables
  Locale localeApp = Locale(lang ?? 'ar');

  // Current nav index
  int currentIndex = 0;

  // List of nav screens
  List<Widget> selectedScreens = [
    StudentHomeScreen(),
    GroupScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  String selectedTitle(AppLocalizations text) {
    if (currentIndex == 0)
      return text.home;
    else if (currentIndex == 1)
      return text.my_groups;
    else if (currentIndex == 2)
      return text.my_schedule;
    else
      return text.my_profile;
  }

  // Change nav function
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void changeLocaleApp(String languageCode) {
    if (localeApp.countryCode != languageCode) {
      lang = languageCode;
      localeApp = Locale(languageCode);
      CacheHelper.saveData(key: 'lang', value: languageCode);
      emit(ChangeLanguageState());
    }
  }

  void changeCubitState() {
    emit(AppChangeState());
  }

  /// ----------------------------------------------------
  /// Teacher get all subjects method
  SubjectsDataModel? subjectsModel;
  List<String> subjectNamesList = [];

  void getTeacherAndStudentSubjects(bool isStudent) async {
    subjectNamesList.clear();
    selectedSubjectName = null;
    emit(GetSubjectsLoadingState());
    try {
      Response response = await DioHelper.getData(
        url: isStudent ? STUDENT_GET_SUBJECTS : TEACHER_GET_SUBJECTS,
        token: isStudent ? studentToken : teacherToken,
      );
      if (response.data['status']) {
        subjectsModel = SubjectsDataModel.fromJson(response.data);
        subjectsModel!.subjects!.forEach((element) {
          subjectNamesList.add(element.name!);
        });
        emit(GetSubjectsSuccessState());
      } else {
        print(response.data['message']);
        emit(GetSubjectsErrorState());
      }
    } catch (e) {
      emit(GetSubjectsErrorState());
      throw e;
    }
  }

  /// onChange Subject method

  String? selectedSubjectName;
  int? selectedSubjectIndex;
  int? selectedSubjectId;

  void onSubjectChange(dynamic value) {
    selectedSubjectIndex =
        subjectNamesList.indexWhere((element) => element == value);
    selectedSubjectId = subjectsModel!.subjects![(selectedSubjectIndex)!].id;
    print(selectedSubjectId);
    selectedSubjectName = value;
    emit(ChangeSubjectState());
  }

  /// ----------------------------------------
  /// Teacher get all terms
  SubjectsDataModel? teacherTermsModel;
  List<String> termNamesList = [];
  bool isTermsLoading = false;

  void getTeacherTerms() {
    termNamesList.clear();
    selectedTermName = null;
    selectedTermIndex = null;
    selectedTermId = null;
    isTermsLoading = true;
    emit(GetTermsLoadingState());
    DioHelper.getData(
      url: TEACHER_GET_TERMS,
      token: teacherToken,
    ).then((value) {
      if (value.data['status']) {
        teacherTermsModel = SubjectsDataModel.fromJson(value.data);
        teacherTermsModel!.subjects!.forEach((element) {
          termNamesList.add(element.name!);
        });
        print(termNamesList);
        emit(GetTermsSuccessState());
      } else {
        print(value.statusMessage);
        emit(GetTermsErrorState());
      }
      isTermsLoading = false;
    }).catchError((error) {
      isTermsLoading = false;
      print(error.toString());
      emit(GetTermsErrorState());
    });
  }

  /// onChange Term method

  String? selectedTermName;
  int? selectedTermIndex;
  int? selectedTermId;

  void onTermChange(dynamic value) {
    selectedTermIndex = termNamesList.indexWhere((element) => element == value);
    selectedTermId = teacherTermsModel!.subjects![(selectedTermIndex)!].id;
    print(selectedTermId);
    selectedTermName = value;
    emit(ChangeTermState());
  }

  /// Teacher get Stages method
  TeacherStagesModel? teacherStagesModel;
  List<String> stageNamesList = [];
  bool isStagesLoading = false;

  void getTeacherStages() async {
    stageNamesList.clear();
    classNamesList.clear();
    teacherSelectedStage = null;
    selectedStageIndex = null;
    selectedStageId = null;
    selectedClassName = null;
    isStagesLoading = true;
    emit(GetStagesLoadingState());

    await DioHelper.getData(
      url: TEACHER_GET_STAGES,
      token: teacherToken,
    ).then((value) {
      if (value.data['status']) {
        teacherStagesModel = TeacherStagesModel.fromJson(value.data);
        teacherStagesModel!.student!.forEach((element) {
          stageNamesList.add(element.name!);
        });
        print(stageNamesList);
        emit(GetStagesSuccessState());
      } else {
        print(value.data);
        emit(GetStagesErrorState());
      }
      isStagesLoading = false;
    }).catchError((error) {
      isStagesLoading = false;
      print(error.toString());
      emit(GetStagesErrorState());
    });
  }

  /// OnChange Stage method
  String? teacherSelectedStage;
  int? selectedStageIndex;
  int? selectedStageId;
  List<String> classNamesList = [];

  void onChangeStage(dynamic value) {
    classNamesList.clear();
    selectedClassName = null;
    selectedStageIndex =
        stageNamesList.indexWhere((element) => element == value);
    selectedStageId = teacherStagesModel!.student![(selectedStageIndex)!].id;
    print(selectedStageId);
    teacherStagesModel!.student![(selectedStageIndex)!].classrooms!
        .forEach((element) {
      classNamesList.add((element.name)!);
    });
    teacherSelectedStage = value;
    emit(ChangeStageState());
  }

  /// onChange class method

  String? selectedClassName;
  int? selectedClassIndex;
  int? selectedClassId;

  void onChangeClass(dynamic value) {
    selectedClassIndex =
        classNamesList.indexWhere((element) => element == value);
    selectedClassId = teacherStagesModel!
        .student![(selectedStageIndex)!].classrooms![(selectedClassIndex)!].id;
    print(selectedClassId);
    selectedClassName = value;
    emit(ChangeClassState());
  }

  /// -------------------------------------------------------------
  /// Student'

  /// Get all Category Teacher by subject id
  WhoTeachSubjectModel? whoTeachSubjectModel;
  bool noSubjectTeachersData = false;

  void getAllSubjectTeachers(
    bool isFiles, {
    required int subjectId,
    String? type,
  }) async {
    emit(SubjectTeachersLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isFiles
            ? STUDENT_GET_SUBJECT_FILE_TEACHERS
            : STUDENT_GET_SUBJECT_PLAYLIST_TEACHERS,
        token: studentToken,
        formData: FormData.fromMap({
          'subject_id': subjectId,
          if (isFiles) 'type': type,
        }),
      );
      if (response.data['status']) {
        whoTeachSubjectModel = WhoTeachSubjectModel.fromJson(response.data);
        noSubjectTeachersData = false;
        emit(SubjectTeachersSuccessState());
      } else {
        noSubjectTeachersData = true;
        print(response.data['message']);
        emit(SubjectTeachersErrorState());
      }
    } catch (e) {
      emit(SubjectTeachersErrorState());
      throw e;
    }
  }

  ///______________________________________________________________________
  /// get image
  final imagePicker = ImagePicker();
  File? imageFile;
  String? imageName;

  Future<void> getImage(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);
    imageFile = null;
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      imageName = imageFile!.path.split('/').last;
      emit(GetImageSuccessState());
    } else {
      showToast(state: ToastStates.WARNING, msg: 'No Image Selected ...');
      print('No Image Selected ...');
      emit(NoGetImageState());
    }
  }

  void removeImage() {
    imageFile = null;
    imageName = null;
    emit(AppChangeState());
  }

  Future<File> getFile(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  Future<File> urlToFile(String imageUrl) async {
    File file = await getFile(imageUrl.split('/').last);
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  bool isEdit = false;
  int? commentId;
  int? index;
  List<File> imageFiles = [];
  void exitFocusFromComments() {
    isEdit = false;
    commentId = null;
    index = null;
    imageFiles = [];
  }

  Future<void> addImageFromUrl(String imageUrl,
      {List<String>? imageUrls}) async {
    try {
      imageFiles.clear();
      if (imageUrls != null && imageUrls.isNotEmpty) {
        imageUrls.forEach((element) async {
          File downloadedImageFile = await urlToFile(element);
          imageFiles.add(downloadedImageFile);
          emit(AppChangeState());
        });
      } else if (imageUrl.isNotEmpty) {
        File downloadedImageFile = await urlToFile(imageUrl);
        imageFile = downloadedImageFile;
        emit(AppChangeState());
      } else {
        emit(AppChangeState());
      }
    } catch (e) {
      throw e;
    }
  }

  /// Teacher Follow Module
  TeachersResponseModel? studentHighRateTeachersModel;

  bool isStudentHighRateLoading = false;
  void getHighRateTeachersList(bool isStudent) async {
    try {
      isStudentHighRateLoading = true;

      emit(FollowingListLoadingState());
      Response response = await DioHelper.getData(
        url: isStudent
            ? STUDENT_GET_HIGH_RATED_TEACHERS
            : TEACHER_GET_HIGHEST_RATE_TEACHERS,
        token: isStudent ? studentToken : teacherToken,
      );
      print(response.data);
      if (response.data['status']) {
        studentHighRateTeachersModel =
            TeachersResponseModel.fromJson(response.data);
        isStudentHighRateLoading = false;
        emit(FollowingListSuccessState());
      } else {
        print(response.data);
        studentHighRateTeachersModel =
            TeachersResponseModel(status: false, teachers: Teachers(data: []));
        emit(FollowingListErrorState());
      }
    } catch (e) {
      emit(FollowingListErrorState());
      throw e;
    } finally {
      isStudentHighRateLoading = false;
      emit(AppChangeState());
    }
  }

  /// Teacher Follow Module
  StudentsListResponseModel? bestStudentsModel;
  StudentsListAuthorizedResponseModel? bestStudentsModelAuthorized;
  bool isBestStudentsListLoading = false;
  void getBestStudentsList({bool isStudent = true}) async {
    try {
      isBestStudentsListLoading = true;
      emit(BestStudentsLoadingState());
      Response response =
          await DioHelper.getData(url: STUDENT_GET_BEST_STUDENTS);
      log(response.data.toString());
      if (response.data['status']) {
        isBestStudentsListLoading = false;
        bestStudentsModel = StudentsListResponseModel.fromJson(response.data);
        bestStudentsModel!.students!
            .forEach((element) => log('${element.friendType}'));
        emit(BestStudentsSuccessState());
      } else {
        print(response.data);
        bestStudentsModel = StudentsListResponseModel(
            students: [], message: response.data['message'], status: false);
        emit(BestStudentsErrorState(response.data['message']));
      }
    } catch (e) {
      emit(BestStudentsErrorState('server Error'));
      throw e;
    } finally {
      isBestStudentsListLoading = false;
      emit(AppChangeState());
    }
  }

  void getBestStudentsListAuthorized() async {
    try {
      isBestStudentsListLoading = true;
      emit(BestStudentsLoadingState());
      Response response = await DioHelper.getData(
          url: STUDENT_GET_BEST_STUDENTS_AUTHORIZED, token: studentToken);
      log(response.data.toString());
      if (response.data['status']) {
        isBestStudentsListLoading = false;
        bestStudentsModelAuthorized =
            StudentsListAuthorizedResponseModel.fromJson(response.data);
        bestStudentsModelAuthorized!.students!
            .forEach((element) => log('${element.friendType}'));
        emit(BestStudentsSuccessState());
      } else {
        print(response.data);
        emit(BestStudentsErrorState(response.data['message']));
      }
    } catch (e) {
      emit(BestStudentsErrorState('server error'));
      throw e;
    } finally {
      isBestStudentsListLoading = false;
      emit(AppChangeState());
    }
  }
}
