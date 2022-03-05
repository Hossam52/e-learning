/// -----------------------------------
/// General Apis

// Countries & stages
const GET_ALL_COUNTRIES = 'Guest/getAllCountries';

// Subjects
const GET_ALL_SUBJECTS = 'Guest/getAllSubjects';

///-----------------------------------------------------------------
/// Student
const STUDENT_REGISTER = 'student/register';

const STUDENT_VERIFY = 'student/VerifyAccount';

const STUDENT_LOGIN = 'student/login';

const STUDENT_FORGET_PASSWORD = 'student/studentForgetPassword';

const STUDENT_RESET_PASSWORD = 'student/studentResetPassword';

const STUDENT_GET_PROFILE = 'student/getProfile';

const STUDENT_GENERAL_GET_PROFILE = 'Guest/getStudentById';

const STUDENT_LOGOUT = 'student/logout';

const STUDENT_EDIT_PROFILE = 'student/updateProfile';

const STUDENT_GET_FRIEND_REQUESTS = 'student/friend/MyFriendRequest';

const STUDENT_ACCEPT_FRIEND_REQUESTS = 'student/friend/AcceptFriend';

const STUDENT_REJECT_FRIEND_REQUESTS = 'student/friend/RejectFriend';

const STUDENT_GET_MY_FRIENDS = 'student/friend/MyFriends';

const STUDENT_ADD_FRIEND_WITH_CODE = 'student/friend/AddFriend';

const STUDENT_REMOVE_FRIEND_WITH_CODE = 'student/friend/RemoveFriend';

const STUDENT_GET_ALL_POSTS = 'student/social/getAllSocail';

const STUDENT_GET_FOLLOWING_LIST = 'student/MYfOllowTeachers';

const STUDENT_GET_TEACHER_IN_SAME_CLASS = 'student/TeacherInSameClassroom';

const STUDENT_TOGGLE_FOLLOW_TEACHER = 'student/toggleFollow';

const STUDENT_SEARCH_IN_TEACHERS = 'student/searchInTeachers';

const STUDENT_CHANGE_CLASS = 'api/student/changeStudentClassroom';

const RATE_TEACHER = 'student/RateTeacher';

/// Home
const STUDENT_GET_SUBJECTS = 'student/getStudenSubjects';

const STUDENT_GET_SUBJECT_FILE_TEACHERS = 'student/whoTechSubject';

const STUDENT_GET_SUBJECT_PLAYLIST_TEACHERS =
    'student/whoUploadPlaylistSubject';

const STUDENT_GET_ALL_NOTIFICATIONS = 'student/getNotifications';

const STUDENT_GET_HIGH_RATED_TEACHERS = 'student/HighRateTecahers';

const STUDENT_GET_BEST_STUDENTS = 'Guest/getBestsStudents';

const STUDENT_SEARCH = 'student/searchInGroup';

/// Files Module
const STUDENT_GET_SUBJECT_FILES = 'student/getFileBySubTec';

/// Videos Module
const STUDENT_GET_SUBJECT_PLAYLISTS = 'student/getPlayListBySubTec';

/// Test Module
const STUDENT_GET_TESTS = 'student/getAllTests';

const STUDENT_SEND_TEST_RESULT = 'student/saveResult';

const STUDENT_GET_ALL_INVITATIONS = 'student/champion/allIvitationForChampion';

const STUDENT_GET_TEST_BY_TEACHER_ID = 'student/getAllTestsByTeacherID';

const STUDENT_GET_LATEST_TEST = 'student/getLatestTestsInClassroom';

const STUDENT_GET_SCHEDULE_HOMEWORK =
    'student/homework/getHomeworkForAllGroups';

/// Champion module
const STUDENT_GET_CHAMPIONS = 'student/champion/AllChampion';

const STUDENT_GET_CHAMPION_FRIENDS = 'student/champion/AvFriendsToChampiaon';

const STUDENT_CREATE_CHAMPION_FRIENDS = 'student/champion/Addchampion';

const STUDENT_SEND_CHAMPION_RESULT = 'student/champion/saveChampionResult';

/// Student Challenges
const STUDENT_GET_CHALLENGE = 'student/adminTests/getAdminTests';

/// Group Module
const STUDENT_GET_MY_GROUPS = 'student/group/myGroups';

const STUDENT_GET_DISCOVER_GROUPS = 'student/group/discoverYourGroup';

const STUDENT_TOGGLE_JOIN_GROUPS = 'student/group/ToggleJoinGroup';

const STUDENT_GET_TEACHER_GROUPS = 'student/group/teacherGroups';

const STUDENT_GET_TEACHER_QUESTIONS = 'student/getAllPostsTecherProfile';

/// Posts
const STUDENT_GET_POSTS = 'student/social/getSocail';

const STUDENT_ADD_POST = 'student/social/store';

const STUDENT_EDIT_POST = 'student/social/update';

const STUDENT_DELETE_POST = 'student/social/delete';

const STUDENT_POST_ADD_COMMENT = 'student/comment/store';

