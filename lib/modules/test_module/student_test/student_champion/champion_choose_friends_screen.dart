import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/models/teacher/test/test_response_model.dart';
import 'package:e_learning/modules/test_module/student_test/student_champion/chamion_friend_build_item.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_progress_button.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChampionChooseFriendScreen extends StatelessWidget {
  const ChampionChooseFriendScreen({
    Key? key,
    required this.testId,
    required this.test,
  }) : super(key: key);

  final int testId;
  final Test test;

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => TestLayoutCubit()..getStudentChampionFriends(testId),
      child: BlocConsumer<TestLayoutCubit, TestLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TestLayoutCubit cubit = TestLayoutCubit.get(context);
          return responsiveWidget(
            responsive: (context, deviceInfo) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('اختر المنافسين'),
                  centerTitle: true,
                  elevation: 1,
                  leading: defaultBackButton(context, deviceInfo.screenHeight),
                ),
                body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      state is! StudentFriendLoadingState,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => cubit.noFriendsData
                      ? NoDataWidget(
                          text: 'عذرا لا يوجد بيانات',
                          onPressed: () {
                            cubit.getStudentChampionFriends(testId);
                          },
                        )
                      : Column(children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: cubit.friendsResponseModel!.friends!
                                  .friendsData!.length,
                              padding: EdgeInsets.all(22),
                              itemBuilder: (context, index) {
                                var friend = cubit.friendsResponseModel!
                                    .friends!.friendsData![index];
                                return ChampionFriendBuildItem(
                                  value: cubit.chooseFriends[index],
                                  onChanged: (value) {
                                    cubit.chooseFriend(value!, index);
                                  },
                                  studentName: friend.name!,
                                  studentStage: friend.classroom!,
                                  studentImage: friend.image,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: DefaultProgressButton(
                              buttonState: cubit.championCreateButtonState,
                              idleText: 'انشاء',
                              loadingText: 'Loading',
                              failText: text!.failed,
                              successText: text.success_sign,
                              onPressed: cubit.selectedFriendsId.isEmpty
                                  ? null
                                  : () {
                                      cubit.createChampion(
                                        context: context,
                                        test: test,
                                        testId: testId,
                                        studentIds: cubit.selectedFriendsId,
                                      );
                                    },
                            ),
                          ),
                        ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
