abstract class TestStates {}

class AppInitialState extends TestStates {}

class TestChangeState extends TestStates {}

/// Get Image
class GetImageSuccessState extends TestStates {}

class NoGetImageState extends TestStates {}

/// Add Test States
class AddTestLoadingState extends TestStates {}

class AddTestSuccessState extends TestStates {}

class AddTestErrorState extends TestStates {}

/// Get Teacher Test States
class GetTeacherTestsLoadingState extends TestStates {}

class GetTeacherTestsSuccessState extends TestStates {}

class GetTeacherTestsErrorState extends TestStates {}

/// Get Teacher Test States
class TestDeleteLoadingState extends TestStates {}

class TestDeleteSuccessState extends TestStates {}

class TestDeleteErrorState extends TestStates {}

/// Student
/// Add Test States
class StudentTestEndLoadingState extends TestStates {}

class StudentTestEndSuccessState extends TestStates {}

class StudentTestEndErrorState extends TestStates {}

///
class AddTestDataForEditState extends TestStates {}

class LeaderboardTestLoadingState extends TestStates {}

class LeaderboardTestSuccessState extends TestStates {}

class LeaderboardTestErrorState extends TestStates {}
