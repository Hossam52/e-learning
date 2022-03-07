import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/layout/teacher/teacher_layout.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/group/group_student_response_model.dart';
import 'package:e_learning/models/student/teacher_profile_view/teacher_profile_questions.dart';
import 'package:e_learning/models/teacher/groups/group_model.dart';
import 'package:e_learning/models/teacher/groups/homework/homework_response_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/comment_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/group_post_model.dart';
import 'package:e_learning/models/teacher/groups/group_response_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/models/teacher/groups/student_in_group_model/group_members_model.dart';
import 'package:e_learning/models/teacher/groups/videos/group_videos_response_model.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:progress_state_button/progress_button.dart';
import 'states.dart';

class GroupCubit extends Cubit<GroupStates> {
  // Cubit Constructor
  GroupCubit() : super(AppInitialState());

  // Cubit methode
  static GroupCubit get(context) => BlocProvider.of(context);

  TextEditingController controller = TextEditingController();

  /// --------------------------------------------------
  /// Group general methods
  ///

  bool isPostEdit = false;
  int? postId;

  void changeEditPost(bool isEdit, int? id) {
    isPostEdit = isEdit;
    postId = id;
    emit(GroupChangeState());
  }

  void changeState() => emit(GroupChangeState());

  bool isStudentPostEdit = false;
  int? studentPostId;
  void changeStudentEditPost(bool isEdit, int? id) {
    isStudentPostEdit = isEdit;
    studentPostId = id;
    print(isStudentPostEdit);
    print(studentPostId);
    emit(GroupChangeState());
  }

  void changeCubitState() {
    emit(GroupChangeState());
  }

  List<File> selectedImages = [];
  List<Asset> images = [];

