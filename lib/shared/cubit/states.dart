abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeState extends AppStates {}

class ChangeLanguageState extends AppStates {}

class ChangeBottomNavState extends AppStates {}


/// Get Teacher subjects
class GetSubjectsLoadingState extends AppStates {}

class GetSubjectsSuccessState extends AppStates {}

class GetSubjectsErrorState extends AppStates {}

class ChangeSubjectState extends AppStates {}

/// Get Teacher Terms
class GetTermsLoadingState extends AppStates {}

class GetTermsSuccessState extends AppStates {}

class GetTermsErrorState extends AppStates {}

class ChangeTermState extends AppStates {}

/// Get Teacher Stages
class GetStagesLoadingState extends AppStates {}

class GetStagesSuccessState extends AppStates {}

class GetStagesErrorState extends AppStates {}

///
class ChangeStageState extends AppStates {}


class ChangeClassState extends AppStates {}

/// ----------------------------------------------------
/// student

/// Get Subject Teachers
class SubjectTeachersLoadingState extends AppStates {}

class SubjectTeachersSuccessState extends AppStates {}

class SubjectTeachersErrorState extends AppStates {}


/// Get Image
class GetImageSuccessState extends AppStates{}

class NoGetImageState extends AppStates{}

/// Get Friend requests Teachers
class FriendGetLoadingState extends AppStates {}

class FriendGetSuccessState extends AppStates {}

class FriendGetErrorState extends AppStates {}

/// Get Friend requests Teachers
class FriendAcceptAndRejectLoadingState extends AppStates {}

class FriendAcceptAndRejectSuccessState extends AppStates {}

class FriendAcceptAndRejectErrorState extends AppStates {}

/// Get Friend requests Teachers
class GroupFriendWithCodeLoadingState extends AppStates {}

class GroupFriendWithCodeSuccessState extends AppStates {}

class GroupFriendWithCodeErrorState extends AppStates {}

///
class FollowingListLoadingState extends AppStates {}

class FollowingListSuccessState extends AppStates {}

class FollowingListErrorState extends AppStates {}

///
class BestStudentsLoadingState extends AppStates {}

class BestStudentsSuccessState extends AppStates {}

class BestStudentsErrorState extends AppStates {}