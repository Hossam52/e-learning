abstract class GroupStates {}

class AppInitialState extends GroupStates {}

class GroupChangeState extends GroupStates {}

class PostImageState extends GroupStates {}

/// --------------------------------
/// Teacher

// Create group states
class GroupCreateLoadingState extends GroupStates {}

class GroupCreateSuccessState extends GroupStates {}

class GroupCreateErrorState extends GroupStates {}

// Get groups states
class GroupsTeacherGetLoadingState extends GroupStates {}

class GroupsTeacherGetSuccessState extends GroupStates {}

class GroupsTeacherGetErrorState extends GroupStates {}

// Get public groups states
class PublicGroupsTeacherGetLoadingState extends GroupStates {}

class PublicGroupsTeacherGetSuccessState extends GroupStates {}

class PublicGroupsTeacherGetErrorState extends GroupStates {}

// Add teacher post states
class AddPostLoadingState extends GroupStates {}

class AddPostSuccessState extends GroupStates {
  String? message;
  AddPostSuccessState({this.message});
}

class AddPostErrorState extends GroupStates {}

// Get teacher post states
class GroupGetPostLoadingState extends GroupStates {}

class GroupGetPostSuccessState extends GroupStates {}

class GroupGetPostErrorState extends GroupStates {}

// Get teacher video states
class GroupGetVideoAndMembersLoadingState extends GroupStates {}

class GroupGetVideoAndMembersSuccessState extends GroupStates {}

class GroupGetVideoAndMembersErrorState extends GroupStates {}

// Add Student to group with code states
class GroupAddStudentWithCodeLoadingState extends GroupStates {}

class GroupAddStudentWithCodeSuccessState extends GroupStates {}

class GroupAddStudentWithCodeErrorState extends GroupStates {}

// Get teacher video states
class GroupGetHomeworkLoadingState extends GroupStates {}

class GroupGetHomeworkSuccessState extends GroupStates {}

class GroupGetHomeworkErrorState extends GroupStates {}

// Delete teacher Group method states
class GroupGeneralDeleteLoadingState extends GroupStates {}

class GroupGeneralDeleteSuccessState extends GroupStates {}

class GroupGeneralDeleteErrorState extends GroupStates {}

// Delete teacher Group method states
class GroupToggleLikeLoadingState extends GroupStates {}

class GroupToggleLikeSuccessState extends GroupStates {}

class GroupToggleLikeErrorState extends GroupStates {}

// Delete teacher Group method states
class GroupAddCommentLoadingState extends GroupStates {}

class GroupAddCommentSuccessState extends GroupStates {}

class GroupAddCommentErrorState extends GroupStates {}

/// ------------------------------------------------
/// Student
class GroupStudentToggleJoinLoadingState extends GroupStates {}

class GroupStudentToggleJoinSuccessState extends GroupStates {}

class GroupStudentToggleJoinErrorState extends GroupStates {}

/// Student
class PublicGroupLoadingState extends GroupStates {}

class PublicGroupSuccessState extends GroupStates {}

class PublicGroupErrorState extends GroupStates {}
