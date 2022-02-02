import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'invitation_build_item.dart';

class StudentMyInvitationsScreen extends StatefulWidget {
  const StudentMyInvitationsScreen({Key? key}) : super(key: key);

  @override
  State<StudentMyInvitationsScreen> createState() =>
      _StudentMyInvitationsScreenState();
}

class _StudentMyInvitationsScreenState
    extends State<StudentMyInvitationsScreen> {
  @override
  void initState() {
    TestLayoutCubit.get(context).getAllInvitations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestLayoutCubit, TestLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TestLayoutCubit cubit = TestLayoutCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! GetAllInvitationsLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => state is GetAllInvitationsErrorState
                  ? NoDataWidget(onPressed: () => cubit.getAllInvitations())
                  : ListView.builder(
                      itemCount:
                          cubit.championInvitationsModel!.students!.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        var invitation =
                            cubit.championInvitationsModel!.students![index];
                        return InvitationChallengeBuildItem(
                          name: invitation.name!,
                          image: invitation.image!,
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
