import 'package:e_learning/layout/group_layout/student/group_layout.dart';
import 'package:e_learning/models/teacher/groups/group_response_model.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/modules/groups/student/group_member_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_circle_image.dart';
import 'package:e_learning/shared/componants/widgets/default_rating_bar.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        if (state is GroupStudentToggleJoinSuccessState) {
          navigateToAndReplace(
            context,
            GroupLayout(
              groupId: group.id!,
              groupName: group.title!,
              groupDesc: group.description!,
            ),
          );
        }
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    DefaultCircleImage(
                      width: 30.r,
                      height: 30.r,
                      imageUrl: '${group.teacher!.image}',
                    ),
                    SizedBox(width: 12.w),
                    Text('${group.title}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
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
                actions: [
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Chip(
                            label: Text(
                                "${group.type == 'free' ? 'مجموعة عامة' : 'مجموعة خاصة'}"),
                            avatar: Icon(
                              group.type == 'free'
                                  ? Icons.visibility
                                  : Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            labelStyle: thirdTextStyle(null)
                                .copyWith(color: Colors.white),
                            backgroundColor: group.type == 'free'
                                ? thirdColor
                                : Colors.deepOrange,
                          ),
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          '${group.description}',
                          style: thirdTextStyle(null).copyWith(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 22.h),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GroupMemberBuildItem(margin: 80),
                            GroupMemberBuildItem(margin: 125),
                            GroupMemberBuildItem(margin: 170),
                            Container(
                              // margin: EdgeInsetsDirectional.only(start: 80),
                              child: Chip(
                                label: Text(
                                  '+4400',
                                  style: TextStyle(color: Colors.white),
                                ),
                                padding: EdgeInsets.zero,
                                backgroundColor: thirdColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.h),
                        DefaultAppButton(
                          text: 'انضم الى المجموعة',
                          textStyle: thirdTextStyle(null),
                          isLoading: cubit.isJoinGroupLoading,
                          onPressed: () {
                            cubit.toggleStudentJoinGroup(group.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('عن المعلم'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          title: Text('${group.teacher!.name}'),
                          leading: DefaultCircleImage(
                            width: 50.r,
                            height: 50.r,
                            imageUrl: '${group.teacher!.image}',
                          ),
                          subtitle: DefaultRatingBar(
                            rate: group.teacher!.authStudentRate!.toDouble(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
