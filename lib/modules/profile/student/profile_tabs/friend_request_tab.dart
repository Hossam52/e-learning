import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'friend_request_build_item.dart';

class FriendRequestTab extends StatefulWidget {
  const FriendRequestTab({Key? key}) : super(key: key);

  @override
  _FriendRequestTabState createState() => _FriendRequestTabState();
}

class _FriendRequestTabState extends State<FriendRequestTab> {
  @override
  void initState() {
    StudentCubit.get(context).getFriend(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentCubit, StudentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        StudentCubit cubit = StudentCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Conditional.single(
              context: context,
              conditionBuilder: (context) => state is! FriendGetLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noFriendsData
                  ? NoDataWidget(
                      onPressed: () {
                        cubit.getFriend(true);
                      },
                    )
                  : ListView.separated(
                      itemCount: cubit.friendsRequestResponseModel!.friends!
                          .friendsData!.length,
                      padding: EdgeInsets.all(8),
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) {
                        var request = cubit.friendsRequestResponseModel!
                            .friends!.friendsData![index];
                        return FriendRequestBuildItem(
                          deviceInfo: deviceInfo,
                          name: request.name!,
                          image: request.image!,
                          onAccept: () =>
                              cubit.acceptAndRejectRequest(true, request.code!),
                          onReject: () => cubit.acceptAndRejectRequest(
                              false, request.code!),
                          isLoading: state is FriendAcceptAndRejectLoadingState,
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
