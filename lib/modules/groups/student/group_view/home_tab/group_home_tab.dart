import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_add_post_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/load_more_data.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../discuss_tab/group_question_tab.dart';

class GroupHomeTab extends StatefulWidget {
  const GroupHomeTab({
    Key? key,
    required this.isStudent,
    required this.groupId,
  }) : super(key: key);

  final bool isStudent;
  final int groupId;

  @override
  _GroupHomeTabState createState() => _GroupHomeTabState();
}

class _GroupHomeTabState extends State<GroupHomeTab>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = new TextEditingController();

  bool noImages = false;
  int index = 0;

  @override
  void initState() {
    GroupCubit cubit = GroupCubit.get(context);
    tabController = new TabController(length: 2, vsync: this);
    cubit.getAllPostsAndQuestions("question", widget.groupId, widget.isStudent);
    noImages = cubit.selectedImages.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          GroupCubit.get(context).getAllPostsAndQuestions(
              'share', widget.groupId, widget.isStudent);
          GroupCubit.get(context).getAllPostsAndQuestions(
              'question', widget.groupId, widget.isStudent);
          controller.clear();
          GroupCubit.get(context).clearImageList();
          GroupCubit.get(context).isStudentPostEdit = false;
          GroupCubit.get(context).studentPostId = null;
          showSnackBar(text: text.add_success, context: context);
        }
        if (state is PostImageState) {
          noImages = GroupCubit.get(context).selectedImages.isEmpty;
        }
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return ProgressHUD(
          child: responsiveWidget(
            responsive: (_, deviceInfo) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (widget.isStudent)
                        DefaultAddPostWidget(
                          isStudent: widget.isStudent,
                          groupId: widget.groupId,
                          postController: controller,
                          cubit: cubit,
                          formKey: formKey,
                          noImages: noImages,
                          isEdit: cubit.isStudentPostEdit,
                          postId: cubit.studentPostId,
                        ),
                      SizedBox(
                        height: widget.isStudent
                            ? deviceInfo.screenHeight * 0.015
                            : 0,
                      ),
                      Column(
                        children: [
                          TabBar(
                            labelColor: primaryColor,
                            controller: tabController,
                            labelPadding: EdgeInsets.symmetric(vertical: 5),
                            onTap: (value) {
                              index = value;
                              cubit.emit(GroupChangeState());
                              if (value == 1)
                                cubit.getAllPostsAndQuestions(
                                    "share", widget.groupId, widget.isStudent);
                              else {
                                cubit.getAllPostsAndQuestions("question",
                                    widget.groupId, widget.isStudent);
                              }
                            },
                            indicator: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey[200]!,
                                  Colors.white,
                                  Colors.white,
                                ],
                                stops: [0, 0.15, 0.3],
                              ),
                            ),
                            tabs: [
                              Tab(text: text.questions),
                              Tab(text: text.posts),
                            ],
                          ),
                          Conditional.single(
                            context: context,
                            conditionBuilder: (context) =>
                                state is! GroupGetPostLoadingState,
                            fallbackBuilder: (context) => DefaultLoader(),
                            widgetBuilder: (context) =>
                                generateTab(index, cubit, deviceInfo),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget generateTab(
      int index, GroupCubit cubit, DeviceInformation deviceInfo) {
    List<Widget> widgets = [
      cubit.questionsList.isEmpty
          ? NoDataWidget(
              onPressed: () => cubit.getAllPostsAndQuestions(
                  "question", widget.groupId, widget.isStudent),
            )
          : Column(
              children: [
                GroupStudentTab(
                  isQuestion: true,
                  isStudent: widget.isStudent,
                  deviceInfo: deviceInfo,
                  cubit: cubit,
                  groupId: widget.groupId,
                  posts: cubit.questionsList,
                  postController: controller,
                ),
                LoadMoreData(onLoadingMore: () {
                  cubit.getMoreAllPostsAndQuestions(
                      "question", widget.groupId, widget.isStudent);
                })
              ],
            ),
      cubit.shareList.isEmpty
          ? NoDataWidget(
              onPressed: () => cubit.getAllPostsAndQuestions(
                  "share", widget.groupId, widget.isStudent),
            )
          : Column(
              children: [
                GroupStudentTab(
                  isQuestion: false,
                  deviceInfo: deviceInfo,
                  cubit: cubit,
                  groupId: widget.groupId,
                  posts: cubit.shareList,
                  isStudent: widget.isStudent,
                  postController: controller,
                ),
                LoadMoreData(onLoadingMore: () {
                  cubit.getMoreAllPostsAndQuestions(
                      "share", widget.groupId, widget.isStudent);
                })
              ],
            ),
    ];
    return widgets[index];
  }

  @override
  void dispose() {
    tabController!.dispose();
    controller.dispose();
    super.dispose();
  }
}
