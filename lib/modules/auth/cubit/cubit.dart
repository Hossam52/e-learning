import 'package:dio/dio.dart';
import 'package:e_learning/layout/student/student_layout.dart';
import 'package:e_learning/layout/teacher/teacher_layout.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/general_apis/get_all_countries_and_stages_model.dart';
import 'package:e_learning/models/general_apis/subjects_data_model.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/student/auth/student_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_model.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/auth/email_verify/email_verify.dart';
import 'package:e_learning/modules/auth/forget_password/reset_password_screen.dart';
import 'package:e_learning/modules/auth/student/login/student_login_screen.dart';
import 'package:e_learning/modules/auth/teacher/login/teacher_login_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/shared_methods.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_state_button/progress_button.dart';

class AuthCubit extends Cubit<AuthStates> {
  // cubit constructor
  AuthCubit() : super(AuthInitialState());

  // cubit object method
  static AuthCubit get(context) => BlocProvider.of(context);

  // Variables
  bool isTeacher = false;
  bool isStudent = false;
  bool isDisable = true;

  String? selectedFlag;

  bool isSecure = true;
  IconData suffix = Icons.visibility;

  // Introduce screen method
  void chooseTeacherType() {
    isTeacher = true;
    isStudent = false;
    isDisable = false;
    emit(ChooseTypeState());
  }

  void chooseStudentType() {
    isTeacher = false;
    isStudent = true;
    isDisable = false;
    emit(ChooseTypeState());
  }

  void resetAccountType() {
    isStudent = false;
    isTeacher = false;
    isDisable = true;
  }

  // Change password visibility methode
  void changePasswordVisibility() {
    isSecure = !isSecure;
    suffix = isSecure ? Icons.visibility : Icons.visibility_off;

    emit(ChangePasswordState());
  }

  /// --------------------------------------------------
  /// General Apis
  GetAllCountriesAndStagesModel? getAllCountriesAndStagesModel;
  List<String> countryNamesList = [];

