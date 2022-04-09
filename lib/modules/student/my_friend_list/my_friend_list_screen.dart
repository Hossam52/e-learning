import 'package:e_learning/modules/profile/student_profile_view.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/student/cubit/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/default_text_field.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/componants/widgets/student_view_build_item.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyFriendListScreen extends StatefulWidget {
  MyFriendListScreen({Key? key}) : super(key: key);

  @override
  _MyFriendListScreenState createState() => _MyFriendListScreenState();
}

class _MyFriendListScreenState extends State<MyFriendListScreen> {
  final TextEditingController codeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    StudentCubit.get(context).getFriend(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentCubit, StudentStates>(
      listener: (context, state) {
        if (state is GroupFriendWithCodeSuccessState) {
          StudentCubit.get(context).getFriend(false);
        }
      },
      builder: (context, state) {
        StudentCubit cubit = StudentCubit.get(context);
        return responsiveWidget(
          responsive: (_, deviceInfo) {
            return Scaffold(
              appBar: AppBar(
                title: Text(context.tr.my_friends),
                centerTitle: true,
                leading: defaultBackButton(context, deviceInfo.screenHeight),
              ),
              body: Conditional.single(
                context: context,
                conditionBuilder: (context) => state is! FriendGetLoadingState,
                fallbackBuilder: (context) => DefaultLoader(),
                widgetBuilder: (context) => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: DefaultTextField(
                                controller: codeController,
                                hint: context.tr.enter_id,
                                bgColor: Color(0xffDDDDDD).withOpacity(0.4),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return context.tr.this_field_is_required;
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              flex: 1,
                              child: DefaultAppButton(
                                onPressed: () {
                                  formKey.currentState!.save();
                                  if (formKey.currentState!.validate()) {
                                    cubit.addAndRemoveFriendWithCode(
                                      code: codeController.text,
                                      context: context,
                                      isAdd: true,
                                    );
                                  }
                                },
                                text: context.tr.add,
                                textStyle: thirdTextStyle(deviceInfo),
                                background: primaryColor,
                                isLoading: cubit.addFriendWithCodeLoading,
                                // height: 30.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: cubit.noFriendsData
                            ? NoDataWidget(
                                onPressed: () {
                                  cubit.getFriend(false);
                                },
                              )
                            : ListView.separated(
                                itemCount: cubit.friendsRequestResponseModel!
                                    .friends!.friendsData!.length,
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                separatorBuilder: (context, index) => Divider(),
                                itemBuilder: (context, index) {
                                  var friend = cubit
                                      .friendsRequestResponseModel!
                                      .friends!
                                      .friendsData![index];
                                  return StudentViewBuildItem(
                                    studentName: friend.name!,
                                    studentImage: friend.image!,
                                    onTap: () {
                                      // TODO: add is Friend
                                      navigateTo(
                                          context,
                                          StudentProfileView(
                                            // student: friend,
                                            id: friend.id,
                                          ));
                                    },
                                    tailing: TextButton(
                                      onPressed: () {
                                        cubit.addAndRemoveFriendWithCode(
                                          code: friend.code!,
                                          context: context,
                                          isAdd: false,
                                        );
                                      },
                                      child: cubit.friendRemoveWithCodeLoading
                                          ? Container(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Text(context.tr.remove,
                                              style: thirdTextStyle(null)
                                                  .copyWith(color: errorColor)),
                                    ),
                                  );
                                },
                              ),
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
  }
}
