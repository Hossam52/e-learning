import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/teacher/auth/teacher_data_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_view/discuss_tab/group_question_tab.dart';
import 'package:e_learning/modules/profile/cubit/profile_cubit.dart';
import 'package:e_learning/modules/profile/cubit/profile_states.dart';
import 'package:e_learning/modules/profile/student/student_profile_info_build.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_cached_image.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/load_more_data.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentProfileView extends StatefulWidget {
  StudentProfileView({
    Key? key,
    // this.student,
    this.id,
    this.isTeacher = false,
    required this.isFriend,
  }) : super(key: key);

  final int? id;
  // Student? student;
  bool? isTeacher;
  final bool isFriend;

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {
  Student? student;
  @override
  void initState() {
    // if (widget.student != null) {
    // AuthCubit.get(context).getProfileById(widget.student!.id!, true);
    // AuthCubit.get(context).getProfileGuestById(widget.id!, true);
    // AuthCubit.get(context).getStudentPosts(widget.id!);
    // }
    super.initState();
  }

  void appendListOfPosts(BuildContext context, bool loadMore) {
    GroupCubit.get(context).insertPostLists(
      type: 'post',
      posts: ProfileCubit.instance(context).getProfilePosts,
      response: ProfileCubit.instance(context).allPostsResponse!,
      isStudent: true,
      loadMore: loadMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit()..getProfile(widget.id!, true),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
          lazy: false,
        ),
      ],
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileSuccessState) {
            student = ProfileCubit.instance(context).studentByIdModel!.student;
            ProfileCubit.instance(context).getStudentFollowingList(widget.id!);
          } else if (state is ProfileFollowersSuccessState) {
            ProfileCubit.instance(context).getStudentPosts(widget.id!);
          } else if (state is ProfilePostsSuccessState) {
            appendListOfPosts(context, false);
          } else if (state is ProfileMorePostsSuccessState) {
            appendListOfPosts(context, true);
          }
        },
        builder: (context, state) {
          // AuthCubit authCubit = AuthCubit.get(context);
          if (state is ProfileLoadingState)
            return DefaultLoader();
          else if (state is ProfileErrorState)
            return NoDataWidget(
                onPressed: () => ProfileCubit.instance(context)
                    .getProfile(widget.id!, true));
          return BlocConsumer<StudentCubit, StudentStates>(
            listener: (context, state) {
              if (state is GroupFriendWithCodeSuccessState) {
                AppCubit.get(context).getBestStudentsListAuthorized();
                switch (student!.friendType) {
                  case FriendType.NotFriend:
                    student!.friendType = FriendType.Pending;
                    break;
                  case FriendType.Friend:
                    student!.friendType = FriendType.NotFriend;

                    break;
                  default:
                }
              }
            },
            builder: (context, state) {
              StudentCubit cubit = StudentCubit.get(context);
              return responsiveWidget(
                responsive: (_, deviceInfo) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        context.tr.personal_profile,
                        style: TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                      backgroundColor: primaryColor,
                      leading: defaultBackButton(
                        context,
                        deviceInfo.screenHeight,
                        color: Colors.white,
                      ),
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.light,
                        statusBarIconBrightness: Brightness.light,
                      ),
                    ),
                    backgroundColor: backgroundColor,
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _personalInfo(deviceInfo, cubit, context,
                                    widget.isTeacher!),
                                _followPersons(deviceInfo),
                              ],
                            ),
                          ),
                          SizedBox(height: 11.h),
                          Text(
                              'This layout is static until get the data from back end',
                              style: TextStyle(fontSize: 16.sp)),
                          BlocBuilder<GroupCubit, GroupStates>(
                            builder: (context, state) {
                              return GroupStudentTab(
                                cubit: GroupCubit.get(context),
                                deviceInfo: deviceInfo,
                                groupId: 0,
                                isQuestion: false,
                                isStudent: true,
                                posts: GroupCubit.get(context).postsList,
                                isPost: true,
                              );
                            },
                          ),
                          Visibility(
                            visible:
                                !ProfileCubit.instance(context).isLastPostPage,
                            child: BlocBuilder<ProfileCubit, ProfileStates>(
                              builder: (context, state) {
                                if (state is ProfileMorePostsLoadingState)
                                  return CircularProgressIndicator();
                                return LoadMoreData(onLoadingMore: () {
                                  ProfileCubit.instance(context)
                                      .getMoreStudentPosts(widget.id!);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  StudentProfileInfoBuild _personalInfo(DeviceInformation deviceInfo,
      StudentCubit cubit, BuildContext context, bool isTeacher) {
    return StudentProfileInfoBuild(
      deviceInfo: deviceInfo,
      // image: "${widget.student!.image}",
      // name: "${widget.student!.name}",
      // points: "${widget.student!.points}",
      // code: "${widget.student!.code}",
      student: student,
      authType: authType,
      trailing: !isTeacher
          ? defaultMaterialIconButton(
              text: getActionString,
              icon: getIcon,
              backgroundColor: getBackgroundColor,
              textColor: getTextColor,
              isLoading: cubit.addFriendWithCodeLoading,
              onPressed: student!.friendType == FriendType.Pending ||
                      student!.friendType == FriendType.Unknown
                  ? null
                  : () {
                      cubit.addAndRemoveFriendWithCode(
                        code: student!.code!,
                        context: context,
                        isAdd: student!.friendType == FriendType.NotFriend,
                      );
                    },
            )
          : Container(),
    );
  }

  String get getActionString {
    switch (student!.friendType) {
      case FriendType.Friend:
        return context.tr.remove_friend;
      case FriendType.NotFriend:
        return context.tr.add_friend;
      case FriendType.Pending:
        return context.tr.pending;

      default:
        return context.tr.unknown;
    }
  }

  IconData get getIcon {
    switch (student!.friendType) {
      case FriendType.Friend:
        return Icons.person_remove;
      case FriendType.NotFriend:
        return Icons.person_add;
      case FriendType.Pending:
        return Icons.watch_later_outlined;

      default:
        return Icons.no_accounts;
    }
  }

  Color get getBackgroundColor {
    switch (student!.friendType) {
      case FriendType.Friend:
        return errorColor;
      case FriendType.NotFriend:
        return Colors.white;
      case FriendType.Pending:
        return Colors.white;

      default:
        return Colors.white;
    }
  }

  Color get getTextColor {
    switch (student!.friendType) {
      case FriendType.Friend:
        return Colors.white;
      case FriendType.NotFriend:
        return primaryColor;
      case FriendType.Pending:
        return Colors.white;

      default:
        return Colors.black;
    }
  }

  Widget _followPersons(deviceInfo) {
    return Padding(
      padding: EdgeInsets.all(18.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Teachers follow', style: secondaryTextStyle(deviceInfo)),
              Text(context.tr.view_all,
                  style: secondaryTextStyle(deviceInfo)
                      .copyWith(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 18.h),
          _followersListView(deviceInfo),
        ],
      ),
    );
  }

  Widget _followersListView(deviceInfo) {
    return BlocBuilder<ProfileCubit, ProfileStates>(builder: (context, state) {
      final followingList = ProfileCubit.instance(context).getFollowingList;

      return SizedBox(
        height: 70.h,
        child: responsiveWidget(responsive: ((_context, deviceInformation) {
          if (followingList.isEmpty)
            return Center(
              child: Text(context.tr.no_teachers),
            );
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            itemBuilder: (_, index) {
              return _FollowerItem(
                deviceInfo: deviceInfo,
                teacher: followingList[index],
              );
            },
            itemCount: followingList.length,
            scrollDirection: Axis.horizontal,
          );
        })),
      );
    });
  }

  Widget buildPosts(deviceInfo) {
    return Builder(builder: (context) {
      return GroupStudentTab(
        cubit: GroupCubit.get(context),
        deviceInfo: deviceInfo,
        groupId: 0,
        isQuestion: false,
        isStudent: true,
        posts: ProfileCubit.instance(context).getProfilePosts,
        isPost: true,
      );
    });
  }
}

class _FollowerItem extends StatelessWidget {
  const _FollowerItem(
      {Key? key, required this.deviceInfo, required this.teacher})
      : super(key: key);
  final DeviceInformation deviceInfo;
  final Teacher teacher;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(
            context,
            TeacherProfileView(
              teacher: teacher,
              isAdd: false,
              cubit: StudentCubit.get(context),
            ));
      },
      child: Column(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                  teacher.image!,
                ))),
          ),
          SizedBox(height: 5.h),
          Text(
            teacher.name!,
            style: subTextStyle(deviceInfo).copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