const STUDENT_POST_DELETE_COMMENT = 'student/comment/delete';

const STUDENT_POST_EDIT_COMMENT = 'student/comment/update';

const STUDENT_POST_TOGGLE_LIKE = 'student/like/ToggleLike';

const STUDENT_ADD_QUESTION_ON_TEACHER_PROFILE =
    'student/storePostInTeacherProfile';

// Videos
const STUDENT_GET_GROUP_VIDEO = 'student/video/getViseos';

// homework
const STUDENT_GET_GROUP_HOMEWORK = 'student/homework/getHomeworkByGroupId';

/// --------------------------------------------------------------
/// Teacher
const TEACHER_REGISTER = 'teacher/register';

const TEACHER_VERIFY = 'teacher/VerifyAccount';

const TEACHER_LOGIN = 'teacher/login';

const TEACHER_FORGET_PASSWORD = 'teacher/teacherForgetPassword';

const TEACHER_RESET_PASSWORD = 'teacher/teacherResetPassword';

const TEACHER_GET_PROFILE = 'teacher/getProfile';

const TEACHER_GENERAL_GET_PROFILE = 'Guest/getTeacherById';

const TEACHER_LOGOUT = 'teacher/logout';

const TEACHER_EDIT_PROFILE = 'teacher/updateProfile';

/// Home
const TEACHER_GET_SUBJECTS = 'teacher/getMySubjects';

const TEACHER_GET_STAGES = 'teacher/getMyStages';

const TEACHER_GET_TERMS = 'teacher/getMyTerms';

const TEACHER_GET_ALL_NOTIFICATIONS = 'teacher/getNotifications';

///-------------------------------------------------
/// Files Module

// teacher
const TEACHER_POST_FILE = 'teacher/teacherfile/store';

const TEACHER_GET_SUBJECT_FILES = 'teacher/teacherfile/getFilesWithSubjectId';

const TEACHER_DELETE_FILE_WITH_ID = 'teacher/teacherfile/delete';

///-------------------------------------------------
/// Videos Module
// teacher
const TEACHER_ADD_PLAYLIST = 'teacher/playlist/store';

const TEACHER_GET_SUBJECT_PLAYLISTS =
    'teacher/playlist/getPlaylistWithSubjectId';

const TEACHER_DELETE_PLAYLIST_WITH_ID = 'teacher/playlist/delete';

///-------------------------------------------------
/// Test Module
// teacher
const TEACHER_ADD_TEST = 'teacher/test/store';

const TEACHER_EDIT_TEST = 'teacher/test/update';

const TEACHER_GET_TEST_BY_SUBJECT_ID = 'teacher/test/getTestsWithSubjectId';

const TEACHER_DELETE_TEST_WITH_ID = 'teacher/test/delete';

///------------------------------------------------
/// Group Module
///
const TEACHER_CREATE_GROUP = 'teacher/group/store';

const TEACHER_EDIT_GROUP = 'teacher/group/update';

const TEACHER_GET_GROUPS = 'teacher/group/getTeacherGroup';

const TEACHER_DELETE_GROUP = 'teacher/group/delete';

///
const TEACHER_ADD_POST = 'teacher/social/store';

const TEACHER_DELETE_POST = 'teacher/social/delete';

const TEACHER_EDIT_POST = 'teacher/social/update';

// posts urls
const TEACHER_GET_POSTS = 'teacher/social/getSocail';

const TEACHER_POST_TOGGLE_LIKE = 'teacher/like/ToggleLike';

const TEACHER_POST_ADD_COMMENT = 'teacher/comment/store';

const TEACHER_POST_DELETE_COMMENT = 'teacher/comment/delete';

const TEACHER_POST_EDIT_COMMENT = 'teacher/comment/update';

// group videos
const TEACHER_ADD_GROUP_VIDEO = 'teacher/video/store';

const TEACHER_GET_GROUP_VIDEO = 'teacher/video/getViseos';

const TEACHER_DELETE_GROUP_VIDEO = 'teacher/video/delete';

// group members
const ADD_STUDENT_WITH_CODE = 'teacher/group/AddStudentToGroup';

const REMOVE_STUDENT_WITH_CODE = 'teacher/group/RemoveStudentToGroup';

const GET_ALL_STUDENTS_IN_GROUP = 'teacher/group/getStudentInGroup';

// Group homework
const TEACHER_ADD_HOMEWORK = 'teacher/homework/store';

const TEACHER_GET_GROUP_HOMEWORK = 'teacher/homework/getHomeworkByGroupId';

const TEACHER_DELETE_GROUP_HOMEWORK = 'teacher/homework/delete';

/// ------------------------------------------------------------
/// Admin

/// public group
const PUBLIC_GROUP_INFO = 'student/publicGroup/myPublicGroup';

const PUBLIC_GET_POSTS = 'student/publicGroup/getPublicPosts';

const TEACHER_PROFILE_GET_ALL_POST = 'teacher/social/getAllPosts';

const TEACHER_PROFILE_GET_ALL_QUESTION = 'teacher/getAllQuestionInMyProfile';
