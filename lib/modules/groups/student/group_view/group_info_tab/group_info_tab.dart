import 'package:e_learning/layout/student/student_layout.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/groups/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupInfoTab extends StatelessWidget {
  const GroupInfoTab({
    Key? key,
    required this.groupName,
    required this.groupDesc,
    required this.isStudent,
    required this.groupId,
  }) : super(key: key);

  final int groupId;
  final String groupName;
  final String groupDesc;
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return BlocConsumer<GroupCubit, GroupStates>(
      listener: (context, state) {
        if (state is GroupStudentToggleJoinSuccessState) {
          navigateToAndFinish(context, StudentLayout());
        }
      },
      builder: (context, state) {
        GroupCubit cubit = GroupCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: deviceInfo.screenHeight * 0.06,
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: deviceInfo.screenwidth * 0.2,
                          height: deviceInfo.screenwidth * 0.2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/teacher_profile.png'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(
                          width: deviceInfo.screenwidth * 0.1,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'محمدود محمد',
                                style: secondaryTextStyle(deviceInfo),
                                maxLines: 1,
                              ),
                              SizedBox(height: deviceInfo.screenHeight * 0.02),
                              Text(
                                groupName,
                                style: thirdTextStyle(deviceInfo),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: deviceInfo.screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 45),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Directionality(
                      textDirection: textDirection,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وصف المجموعه',
                            style: secondaryTextStyle(deviceInfo),
                          ),
                          SizedBox(
                            height: deviceInfo.screenHeight * 0.04,
                          ),
                          Text(
                            groupDesc,
                            style: thirdTextStyle(deviceInfo),
                          ),
                          SizedBox(
                            height: deviceInfo.screenHeight * 0.08,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isStudent)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: DefaultAppButton(
                        text: 'مغادره الجروب',
                        textStyle: thirdTextStyle(null),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 60,
                        isLoading: cubit.isJoinGroupLoading,
                        onPressed: () {
                          cubit.toggleStudentJoinGroup(groupId);
                        },
                        background: errorColor,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