  Future<void> getAllCountriesAndStages() async {
    countryNamesList.clear();
    teacherSelectedCountries.clear();
    emit(GetAllCountriesAndStagesLoadingState());

    await DioHelper.getData(
      url: GET_ALL_COUNTRIES,
    ).then((value) {
      if (value.data['status'] == "0") {
        getAllCountriesAndStagesModel =
            GetAllCountriesAndStagesModel.fromJson(value.data);
        getAllCountriesAndStagesModel!.countries!.forEach((element) {
          countryNamesList.add(element.name!);
        });
        emit(GetAllCountriesAndStagesSuccessState());
      } else {
        print(value.data);
        emit(GetAllCountriesAndStagesErrorState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetAllCountriesAndStagesErrorState());
    });
  }

  /// On Change Country method
  String? selectedCountryName;
  int? selectedCountryIndex;
  int? selectedCountryId;
  List stagesNamesList = [];
  List<String> teacherSelectedCountries = [];

  void onChangeCountry(dynamic value) {
    stagesNamesList.clear();
    selectedStageName = null;
    selectedCountryIndex =
        countryNamesList.indexWhere((element) => element == value);
    selectedCountryId =
        getAllCountriesAndStagesModel!.countries![(selectedCountryIndex)!].id;
    print(selectedCountryId);
    getAllCountriesAndStagesModel!.countries![(selectedCountryIndex)!].stages!
        .forEach((element) {
      stagesNamesList.add((element.name)!);
    });
    selectedCountryName = value;
    emit(ChangeCountryState());
  }

  /// On Change City method
  String? selectedStageName;
  int? selectedStageIndex;
  int? selectedStageId;
  List<String> classesNameList = [];

  void onChangeStage(dynamic value) {
    classesNameList.clear();
    selectedClassName = null;
    selectedStageIndex =
        stagesNamesList.indexWhere((element) => element == value);
    selectedStageId = getAllCountriesAndStagesModel!
        .countries![(selectedCountryIndex)!].stages![(selectedStageIndex)!].id;
    print(selectedStageId);
    getAllCountriesAndStagesModel!.countries![(selectedCountryIndex)!]
        .stages![(selectedStageIndex)!].classrooms!
        .forEach((element) {
      classesNameList.add(element.name!);
    });
    selectedStageName = value;
    emit(ChangeStageState());
  }

  /// on Change Classes Method
  String? selectedClassName;
  int? selectedClassIndex;
  int? selectedClassId;

  void onChangeClass(dynamic value) {
    selectedClassIndex =
        classesNameList.indexWhere((element) => element == value);
    print(classesNameList);
    selectedClassId = getAllCountriesAndStagesModel!
        .countries![(selectedCountryIndex)!]
        .stages![(selectedStageIndex)!]
        .classrooms![selectedClassIndex!]
        .id;
    print(selectedClassId);
    selectedClassName = value;
    emit(ChangeClassState());
  }

  /// Subjects
  SubjectsDataModel? subjectsDataModel;
  List<String> subjectsNamesList = [];

  void getAllSubjectsData() async {
    subjectsNamesList.clear();
    selectedSubjectsId.clear();
    emit(GetAllSubjectsLoadingState());

    await DioHelper.getData(
      url: GET_ALL_SUBJECTS,
    ).then((value) {
      if (value.data['status'] == "0") {
        subjectsDataModel = SubjectsDataModel.fromJson(value.data);
        subjectsDataModel!.subjects!.forEach((element) {
          subjectsNamesList.add(element.name!);
        });
        emit(GetAllSubjectsSuccessState());
      } else {
        print(value.data);
        emit(GetAllSubjectsErrorState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetAllSubjectsErrorState());
    });
  }

  /// onChange Subject Method
  List<String> selectedSubjectsList = [];
  int? selectedSubjectIndex;
  List<int> selectedSubjectsId = [];

  void onChangeSubject(dynamic value, bool selected) {
    selectedSubjectIndex =
        subjectsNamesList.indexWhere((element) => element == value);
    if (selected) {
      selectedSubjectsList.add(value);
      selectedSubjectsId
          .add(subjectsDataModel!.subjects![(selectedSubjectIndex)!].id!);
    } else {
      selectedSubjectsList.removeWhere((String name) {
        return name == value;
      });
      selectedSubjectsId.removeWhere((element) =>
          element == subjectsDataModel!.subjects![(selectedSubjectIndex)!].id!);
    }
    print(selectedSubjectsId);
    print(selectedSubjectsList);
    emit(ChangeSubjectState());
  }

  /// --------------------------------------------------------------------
  /// register method
  /// Student
  bool isStudentRegisterLoading = false;
  ButtonState studentRegisterState = ButtonState.idle;

  void studentRegisterAndEdit({
    required BuildContext context,
    required AuthType type,
    required StudentModel model,
  }) async {
    isStudentRegisterLoading = true;
    studentRegisterState = ButtonState.loading;
    emit(StudentRegisterLoadingState());
    await DioHelper.postFormData(
      url: generateUrlStudent(type),
      token: type == AuthType.Edit ? studentToken : null,
      formData: generateFormDataStudent(type, model),
    ).then((value) {
      print(value.data);
      isStudentRegisterLoading = false;
      if (value.data['status']) {
        studentRegisterState = ButtonState.success;
        if (type == AuthType.Register)
          navigateToAndFinish(
              context,
              EmailVerifyScreen(
                email: model.email,
                isStudent: true,
              ));
        emit(StudentRegisterSuccessState());
      } else {
        studentRegisterState = ButtonState.fail;
        showSnackBar(
            context: context,
            text: value.data['errors'],
            backgroundColor: errorColor);
        emit(StudentRegisterErrorState());
      }
    }).catchError((error) {
      studentRegisterState = ButtonState.fail;
      isStudentRegisterLoading = false;
      print(error.toString());
      emit(StudentRegisterErrorState());
    });
  }

  String generateUrlStudent(AuthType type) {
    String url;
    switch (type) {
      case AuthType.Register:
        url = STUDENT_REGISTER;
        break;
      case AuthType.Edit:
        url = STUDENT_EDIT_PROFILE;
        break;
    }
    return url;
  }

  FormData generateFormDataStudent(AuthType type, StudentModel model) {
    FormData formData;
    switch (type) {
      case AuthType.Register:
        formData = FormData.fromMap({
          'name': model.name,
          'email': model.email,
          'password': model.password,
          'password_confirmation': model.passwordConfirmation,
          'country_id': model.countryId,
          'classroom_id': model.classroomId,
        });
        break;
      case AuthType.Edit:
        formData = FormData.fromMap({
          'name': model.name,
          'country_id': model.countryId,
          'classroom_id': model.classroomId,
          'avatar': model.avatar != null
              ? MultipartFile.fromFileSync(model.avatar!.path)
              : null,
        });
        break;
    }
    return formData;
  }

  /// ---------------------------------------------------------------
  /// Teacher
  bool isTeacherRegisterLoading = false;
  ButtonState teacherRegisterState = ButtonState.idle;

  void teacherRegisterAndUpdate({
    required BuildContext context,
    required TeacherModel model,
    required AuthType type,
  }) async {
    teacherRegisterState = ButtonState.loading;
    isTeacherRegisterLoading = true;
    emit(TeacherRegisterLoadingState());
    await DioHelper.postFormData(
      url: generateUrlTeacher(type),
      token: type == AuthType.Edit ? teacherToken : null,
      formData: generateFormDataTeacher(type, model),
    ).then((value) {
      print(value.data);
      isTeacherRegisterLoading = false;
      if (value.data['status']) {
        teacherRegisterState = ButtonState.success;
        if (type == AuthType.Register)
          navigateToAndFinish(
              context,
              EmailVerifyScreen(
                email: model.email,
                isStudent: false,
              ));
        emit(TeacherRegisterSuccessState());
      } else {
        teacherRegisterState = ButtonState.fail;
        showSnackBar(
            context: context,
            text: value.data['errors'],
            backgroundColor: errorColor);
        emit(TeacherRegisterErrorState());
      }
    }).catchError((error) {
      teacherRegisterState = ButtonState.fail;
      isTeacherRegisterLoading = false;
      print(error.toString());
      emit(TeacherRegisterErrorState());
    });
  }

  String generateUrlTeacher(AuthType type) {
    String url;
    switch (type) {
      case AuthType.Register:
        url = TEACHER_REGISTER;
        break;
      case AuthType.Edit:
        url = TEACHER_EDIT_PROFILE;
        break;
    }
    return url;
  }

  FormData generateFormDataTeacher(AuthType type, TeacherModel model) {
    FormData formData;
    switch (type) {
      case AuthType.Register:
        formData = FormData.fromMap({
          'name': model.name,
          'email': model.email,
          'password': model.password,
          'password_confirmation': model.passwordConfirmation,
          'country_id': model.countryId,
          'subjects[]': model.subjects,
        });
        break;
      case AuthType.Edit:
        formData = FormData.fromMap({
          'name': model.name,
          'country_id': model.countryId,
          'subjects[]': model.subjects,
          'avatar': model.avatar != null
              ? MultipartFile.fromFileSync(model.avatar!.path)
              : null,
        });
        break;
    }
    return formData;
  }

  /// Email Verification method
  StudentDataModel? studentDataModel;
  TeacherDataModel? teacherDataModel;
  bool isVerifyLoading = false;
  bool hasVerifyError = false;

  void codeVerification({
    required String code,
    required bool isStudent,
    required BuildContext context,
    required DeviceInformation deviceInfo,
  }) async {
    isVerifyLoading = true;
    emit(VerifyLoadingState());

    await DioHelper.postFormData(
      url: isStudent ? STUDENT_VERIFY : TEACHER_VERIFY,
      formData: FormData.fromMap({
        'token': code,
      }),
    ).then((value) {
      print(value.data);
      if (value.data['status']) {
        if (isStudent) {
          studentDataModel = StudentDataModel.fromJson(value.data);
          studentToken = studentDataModel!.token;
          CacheHelper.saveData(key: 'studentToken', value: studentToken);
          print(' token :$studentToken');
        } else {
          teacherDataModel = TeacherDataModel.fromJson(value.data);
          teacherToken = teacherDataModel!.token;
          CacheHelper.saveData(key: 'teacherToken', value: teacherToken);
          print(' token :$teacherToken');
        }

        isVerifyLoading = false;
        hasVerifyError = false;
        defaultDialog(
          context: context,
          deviceInfo: deviceInfo,
          image: Lottie.asset(
            'assets/images/lottie/email-sent.json',
            width: 250.w,
          ),
          text:
              'تهانينا ، تم التحقق من بريدك الإلكتروني. يمكنك الآن البدء في استخدام التطبيق.',
          buttonText: 'ابدأ الان',
          onPressed: () {
            if (isStudent) {
              navigateToAndFinish(context, StudentLayout());
            } else {
              navigateToAndFinish(context, TeacherLayout());
            }
          },
        );
      } else {
        hasVerifyError = true;
        isVerifyLoading = false;
      }
      emit(VerifySuccessState());
    }).catchError((error) {
      isVerifyLoading = false;
      print(error.toString());
      emit(VerifyErrorState());
    });
  }

  /// Login Method (both)
  StudentDataModel? studentLoginDataModel;
  TeacherDataModel? teacherLoginDataModel;
  bool isLoginLoading = false;
  ButtonState loginButtonState = ButtonState.idle;

  void login({
    required bool isStudent,
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    isLoginLoading = true;
    loginButtonState = ButtonState.loading;
    emit(LoginLoadingState());
    await DioHelper.postFormData(
      url: isStudent ? STUDENT_LOGIN : TEACHER_LOGIN,
      formData: FormData.fromMap({
        'email': email,
        'password': password,
        'device_token': await SharedMethods.getToken()
      }),
    ).then((value) {
      print(value.data);
      isLoginLoading = false;
      if (value.data['status']) {
        loginButtonState = ButtonState.success;
        if (isStudent) {
          studentLoginDataModel = StudentDataModel.fromJson(value.data);
          studentProfileModel = StudentDataModel.fromJson(value.data);
          studentToken = studentLoginDataModel!.token;
          CacheHelper.saveData(key: 'studentToken', value: studentToken);
          print(' token :$studentToken');
          Future.delayed(
            Duration(seconds: 1),
            () {
              navigateToAndFinish(context, StudentLayout());
              loginButtonState = ButtonState.idle;
            },
          );
        } else {
          teacherProfileModel =
              teacherLoginDataModel = TeacherDataModel.fromJson(value.data);
          teacherToken = teacherLoginDataModel!.token;
          CacheHelper.saveData(key: 'teacherToken', value: teacherToken);
          print(' token :$teacherToken');
          Future.delayed(
            Duration(seconds: 1),
            () {
              navigateToAndFinish(context, TeacherLayout());
            },
          );
        }
        emit(LoginSuccessState());
      } else {
        loginButtonState = ButtonState.fail;
        showSnackBar(
            context: context,
            text: value.data['errors'],
            backgroundColor: errorColor);
        emit(LoginErrorState());
      }
    }).catchError((error) {
      loginButtonState = ButtonState.fail;
      isLoginLoading = false;
      print(error.toString());
      emit(LoginErrorState());
    });
  }

  void resetLoginButtonToIdleState() {
    loginButtonState = ButtonState.idle;
  }

  /// Forget Password
  bool forgetPasswordLoading = false;

  void forgetPassword({
    required bool isStudent,
    required String email,
    required BuildContext context,
  }) async {
    forgetPasswordLoading = true;
    emit(ForgetPasswordLoadingState());
    await DioHelper.postFormData(
      url: isStudent ? STUDENT_FORGET_PASSWORD : TEACHER_FORGET_PASSWORD,
      formData: FormData.fromMap({
        'email': email,
      }),
    ).then((value) {
      print(value.data);
      if (value.data['status']) {
        forgetPasswordLoading = false;
        navigateTo(
            context,
            ResetPasswordScreen(
              isStudent: isStudent,
            ));
        emit(ForgetPasswordSuccessState());
      } else {
        forgetPasswordLoading = false;
        showSnackBar(context: context, text: '${value.data['message']}');
        emit(ForgetPasswordErrorState());
      }
    }).catchError((error) {
      forgetPasswordLoading = false;
      print(error.toString());
      emit(ForgetPasswordErrorState());
    });
  }

  /// Logout method
  Future<Response> logoutMethod(bool isStudent) async {
    try {
      emit(LogoutLoadingState());
      Response response = await DioHelper.postData(
        url: isStudent ? STUDENT_LOGOUT : TEACHER_LOGOUT,
        token: isStudent ? studentToken : teacherToken,
        data: {},
      );
      print(response.data);
      emit(LogoutSuccessState());
      return response;
    } catch (e) {
      emit(LogoutErrorState());
      throw e;
    }
  }

  /// Reset password
  bool resetPasswordLoading = false;
  ButtonState resetPasswordButtonState = ButtonState.idle;

  void resetPassword({
    required BuildContext context,
    required bool isStudent,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    resetPasswordButtonState = ButtonState.loading;
    resetPasswordLoading = true;
    emit(ResetPasswordLoadingState());
    DioHelper.postFormData(
      url: isStudent ? STUDENT_RESET_PASSWORD : TEACHER_RESET_PASSWORD,
      formData: FormData.fromMap({
        'token': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    ).then((value) {
      print(value.data);
      if (value.data['status']) {
        resetPasswordButtonState = ButtonState.success;
        resetPasswordLoading = false;
        Future.delayed(
          Duration(seconds: 1),
          () {
            navigateToAndFinish(context,
                isStudent ? StudentLoginScreen() : TeacherLoginScreen());
          },
        );
        emit(ResetPasswordSuccessState());
      } else {
        resetPasswordButtonState = ButtonState.fail;
        resetPasswordLoading = false;
        showSnackBar(context: context, text: '${value.data['message']}');
        emit(ResetPasswordErrorState());
      }
    }).catchError((error) {
      resetPasswordButtonState = ButtonState.fail;
      resetPasswordLoading = false;
      print(error.toString());
      emit(ResetPasswordErrorState());
    });
  }

  /// Get Profile Method
  TeacherDataModel? teacherProfileModel;
  StudentDataModel? studentProfileModel;
  bool noProfileData = false;
  bool profileDataLoading = false;

  Future<void> getProfile(bool isStudent) async {
    try {
      profileDataLoading = true;
      noProfileData = false;
      emit(GetProfileLoadingState());
      Response response = await DioHelper.getData(
        url: isStudent ? STUDENT_GET_PROFILE : TEACHER_GET_PROFILE,
        token: isStudent ? studentToken : teacherToken,
      );
      addProfileData(
          response: response, isStudent: isStudent, isGeneral: false);
    } catch (e) {
      noProfileData = true;
      emit(GetProfileErrorState());
      throw e;
    } finally {
      profileDataLoading = false;
      emit(AuthChangeState());
    }
  }

  /// Get Profile by id
  void getProfileById(int id, bool isStudent) async {
    try {
      emit(GetProfileLoadingState());
      Response response = await DioHelper.postFormData(
        url: isStudent
            ? STUDENT_GENERAL_GET_PROFILE
            : TEACHER_GENERAL_GET_PROFILE,
        formData: FormData.fromMap(
            {if (isStudent) 'student_id': id else 'teacher_id': id}),
      );
      addProfileData(response: response, isStudent: isStudent, isGeneral: true);
    } catch (e) {
      emit(GetProfileErrorState());
      print(e.toString());
    }
  }

  void addProfileData({
    required Response response,
    required bool isStudent,
    required bool isGeneral,
  }) {
    if (response.data['status']) {
      if (isStudent) {
        studentProfileModel = StudentDataModel.fromJson(response.data);
        if (isGeneral == false)
          changeAuthType(studentProfileModel!.authType ?? false);
      } else {
        teacherProfileModel = TeacherDataModel.fromJson(response.data);
        if (isGeneral == false)
          changeAuthType(teacherProfileModel!.teacher!.authType ?? false);
      }
      noProfileData = false;
      emit(GetProfileSuccessState());
    } else {
      noProfileData = true;
      emit(GetProfileErrorState());
    }
  }

  void changeAuthType(bool value) {
    authType = value;
    if (authType == false) {
      if (date != null) {
        if (validateAuthTypeDate(date!) == false) {
          initAuthTypeVariables();
        }
      } else {
        initAuthTypeVariables();
      }
    }
  }

  bool validateAuthTypeDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays >= 1) {
      return false;
    } else {
      return true;
    }
  }

  void initAuthTypeVariables() {
    CacheHelper.saveData(key: 'date', value: DateTime.now().toString());
    CacheHelper.saveData(key: 'testCounter', value: 0);
    CacheHelper.saveData(key: 'challengesCounter', value: 0);
    CacheHelper.saveData(key: 'filesCounter', value: 0);
    date = DateTime.now().toString();
    testCounter = 0;
    challengesCounter = 0;
    filesCounter = 0;
  }

  bool isUpdateClassLoading = false;

  void updateStudentClass(id) async {
    try {
      isUpdateClassLoading = true;
      emit(ClassUpdateLoadingState());
      Response response = await DioHelper.postFormData(
        url: STUDENT_CHANGE_CLASS,
        token: studentToken,
        formData: FormData.fromMap({
          'classroom_id': id,
        }),
      );
      if (response.data['status']) {
        emit(ClassUpdateSuccessState());
      } else {
        emit(ClassUpdateErrorState());
      }
    } catch (e) {
      emit(ClassUpdateErrorState());
      rethrow;
    } finally {
      isUpdateClassLoading = false;
      emit(AuthChangeState());
    }
  }
}
