abstract class StudentStates {}

class AppInitialState extends StudentStates {}

class AppChangeState extends StudentStates {}

/// Get Friend requests Teachers
class FriendGetLoadingState extends StudentStates {}

class FriendGetSuccessState extends StudentStates {}

class FriendGetErrorState extends StudentStates {}

/// Get Friend requests Teachers
class FriendAcceptAndRejectLoadingState extends StudentStates {}

class FriendAcceptAndRejectSuccessState extends StudentStates {}

class FriendAcceptAndRejectErrorState extends StudentStates {}

/// Get Friend requests Teachers
class GroupFriendWithCodeLoadingState extends StudentStates {}

class GroupFriendWithCodeSuccessState extends StudentStates {}

class GroupFriendWithCodeErrorState extends StudentStates {}

/// Get My following List
class FollowingListLoadingState extends StudentStates {}

class FollowingListSuccessState extends StudentStates {}

class FollowingListErrorState extends StudentStates {}

///
class ToggleFollowLoadingState extends StudentStates {}

class ToggleFollowSuccessState extends StudentStates {}

class ToggleFollowErrorState extends StudentStates {}

///
class SearchInTeachersLoadingState extends StudentStates {}

class SearchInTeachersSuccessState extends StudentStates {}

class SearchInTeachersErrorState extends StudentStates {}

///
class SearchStudentLoadingState extends StudentStates {}

class SearchStudentSuccessState extends StudentStates {}

class SearchStudentNoDataState extends StudentStates {}

class SearchStudentErrorState extends StudentStates {}
