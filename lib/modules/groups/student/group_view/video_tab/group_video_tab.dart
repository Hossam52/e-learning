import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/video_tab/grouo_add_video_screen.dart';
import 'package:e_learning/modules/video_module/video_screens/video_player_screen.dart';
import 'package:e_learning/modules/video_module/video_screens/video_title_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_dimissible_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_refresh_widget.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupVideoTab extends StatefulWidget {
  const GroupVideoTab({
    Key? key,
    required this.groupId,
    required this.isStudent,
  }) : super(key: key);

  final int groupId;
  final bool isStudent;

  @override
  _GroupVideoTabState createState() => _GroupVideoTabState();
}

class _GroupVideoTabState extends State<GroupVideoTab> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    GroupCubit.get(context).getGroupVideosAndStudent(widget.groupId,
        isStudent: widget.isStudent, isMembers: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        if (state is GroupGetVideoAndMembersSuccessState) {
          refreshController.refreshCompleted();
        } else if (state is GroupGetVideoAndMembersErrorState) {
          refreshController.refreshFailed();
        }
        if (state is GroupGeneralDeleteSuccessState)
          cubit.getGroupVideosAndStudent(widget.groupId,
              isStudent: widget.isStudent, isMembers: false);
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return Scaffold(
          floatingActionButton: widget.isStudent
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    navigateTo(
                        context, GroupAddVideoScreen(groupId: widget.groupId));
                  },
                  child: Icon(Icons.add),
                ),
          body: DefaultRefreshWidget(
            refreshController: refreshController,
            onRefresh: () {
              cubit.getGroupVideosAndStudent(widget.groupId,
                  isStudent: widget.isStudent, isMembers: false);
            },
            enablePullUp: false,
            child: Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! GroupGetVideoAndMembersLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noGroupVideoData
                  ? NoDataWidget(
                      text: context.tr.no_data,
                      onPressed: () {
                        cubit.getGroupVideosAndStudent(widget.groupId,
                            isStudent: widget.isStudent, isMembers: false);
                      },
                    )
                  : ListView.separated(
                      itemCount:
                          cubit.groupVideosResponseModel!.videos!.data!.length,
                      padding: EdgeInsets.all(16),
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                      itemBuilder: (context, index) {
                        var video = cubit
                            .groupVideosResponseModel!.videos!.data![index];
                        return DefaultDismissibleWidget(
                          widgetContext: context,
                          name: "${video.videoName}",
                          hasEdit: false,
                          onEdit: () {},
                          onDelete: () {
                            cubit.deleteMethod(
                                video.id!, GroupDeleteType.VIDEO);
                          },
                          child: VideoTitleBuildItem(
                              videoTitle: "${video.videoName}",
                              videoId: video.videoId!,
                              onPressed: () {
                                navigateTo(
                                    context,
                                    VideoPlayerScreen(
                                      title: "${video.videoName}",
                                      videoId: video.videoId!,
                                      comments: video.comments!,
                                      commentType: CommentType.groupVideo,
                                      id: video.id!,
                                      subjectId: 0,
                                      teacherId: 0,
                                      isStudent: widget.isStudent,
                                      likeType: LikeType.groupVideo,
                                      likesCount: video.likesCount!,
                                      isLiked: widget.isStudent
                                          ? video.authLikeStudent!
                                          : video.authLikeTeacher!,
                                    ));
                              }),
                        );
                      }),
            ),
          ),
        );
      },
    );
  }
}
