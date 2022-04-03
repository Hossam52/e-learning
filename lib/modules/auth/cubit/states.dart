import 'package:e_learning/shared/network/services/firebase_services/firebase_auth.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthChangeState extends AuthStates {}

class ChooseTypeState extends AuthStates {}

class ChangePasswordState extends AuthStates {}

/// ---------------------------------------------------
/// General Apis
class GetAllCountriesAndStagesLoadingState extends AuthStates {}

class GetAllCountriesAndStagesSuccessState extends AuthStates {}

class GetAllCountriesAndStagesErrorState extends AuthStates {}

///
class ChangeCountryState extends AuthStates {}

class ChangeStageState extends AuthStates {}

class ChangeClassState extends AuthStates {}

///
class GetAllSubjectsLoadingState extends AuthStates {}

class GetAllSubjectsSuccessState extends AuthStates {}

class GetAllSubjectsErrorState extends AuthStates {}

///
class ChangeSubjectState extends AuthStates {}

/// ---------------------------------------------------
/// Register

/// Student register
class StudentRegisterLoadingState extends AuthStates {}

class StudentRegisterSuccessState extends AuthStates {}

class StudentRegisterErrorState extends AuthStates {}

/// Teacher register
class TeacherRegisterLoadingState extends AuthStates {}

class TeacherRegisterSuccessState extends AuthStates {}

class TeacherRegisterErrorState extends AuthStates {}

/// Email Verification
class VerifyLoadingState extends AuthStates {}

class VerifySuccessState extends AuthStates {}

class VerifyErrorState extends AuthStates {}

/// Login
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {}

///SocialRegister/Login

class SocialAuthLoadingState extends AuthStates {}

class SocialAuthSuccessState extends AuthStates {}

class SocialAuthErrorState extends AuthStates {}

class LoginState extends AuthStates {}

class RegisterState extends AuthStates {
  SocialUser user;
  RegisterState({
    required this.user,
  });
}

/// Forget Password
class ForgetPasswordLoadingState extends AuthStates {}

class ForgetPasswordSuccessState extends AuthStates {}

class ForgetPasswordErrorState extends AuthStates {}

/// logout states
class LogoutLoadingState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}

class LogoutErrorState extends AuthStates {}

/// Reset Password
class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {}

class ResetPasswordErrorState extends AuthStates {}

/// Get Profile
class GetProfileLoadingState extends AuthStates {}

class GetProfileSuccessState extends AuthStates {}

class GetProfileErrorState extends AuthStates {}

//GET FOLLOWERS LIST
class GetProfileFollowersLoadingState extends AuthStates {}

class GetProfileFollowersSuccessState extends AuthStates {}

class GetProfileFollowersErrorState extends AuthStates {}

class ClassUpdateLoadingState extends AuthStates {}

class ClassUpdateSuccessState extends AuthStates {}

class ClassUpdateErrorState extends AuthStates {}
