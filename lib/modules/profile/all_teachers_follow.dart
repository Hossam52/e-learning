import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/modules/following_list/teacher_view/teacher_profile_view.dart';
import 'package:e_learning/modules/profile/cubit/profile_cubit.dart';
import 'package:e_learning/modules/profile/cubit/profile_states.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/load_more_data.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllTeachersFollow extends StatelessWidget {
  const AllTeachersFollow(
      {Key? key, required this.profileCubit, required this.profileId})
      : super(key: key);
  final ProfileCubit profileCubit;
  final int profileId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(context.tr.teachers_list),
        titleTextStyle: TextStyle(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25.r,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider.value(
        value: profileCubit..getMoreStudentFollowingList(profileId),
        child: Builder(builder: (context) {
          return BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (context, state) {
              final followingList = profileCubit.getFollowingList;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            navigateTo(
                                context,
                                TeacherProfileView(
                                  // teacher: followingList[index],
                                  teacherId: followingList[index].id,
                                  isAdd: false,
                                  cubit: StudentCubit.get(context),
                                ));
                          },
                          leading: Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                  followingList[index].image!,
                                ))),
                          ),
                          title: Text(followingList[index].name!),
                        );
                      },
                      itemCount: followingList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 10),
                    ),
                    if (!profileCubit.isLastTeachersPage)
                      LoadMoreData(
                          isLoading: state is MoreProfileFollowersLoadingState,
                          onLoadingMore: () {
                            profileCubit.getMoreStudentFollowingList(profileId);
                          })
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
