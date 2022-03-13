import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/student/group_view/discuss_tab/group_question_tab.dart';
import 'package:e_learning/modules/profile/student/student_profile_info_build.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
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
    this.student,
    this.id,
    this.isTeacher=false,
    required this.isFriend,
  }) : super(key: key);

  final int? id;
  Student? student;
  bool? isTeacher;
  final bool isFriend;

  @override
  State<StudentProfileView> createState() => _StudentProfileViewState();
}

class _StudentProfileViewState extends State<StudentProfileView> {
  @override
  void initState() {
    if (widget.student == null) {
      AuthCubit.get(context).getProfileById(widget.id!, true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GetProfileSuccessState) {
          widget.student = AuthCubit.get(context).studentProfileModel!.student;
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return BlocConsumer<StudentCubit, StudentStates>(
          listener: (context, state) {
            if (state is GroupFriendWithCodeSuccessState) {
              AppCubit.get(context).getBestStudentsListAuthorized();
              switch (widget.student!.friendType) {
                case FriendType.NotFriend:
                  widget.student!.friendType = FriendType.Pending;
                  break;
                case FriendType.Friend:
                  widget.student!.friendType = FriendType.NotFriend;

                  break;
                default:
              }
            }
          },
          builder: (context, state) {
            StudentCubit cubit = StudentCubit.get(context);
            return responsiveWidget(
              responsive: (_, deviceInfo) {
                return Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! GetProfileLoadingState,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => state is GetProfileErrorState
                      ? NoDataWidget(
                          onPressed: () =>
                              authCubit.getProfileById(widget.id!, true))
                      : Scaffold(
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
                                GroupStudentTab(
                                  cubit: GroupCubit.get(context),
                                  deviceInfo: deviceInfo,
                                  groupId: 0,
                                  isQuestion: false,
                                  isStudent: true,
                                  posts: GroupCubit.get(context).postsList,
                                  isPost: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }

  StudentProfileInfoBuild _personalInfo(
      DeviceInformation deviceInfo, StudentCubit cubit, BuildContext context,bool isTeacher) {
    return StudentProfileInfoBuild(
      deviceInfo: deviceInfo,
      // image: "${widget.student!.image}",
      // name: "${widget.student!.name}",
      // points: "${widget.student!.points}",
      // code: "${widget.student!.code}",
      student: widget.student,
      authType: authType,
      trailing:!isTeacher? defaultMaterialIconButton(
        text: getActionString,
        icon: getIcon,
        backgroundColor: getBackgroundColor,
        textColor: getTextColor,
        isLoading: cubit.addFriendWithCodeLoading,
        onPressed: widget.student!.friendType == FriendType.Pending ||
                widget.student!.friendType == FriendType.Unknown
            ? null
            : () {
                cubit.addAndRemoveFriendWithCode(
                  code: widget.student!.code!,
                  context: context,
                  isAdd: widget.student!.friendType == FriendType.NotFriend,
                );
              },
      ):Container(),
    );
  }

  String get getActionString {
    switch (widget.student!.friendType) {
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
    switch (widget.student!.friendType) {
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
    switch (widget.student!.friendType) {
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
    switch (widget.student!.friendType) {
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
              Text(context.tr.follow, style: secondaryTextStyle(deviceInfo)),
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
    return SizedBox(
      height: 70.h,
      child: responsiveWidget(
          responsive: ((context, deviceInformation) => ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 15.w),
                itemBuilder: (_, index) {
                  return _FollowerItem(
                    deviceInfo: deviceInfo,
                  );
                },
                itemCount: 10,
                scrollDirection: Axis.horizontal,
              ))),
    );
  }
}

class _FollowerItem extends StatelessWidget {
  const _FollowerItem({Key? key, required this.deviceInfo}) : super(key: key);
  final DeviceInformation deviceInfo;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50.r,
          height: 50.r,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/images/profile.png'))),
        ),
        SizedBox(height: 5.h),
        Text(
          'Hossam H',
          style: subTextStyle(deviceInfo).copyWith(color: Colors.black),
        )
      ],
    );
  }
}
