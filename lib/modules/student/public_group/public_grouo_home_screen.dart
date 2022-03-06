import 'package:e_learning/models/teacher/groups/in_group/group_post_model.dart';
import 'package:e_learning/models/teacher/groups/in_group/post_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/home_tab/post_build_item.dart';
import 'package:e_learning/modules/student/public_group/public_group_info_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_text_field.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PublicGroupHomeScreen extends StatefulWidget {
  PublicGroupHomeScreen({Key? key, required this.isStudent}) : super(key: key);

  final bool isStudent;

  @override
  State<PublicGroupHomeScreen> createState() => _PublicGroupHomeScreenState();
}

class _PublicGroupHomeScreenState extends State<PublicGroupHomeScreen> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  bool? noImages;
  int? postId;
  bool isEdit = false;

  @override
  void initState() {
    noImages = GroupCubit.get(context).selectedImages.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;

    return ProgressHUD(
      child: BlocProvider(
        create: (context) => GroupCubit()..getPublicGroupInfo(),
        child: BlocConsumer<GroupCubit, GroupStates>(
          listener: (context, state) {
            if (state is GroupGetPostSuccessState) {
              refreshController.refreshCompleted();
            } else if (state is GroupGetPostErrorState)
              refreshController.refreshFailed();
            if (state is PublicGroupSuccessState)
              GroupCubit.get(context).getAllPublicGroupPosts(
                  GroupCubit.get(context).publicGroupModel!.id!);
            if (state is AddPostSuccessState) {
              GroupCubit.get(context).getAllPublicGroupPosts(
                  GroupCubit.get(context).publicGroupModel!.id!);
              controller.clear();
              GroupCubit.get(context).clearImageList();
              showSnackBar(text: text.add_success, context: context);
            }
          },
          builder: (context, state) {
            GroupCubit cubit = GroupCubit.get(context);
            return responsiveWidget(
              responsive: (_, deviceInfo) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(cubit.publicGroupModel?.title ?? 'loading..'),
                    centerTitle: true,
                    leading:
                        defaultBackButton(context, deviceInfo.screenHeight),
                    actions: [
                      IconButton(
                        onPressed: () => state is! PublicGroupLoadingState
                            ? navigateTo(
                                context,
                                PublicGroupInfoScreen(
                                    groupInfo: cubit.publicGroupModel!))
                            : () {},
                        icon: Icon(Icons.info_outline),
                      ),
                    ],
                  ),
                  body: Conditional.single(
                    context: context,
                    conditionBuilder: (context) =>
                        state is! PublicGroupLoadingState,
                    fallbackBuilder: (context) => DefaultLoader(),
                    widgetBuilder: (context) => cubit.noPublicGroupData
                        ? NoDataWidget(
                            onPressed: () => cubit.getPublicGroupInfo())
                        : DefaultGestureWidget(
                            child: SmartRefresher(
                              controller: refreshController,
                              enablePullDown: true,
                              header: WaterDropHeader(),
                              onRefresh: () {
                                cubit.getAllPublicGroupPosts(
                                    cubit.publicGroupModel!.id!);
                              },
                              child: Conditional.single(
                                context: context,
                                conditionBuilder: (context) =>
                                    state is! GroupGetPostLoadingState,
                                fallbackBuilder: (context) => DefaultLoader(),
                                widgetBuilder: (context) => cubit.noPostData
                                    ? NoDataWidget(
                                        text: 'عذرا لا يوجد منشورات',
                                        onPressed: () =>
                                            cubit.getAllPublicGroupPosts(
                                                cubit.publicGroupModel!.id!))
                                    : SingleChildScrollView(
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: deviceInfo
                                                              .screenHeight *
                                                          0.015,
                                                    ),
                                                    DefaultTextField(
                                                      controller: controller,
                                                      hint: text
                                                          .what_do_you_want_to_say,
                                                      bgColor:
                                                          Colors.grey[200]!,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty)
                                                          return text
                                                              .general_validate;
                                                        return null;
                                                      },
                                                    ),
                                                    if (cubit.selectedImages
                                                        .isNotEmpty)
                                                      Container(
                                                        height: 250,
                                                        child: GridView.builder(
                                                          itemCount: cubit
                                                              .selectedImages
                                                              .length,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                            crossAxisSpacing: 3,
                                                          ),
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              Image.file(
                                                            cubit.selectedImages[
                                                                index],
                                                          ),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      height: deviceInfo
                                                              .screenHeight *
                                                          0.015,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              defaultMaterialIconButton(
                                                            onPressed: () {
                                                              formKey
                                                                  .currentState!
                                                                  .save();
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                cubit
                                                                    .addPostAndQuestion(
                                                                  GroupPostModel(
                                                                    text: controller
                                                                        .text,
                                                                    images: noImages!
                                                                        ? null
                                                                        : cubit
                                                                            .selectedImages,
                                                                    groupId: cubit
                                                                        .publicGroupModel!
                                                                        .id!,
                                                                    type:
                                                                        'post',
                                                                    postId: cubit
                                                                        .studentPostId,
                                                                  ),
                                                                  isStudent: widget
                                                                      .isStudent,
                                                                  isEdit: cubit
                                                                      .isStudentPostEdit,
                                                                  // isEdit,
                                                                  context:
                                                                      context,
                                                                );
                                                              }
                                                            },
                                                            text: cubit
                                                                    .isStudentPostEdit
                                                                ? text.edit
                                                                : text.post,
                                                            icon: cubit
                                                                    .isStudentPostEdit
                                                                ? Icons.edit
                                                                : Icons
                                                                    .post_add,
                                                            backgroundColor:
                                                                primaryColor,
                                                            textColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(width: 20.w),
                                                        Expanded(
                                                          child:
                                                              defaultMaterialIconButton(
                                                            onPressed: () {
                                                              if (noImages!)
                                                                cubit
                                                                    .loadImages();
                                                              else
                                                                cubit
                                                                    .clearImageList();
                                                            },
                                                            text: noImages!
                                                                ? text
                                                                    .add_images
                                                                : text
                                                                    .remove_images,
                                                            icon: noImages!
                                                                ? Icons.photo
                                                                : Icons.close,
                                                            backgroundColor:
                                                                noImages!
                                                                    ? successColor
                                                                    : errorColor,
                                                            textColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (cubit
                                                  .selectedImages.isNotEmpty)
                                                Container(
                                                  height: 250,
                                                  child: GridView.builder(
                                                    itemCount: cubit
                                                        .selectedImages.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 3,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Image.file(
                                                      cubit.selectedImages[
                                                          index],
                                                    ),
                                                  ),
                                                ),
                                              ListView.builder(
                                                  itemCount: cubit
                                                      .publicGroupPosts.length,
                                                  shrinkWrap: true,
                                                  reverse: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  itemBuilder:
                                                      (context, index) {
                                                    var post =
                                                        cubit.publicGroupPosts[
                                                            index];
                                                    return PostBuildItem(
                                                        type: 'post',
                                                        // name: post.teacher!,
                                                        ownerPostId:  widget.isStudent?post.studentId!:post.teacherId!,
                                                        deviceInfo: deviceInfo,
                                                        isMe: widget.isStudent
                                                            ? post.studentPost!
                                                            : post.teacherPost!,
                                                        isStudent:
                                                            widget.isStudent,
                                                        date: post.date!,
                                                        cubit: cubit,
                                                        postId: post.id!,
                                                        answer: null,
                                                        text: post.text,
                                                        likesCount: cubit
                                                                .publicGroupPostsLikeCount[
                                                            post.id]!,
                                                        isLiked:
                                                            cubit.publicGroupPostsLikeBool[
                                                                post.id]!,
                                                        commentCount: post
                                                            .comments!.length,
                                                        comments: post.comments,
                                                        groupId: cubit
                                                            .publicGroupModel!
                                                            .id!,
                                                        images: post.images!
                                                                .isNotEmpty
                                                            ? post.images
                                                            : null,
                                                        image: post
                                                                .studentImage ??
                                                            post.teacherImage ??
                                                            '',
                                                        onEdit: () async {
                                                          cubit
                                                              .changeStudentEditPost(
                                                                  true,
                                                                  post.id);
                                                          controller.text =
                                                              post.text!;
                                                          if (post.images!
                                                              .isNotEmpty) {
                                                            await AppCubit.get(
                                                                    context)
                                                                .addImageFromUrl(
                                                                    '',
                                                                    imageUrls: post
                                                                        .images);
                                                            cubit.selectedImages =
                                                                AppCubit.get(
                                                                        context)
                                                                    .imageFiles;
                                                          }
                                                        });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    refreshController.dispose();
    super.dispose();
  }
}