  Future<void> loadImages() async {
    selectedImages.clear();
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: authType ? 100 : 2,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "E-learning app",
          doneButtonTitle: "Done",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#4C5FFB",
          actionBarTitle: "E-learning app",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
      convertAssetToFileAndAddToList(resultList);
    } catch (e) {
      showToast(
          msg: 'يوجد خطا من فضلك ادخل الصور مجددا', state: ToastStates.WARNING);
      throw e;
    }
  }

  ///
  void convertAssetToFileAndAddToList(List<Asset> listOfAsset) async {
    for (int index = 0; index < listOfAsset.length; index++) {
      final path = await FlutterAbsolutePath.getAbsolutePath(
          listOfAsset[index].identifier!);
      File tempFile = File(path!);
      selectedImages.add(tempFile);
    }
    emit(PostImageState());
  }

  ///
  void clearImageList() {
    selectedImages.clear();
    emit(PostImageState());
  }

  /// ---------------------------------------------------
  /// Teacher

  String? groupType;

  void onChangeGroupType(dynamic value) {
    groupType = value.toString();
    emit(GroupChangeState());
  }

  ButtonState createGroupButtonState = ButtonState.idle;

  void createGroup({
    required GroupModel groupModel,
    required bool isEdit,
    required BuildContext context,
  }) async {
    createGroupButtonState = ButtonState.loading;
    emit(GroupCreateLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isEdit ? TEACHER_EDIT_GROUP : TEACHER_CREATE_GROUP,
        token: teacherToken,
        formData: FormData.fromMap({
          'title': groupModel.title,
          'stage_id': groupModel.stageId,
          'classroom_id': groupModel.classroomId,
          'term_id': groupModel.termId,
          'subject_id': groupModel.subjectId,
          'description': groupModel.description,
          'type': groupModel.type,
          if (isEdit) 'group_id': groupModel.groupId,
        }),
      );
      if (response.data['status']) {
        createGroupButtonState = ButtonState.success;
        navigateToAndFinish(context, TeacherLayout());
        emit(GroupCreateSuccessState());
      } else {
        createGroupButtonState = ButtonState.fail;
        showSnackBar(
            context: context,
            text: response.data['message'],
            backgroundColor: errorColor);
        createGroupButtonState = ButtonState.fail;
      }
    } catch (e) {
      createGroupButtonState = ButtonState.fail;
      throw e;
    }
  }

  ///
  GroupResponseModel? groupResponseModel;
  GroupsStudentResponse? groupsStudentResponse;
  GroupResponseModel? groupsPublicTeacher;
  List<Group> myGroups = [];
  List<Group> discoverGroups = [];
  bool noGroupsData = false;
  Map<int, bool> joinedGroupMap = {};

  Future<void> getPublicGroupsForTeacher() async {
    emit(PublicGroupsTeacherGetLoadingState());
    try {
      final response = await DioHelper.getData(
          url: TEACHER_GET_PUBLIC_GROUPS, token: teacherToken);
      if (response.data['status']) {
        groupsPublicTeacher = GroupResponseModel.fromJson(response.data);
        emit(PublicGroupsTeacherGetSuccessState());
      } else {
        noGroupsData = true;
        emit(PublicGroupsTeacherGetSuccessState());
      }
    } catch (e) {
      emit(PublicGroupsTeacherGetErrorState());
      throw e;
    }
  }

  void getMyGroups(bool isStudent, GroupType type) async {
    myGroups.clear();
    discoverGroups.clear();
    noGroupsData = false;
    emit(GroupsTeacherGetLoadingState());
    try {
      Response response = await DioHelper.getData(
        url: generateGroupUrl(type),
        token: isStudent ? studentToken : teacherToken,
      );
      if (response.data['status']) {
        if (type == GroupType.Discover)
          groupsStudentResponse = GroupsStudentResponse.fromJson(response.data);
        else
          groupResponseModel = GroupResponseModel.fromJson(response.data);
        noGroupsData = false;
        generateGroupList(type);
        emit(GroupsTeacherGetSuccessState());
      } else {
        print(response.data['message']);
        noGroupsData = true;
        emit(GroupsTeacherGetErrorState());
      }
    } catch (e) {
      noGroupsData = true;
      emit(GroupsTeacherGetErrorState());
      throw e;
    }
  }

  String generateGroupUrl(GroupType type) {
    String url;
    switch (type) {
      case GroupType.Teacher:
        url = TEACHER_GET_GROUPS;
        break;
      case GroupType.Student:
        url = STUDENT_GET_MY_GROUPS;
        break;
      case GroupType.Discover:
        url = STUDENT_GET_DISCOVER_GROUPS;
        break;
    }
    return url;
  }

  void generateGroupList(GroupType type) {
    switch (type) {
      case GroupType.Teacher:
        break;
      case GroupType.Student:
        myGroups = groupResponseModel!.groups!;
        break;
      case GroupType.Discover:
        discoverGroups = groupsStudentResponse!.groups!.groupsData!;
        discoverGroups.forEach((element) {
          joinedGroupMap.addAll({element.id!: element.isJoined!});
        });
        break;
    }
  }

  /// In Group-view
  PostResponseModel? teacherPostResponseModel;

  Future<void> addPostAndQuestion(
    GroupPostModel model, {
    required bool isStudent,
    required bool isEdit,
    required BuildContext context,
    bool isProfileTeacher = false,
  }) async {
    final progress = ProgressHUD.of(context);
    progress!.show();
    emit(AddPostLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isProfileTeacher
            ? STUDENT_ADD_QUESTION_ON_TEACHER_PROFILE
            : isStudent
                ? isEdit
                    ? STUDENT_EDIT_POST
                    : STUDENT_ADD_POST
                : isEdit
                    ? TEACHER_EDIT_POST
                    : TEACHER_ADD_POST,
        token: teacherToken ?? studentToken,
        formData: addTeacherPostFormData(model, isEdit, isProfileTeacher),
      );
      print(response.data);
      if (response.data['status']) {
        teacherPostResponseModel = PostResponseModel.fromJson(response.data);
        emit(AddPostSuccessState(message: response.data['message']));
      } else {
        showToast(msg: response.data['message'], state: ToastStates.ERROR);
      }
    } catch (e) {
      emit(AddPostErrorState());
      throw e;
    } finally {
      progress.dismiss();
      isStudentPostEdit = false;
      isPostEdit = false;
      emit(GroupChangeState());
    }
  }

  FormData addTeacherPostFormData(
          GroupPostModel model, bool isEdit, bool isTeacherProfile) =>
      FormData.fromMap({
        'text': model.text,
        'images[]': model.images != null
            ? List.generate(
                model.images!.length,
                (index) => MultipartFile.fromFileSync(model.images![index].path,
                    filename: model.images![index].path.split('/').last),
              )
            : null,
        'group_id': model.groupId,
        'type': model.type,
        if (isEdit) "post_id": model.postId,
        if (isTeacherProfile) 'teacher_id': model.teacherId,
      });

  ///
  List<Post> postsList = [];
  List<Post> questionsList = [];
  List<Post> shareList = [];
  bool noPostData = false;
  bool noQuestionData = false;

  Future<void> getAllPostsAndQuestions(String type, int groupId, bool isStudent,
      {bool isProfile = false}) async {
    List posts = [];
    noPostData = false;
    noQuestionData = false;
    emit(GroupGetPostLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent
            ? isProfile
                ? STUDENT_GET_ALL_POSTS
                : STUDENT_GET_POSTS
            : TEACHER_GET_POSTS,
        token: isStudent ? studentToken : teacherToken,
        formData: FormData.fromMap({
          'group_id': groupId,
          'type': type,
        }),
      );
      if (response.data['status']) {
        posts = response.data['posts'];
        insertPostLists(
            type: type, posts: posts, response: response, isStudent: isStudent);
        if (type == 'post')
          noPostData = false;
        else
          noQuestionData = false;
        emit(GroupGetPostSuccessState());
      } else {
        print(response.data['message']);
        if (type == 'post')
          noPostData = true;
        else
          noQuestionData = true;
        emit(GroupGetPostErrorState());
      }
    } catch (e) {
      if (type == 'post')
        noPostData = true;
      else
        noQuestionData = true;
      emit(GroupGetPostErrorState());
      throw e;
    }
  }

  Map<int, int> postsLikeCount = {};
  Map<int, int> questionLikeCount = {};
  Map<int, int> shareLikeCount = {};

  Map<int, bool> postsLikeBool = {};
  Map<int, bool> questionLikeBool = {};
  Map<int, bool> shareLikeBool = {};

  void insertPostLists({
    required String type,
    required List posts,
    required Response response,
    required bool isStudent,
  }) {
    if (type == 'post') {
      postsList = List.generate(
        posts.length,
        (index) => Post.fromJson(response.data["posts"][index]),
      );
      postsList.forEach((element) {
        postsLikeCount.addAll({element.id!: element.likesNum!});
        postsLikeBool.addAll({
          element.id!:
              isStudent ? element.authLikeStudent! : element.authLikeTeacher!
        });
      });
    } else if (type == 'question') {
      questionsList = List.generate(
        posts.length,
        (index) => Post.fromJson(response.data["posts"][index]),
      );
      questionsList.forEach((element) {
        questionLikeCount.addAll({element.id!: element.likesNum!});
        questionLikeBool.addAll({
          element.id!:
              isStudent ? element.authLikeStudent! : element.authLikeTeacher!
        });
      });
    } else {
      shareList = List.generate(
        posts.length,
        (index) => Post.fromJson(response.data["posts"][index]),
      );
      shareList.forEach((element) {
        shareLikeCount.addAll({element.id!: element.likesNum!});
        shareLikeBool.addAll({
          element.id!:
              isStudent ? element.authLikeStudent! : element.authLikeTeacher!
        });
      });
    }
  }

  ///
  GroupVideosResponseModel? groupVideosResponseModel;
  StudentInGroupModel? studentInGroupModel;
  bool noGroupVideoData = false;
  bool noGroupMemberData = false;

  void getGroupVideosAndStudent(int groupId,
      {required bool isMembers, required bool isStudent}) async {
    noGroupVideoData = false;
    noGroupMemberData = false;
    emit(GroupGetVideoAndMembersLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent
            ? STUDENT_GET_GROUP_VIDEO
            : isMembers
                ? GET_ALL_STUDENTS_IN_GROUP
                : TEACHER_GET_GROUP_VIDEO,
        token: isStudent ? studentToken : teacherToken,
        formData: FormData.fromMap({
          'group_id': groupId,
        }),
      );
      if (response.data['status']) {
        if (isMembers) {
          studentInGroupModel = StudentInGroupModel.fromJson(response.data);
          noGroupMemberData = false;
        } else {
          noGroupVideoData = false;
          groupVideosResponseModel =
              GroupVideosResponseModel.fromJson(response.data);
        }
        emit(GroupGetVideoAndMembersSuccessState());
      } else {
        if (isMembers)
          noGroupMemberData = true;
        else
          noGroupVideoData = true;
        print(response.data['message']);
        emit(GroupGetVideoAndMembersErrorState());
        print(noGroupMemberData);
      }
    } catch (e) {
      if (isMembers)
        noGroupMemberData = true;
      else
        noGroupVideoData = true;
      print(noGroupMemberData);
      emit(GroupGetVideoAndMembersErrorState());
      throw e;
    }
  }

  ///
  bool groupAddStudentWithCodeLoading = false;

  void addStudentToGroupWithCode({
    required int groupId,
    required String code,
    required bool isAdd,
    required BuildContext context,
  }) async {
    groupAddStudentWithCodeLoading = true;
    emit(GroupAddStudentWithCodeLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isAdd ? ADD_STUDENT_WITH_CODE : REMOVE_STUDENT_WITH_CODE,
        token: teacherToken,
        formData: FormData.fromMap({
          'group_id': groupId,
          'code': code,
        }),
      );
      if (response.data['status']) {
        showSnackBar(
          context: context,
          text: response.data['message'],
          backgroundColor: successColor,
        );
        emit(GroupAddStudentWithCodeSuccessState());
      } else {
        showSnackBar(
          context: context,
          text: response.data['message'],
          backgroundColor: errorColor,
        );
        emit(GroupAddStudentWithCodeErrorState());
      }
    } catch (e) {
      showToast(
        msg: 'عذرا حدث خطا حاول مرة اخرى',
        state: ToastStates.ERROR,
      );
      emit(GroupAddStudentWithCodeErrorState());
      throw e;
    } finally {
      groupAddStudentWithCodeLoading = false;
      emit(GroupChangeState());
    }
  }

  ///
  HomeworkResponseModel? homeWorkResponseModel;
  bool noHomeworkData = false;

  void getGroupHomework(int groupId, bool isStudent) async {
    noHomeworkData = false;
    emit(GroupGetHomeworkLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url:
            isStudent ? STUDENT_GET_GROUP_HOMEWORK : TEACHER_GET_GROUP_HOMEWORK,
        token: isStudent ? studentToken : teacherToken,
        formData: FormData.fromMap({
          'group_id': groupId,
        }),
      );
      if (response.data['status']) {
        homeWorkResponseModel =
            HomeworkResponseModel.fromJson(response.data, isStudent);
        noHomeworkData = false;
        emit(GroupGetHomeworkSuccessState());
      } else {
        print(response.data['message']);
        noHomeworkData = true;
        emit(GroupGetHomeworkErrorState());
      }
    } catch (e) {
      noHomeworkData = true;
      emit(GroupGetHomeworkErrorState());
      throw e;
    }
  }

  ///
  Future<void> deleteMethod(int id, GroupDeleteType type) async {
    print('$id  $type ${generateDeleteUrl(type)}');
    emit(GroupGeneralDeleteLoadingState());
    try {
      log('Recieved from delete $id ${type.toString()}');
      Response response = await DioHelper.postFormData(
        url: generateDeleteUrl(type),
        token: teacherToken ?? studentToken,
        formData: generateDeleteFormData(type, id),
      );
      log('data from delete is ${response.data}');
      if (response.data['status']) {
        emit(GroupGeneralDeleteSuccessState());
      } else {
        print(response.data['message']);
        emit(GroupGeneralDeleteErrorState());
      }
    } catch (e) {
      emit(GroupGeneralDeleteErrorState());
      throw e;
    }
  }

  String generateDeleteUrl(GroupDeleteType type) {
    String url;

    switch (type) {
      case GroupDeleteType.HOMEWORK:
        url = TEACHER_DELETE_GROUP_HOMEWORK;
        break;
      case GroupDeleteType.POST:
        url = teacherToken != null ? TEACHER_DELETE_POST : STUDENT_DELETE_POST;
        break;
      case GroupDeleteType.COMMENT:
        url = teacherToken != null
            ? TEACHER_POST_DELETE_COMMENT
            : STUDENT_POST_DELETE_COMMENT;

        break;
      case GroupDeleteType.VIDEO:
        url = TEACHER_DELETE_GROUP_VIDEO;
        break;
      case GroupDeleteType.GROUP:
        url = TEACHER_DELETE_GROUP;
        break;
    }
    return url;
  }

  FormData generateDeleteFormData(GroupDeleteType type, int id) {
    FormData formData;

    switch (type) {
      case GroupDeleteType.HOMEWORK:
        formData = FormData.fromMap({
          'homework_id': id,
        });
        break;
      case GroupDeleteType.POST:
        formData = FormData.fromMap({
          'post_id': id,
        });
        break;
      case GroupDeleteType.COMMENT:
        formData = FormData.fromMap({
          'comment_id': id,
        });
        break;
      case GroupDeleteType.VIDEO:
        formData = FormData.fromMap({
          'id': id,
        });
        break;
      case GroupDeleteType.GROUP:
        formData = FormData.fromMap({
          'group_id': id,
        });
        break;
    }
    return formData;
  }

  ///

  void toggleLike({
    required int id,
    required int likesCount,
    required String type,
    required bool isLiked,
    required bool isStudent,
    required LikeType likeType,
  }) async {
    changeLikeCounter(
      postId: id,
      type: type,
      isIncrease: isLiked ? false : true,
      likesCount: likesCount,
      isLiked: isLiked,
    );
    emit(GroupToggleLikeLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent ? STUDENT_POST_TOGGLE_LIKE : TEACHER_POST_TOGGLE_LIKE,
        token: isStudent ? studentToken : teacherToken,
        formData: generateToggleLikeFormData(likeType, id),
      );
      print(response.data);
      if (response.data['status']) {
        emit(GroupToggleLikeSuccessState());
      } else {
        emit(GroupToggleLikeErrorState());
      }
    } catch (e) {
      changeLikeCounter(
        postId: id,
        type: type,
        isIncrease: null,
        likesCount: likesCount,
        isLiked: isLiked,
      );
      emit(GroupToggleLikeErrorState());
      throw e;
    }
  }

  void changeLikeCounter(
      {required String type,
      required bool? isIncrease,
      required int likesCount,
      required int postId,
      required bool isLiked}) {
    int number = isIncrease != null
        ? isIncrease
            ? 1
            : -1
        : 0;
    switch (type) {
      case 'post':
        if (isIncrease != null) {
          postsLikeCount[postId] = postsLikeCount[postId]! + number;
          postsLikeBool[postId] = !isLiked;
        } else {
          postsLikeCount[postId] = likesCount;
          postsLikeBool[postId] = isLiked;
        }
        break;
      case 'share':
        if (isIncrease != null) {
          shareLikeCount[postId] = shareLikeCount[postId]! + number;
          shareLikeBool[postId] = !isLiked;
        } else {
          shareLikeCount[postId] = likesCount;
          shareLikeBool[postId] = isLiked;
        }
        break;
      case 'question':
        if (isIncrease != null) {
          questionLikeCount[postId] = questionLikeCount[postId]! + number;
          questionLikeBool[postId] = !isLiked;
        } else {
          questionLikeCount[postId] = likesCount;
          questionLikeBool[postId] = isLiked;
        }
        break;
      case 'admin':
        if (isIncrease != null) {
          publicGroupPostsLikeCount[postId] =
              publicGroupPostsLikeCount[postId]! + number;
          publicGroupPostsLikeBool[postId] = !isLiked;
        } else {
          publicGroupPostsLikeCount[postId] = likesCount;
          publicGroupPostsLikeBool[postId] = isLiked;
        }
        break;
    }
  }

  FormData generateToggleLikeFormData(LikeType type, int id) {
    FormData formData;
    switch (type) {
      case LikeType.post:
        formData = FormData.fromMap({
          'post_id': id,
        });
        break;
      case LikeType.groupVideo:
        formData = FormData.fromMap({
          'video_id': id,
        });
        break;
      case LikeType.playlistVideo:
        formData = FormData.fromMap({
          'playlistdetail_id': id,
        });
        break;
    }
    return formData;
  }

  ///
  bool isAddCommentLoading = false;

  Comments? commentModel;

  void addComment({
    required bool isEdit,
    required bool isStudent,
    required CommentModel model,
    required String type,
    required CommentType commentType,
    required int groupId,
  }) async {
    isAddCommentLoading = true;
    emit(GroupAddCommentLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent
            ? isEdit
                ? STUDENT_POST_EDIT_COMMENT
                : STUDENT_POST_ADD_COMMENT
            : isEdit
                ? TEACHER_POST_EDIT_COMMENT
                : TEACHER_POST_ADD_COMMENT,
        token: isStudent ? studentToken : teacherToken,
        formData: model.toFormData(commentType),
      );
      print(response.data);
      if (response.data['status']) {
        commentModel = Comments.fromJson(response.data['comment']);
        if (type != '') {
          getAllPostsAndQuestions(type, groupId, isStudent);
        }
        emit(GroupAddCommentSuccessState());
      } else {
        print(response.data['message']);
        emit(GroupAddCommentErrorState());
      }
    } catch (e) {
      emit(GroupAddCommentErrorState());
      throw e;
    } finally {
      isAddCommentLoading = false;
      isEdit = false;
      isPostEdit = false;
      emit(GroupChangeState());
    }
  }

  /// --------------------------------------------
  /// student
  bool isJoinGroupLoading = false;

  void toggleStudentJoinGroup(int groupId) async {
    isJoinGroupLoading = true;
    emit(GroupStudentToggleJoinLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: STUDENT_TOGGLE_JOIN_GROUPS,
        token: studentToken,
        formData: FormData.fromMap({"group_id": groupId}),
      );
      if (response.data['status']) {
        if (joinedGroupMap[groupId] != null) {
          joinedGroupMap[groupId] = !joinedGroupMap[groupId]!;
        }
        emit(GroupStudentToggleJoinSuccessState());
      } else {
        if (joinedGroupMap[groupId] != null) {
          joinedGroupMap[groupId] = joinedGroupMap[groupId]!;
        }
        emit(GroupStudentToggleJoinErrorState());
      }
    } catch (e) {
      if (joinedGroupMap[groupId] != null) {
        joinedGroupMap[groupId] = joinedGroupMap[groupId]!;
      }
      emit(GroupStudentToggleJoinErrorState());
      throw e;
    } finally {
      isJoinGroupLoading = false;
      emit(GroupChangeState());
    }
  }

  /// Get public group info
  Group? publicGroupModel;
  bool noPublicGroupData = false;

  void getPublicGroupInfo() async {
    noPublicGroupData = false;
    emit(PublicGroupLoadingState());
    try {
      Response response = await DioHelper.getData(
        url: PUBLIC_GROUP_INFO,
        token: studentToken ?? teacherToken,
      );
      print(response.data);
      if (response.data['status']) {
        publicGroupModel = Group.fromJson(response.data['group']);
        emit(PublicGroupSuccessState());
      } else {
        noPublicGroupData = true;
        emit(PublicGroupErrorState());
      }
    } catch (e) {
      noPublicGroupData = true;
      emit(PublicGroupErrorState());
      throw e;
    }
  }

  ///
  List<Post> publicGroupPosts = [];
  bool noPublicGroupPostData = false;
  Map<int, int> publicGroupPostsLikeCount = {};

  Map<int, bool> publicGroupPostsLikeBool = {};

  void getAllPublicGroupPosts(int groupId, {bool isStudent = true}) async {
    List posts = [];
    noPublicGroupPostData = false;
    emit(GroupGetPostLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent ? PUBLIC_GET_POSTS : PUBLIC_GET_POSTS_TEACHER,
        token: isStudent ? studentToken : teacherToken,
        formData: FormData.fromMap({
          'group_id': groupId,
        }),
      );
      if (response.data['status']) {
        posts = response.data['posts'];
        publicGroupPosts = List.generate(
          posts.length,
          (index) => Post.fromJson(response.data["posts"][index]),
        );
        publicGroupPosts.forEach((element) {
          publicGroupPostsLikeCount.addAll({element.id!: element.likesNum!});
          publicGroupPostsLikeBool
              .addAll({element.id!: element.authLikeStudent!});
        });
        noPublicGroupPostData = false;
        emit(GroupGetPostSuccessState());
      } else {
        print(response.data['message']);
        noPublicGroupPostData = true;
        emit(GroupGetPostErrorState());
      }
    } catch (e) {
      noPublicGroupPostData = true;
      emit(GroupGetPostErrorState());
      throw e;
    }
  }

  /// Get Posts And Questions for teacher Profile
  void getAllProfilePostsAndQuestion(String type,
      {bool isQuestion = false}) async {
    List posts = [];
    emit(GroupGetPostLoadingState());
    try {
      Response response = await DioHelper.getData(
        url: isQuestion
            ? TEACHER_PROFILE_GET_ALL_QUESTION
            : TEACHER_PROFILE_GET_ALL_POST,
        token: teacherToken,
      );
      if (response.data['status']) {
        posts = response.data['posts'];
        insertPostLists(
          type: type,
          posts: posts,
          response: response,
          isStudent: false,
        );
        if (type == 'post')
          noPostData = false;
        else
          noQuestionData = false;
        emit(GroupGetPostSuccessState());
      } else {
        if (type == 'post')
          noPostData = true;
        else
          noQuestionData = true;
        emit(GroupGetPostErrorState());
      }
    } catch (e) {
      if (type == 'post')
        noPostData = true;
      else
        noQuestionData = true;
      emit(GroupGetPostErrorState());
      throw e;
    }
  }

  ///
  GroupResponseModel? teacherGroupsByIdModel;

  bool isTeacherDataLoading = false;

  void getTeacherDataById(int teacherId, TeacherDataType type) async {
    try {
      isTeacherDataLoading = true;
      emit(GroupsTeacherGetLoadingState());
      Response response = await DioHelper.postFormData(
        url: generateTeacherDataUrl(type),
        token: studentToken,
        formData: FormData.fromMap({'teacher_id': teacherId}),
      );
      log(response.data.toString());

      generateTeacherDataFunction(type, response);
      emit(GroupsTeacherGetSuccessState());
    } catch (e) {
      emit(GroupsTeacherGetErrorState());
      throw e;
    } finally {
      isTeacherDataLoading = false;
      // emit(GroupChangeState());
    }
  }

  String generateTeacherDataUrl(TeacherDataType type) {
    String url;
    switch (type) {
      case TeacherDataType.groups:
        url = STUDENT_GET_TEACHER_GROUPS;
        break;
      case TeacherDataType.questions:
        url = STUDENT_GET_TEACHER_QUESTIONS;
        break;
      case TeacherDataType.tests:
        url = STUDENT_GET_TEST_BY_TEACHER_ID;
        break;
    }
    return url;
  }

  List<Test> teacherTests = [];

  void generateTeacherDataFunction(TeacherDataType type, Response response) {
    if (response.data['status']) {
      switch (type) {
        case TeacherDataType.groups:
          teacherGroupsByIdModel = GroupResponseModel.fromJson(response.data);
          break;
        case TeacherDataType.questions:
          TeacherProfileQuestions teacherProfileQuestions =
              TeacherProfileQuestions.fromJson(response.data);
          questionsList = teacherProfileQuestions.posts?.postsData ?? [];
          questionsList.forEach((element) {
            questionLikeCount.addAll({element.id!: element.likesNum!});
            questionLikeBool.addAll({
              element.id!: element.authLikeStudent!,
            });
          });
          break;
        case TeacherDataType.tests:
          List tests = [];
          tests = response.data['tests'];
          teacherTests = List.generate(tests.length,
              (index) => Test.fromJson(response.data['tests'][index], false));
          break;
      }
    } else {
      teacherTests.clear();
      questionsList.clear();
      throw 'Error happened ${response.data['message']}';
    }
  }

  String convertDate(String date) {
    DateTime postDate = DateTime.parse(date);
    final String timeAgo = convertToAgo(postDate);
    return timeAgo;
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays > 7) {
      return DateFormat.yMMMMd(lang).format(input);
    } else if (diff.inDays == 1)
      return 'أمس';
    else if (diff.inDays == 2)
      return 'اول أمس';
    else if (diff.inDays > 2)
      return 'قبل ${diff.inDays} ايام';
    else if (diff.inHours >= 1) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'just now';
    }
  }
}
