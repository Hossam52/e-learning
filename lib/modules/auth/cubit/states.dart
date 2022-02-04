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

class ClassUpdateLoadingState extends AuthStates {}

class ClassUpdateSuccessState extends AuthStates {}

class ClassUpdateErrorState extends AuthStates {}
