import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/models/enums/enums.dart';
import 'package:e_learning/models/general_apis/get_all_countries_and_stages_model.dart';
import 'package:e_learning/models/student/auth/student_data_model.dart';
import 'package:e_learning/models/student/auth/student_model.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/profile/custom_profile_image.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/membership_widgets/student_star.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class StudentProfileInfoBuild extends StatelessWidget {
  const StudentProfileInfoBuild({
    Key? key,
    required this.authType,
    required this.deviceInfo,
    // required this.image,
    // required this.name,
    // required this.points,
    // required this.code,
    this.trailing,
    this.isMe = false,
    this.student,
  }) : super(key: key);

  final bool authType;
  final Student? student;
  final DeviceInformation deviceInfo;
  // final String image;
  // final String name;
  // final String points;
  // final String code;
  final Widget? trailing;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final String image = student!.image!;
    final String name = student!.name!;
    final String points = student!.points!;
    final String code = student!.code!;
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // ProfileImage(
                      //   image: image,
                      //   isMe: isMe,
                      //   student: student!,
                      // ),
                      CustomProfileImage(
                        image: image,
                        isMe: isMe,
                        onChangePicture: (avatar) {
                          AuthCubit.get(context).studentRegisterAndEdit(
                            context: context,
                            type: AuthType.Edit,
                            model: StudentModel(
                              name: student!.name!,
                              email: student!.email!,
                              avatar: avatar,
                            ),
                          );
                        },
                      ),
                      if (authType)
                        Positioned.directional(
                          textDirection: lang == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          end: 5.w,
                          bottom: 0,
                          child: StudentStar(),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  flex: 3,
                  child: Container(
                    // color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: secondaryTextStyle(deviceInfo)
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tr.points_count,
                              // 'عدد النقاط',
                              style: thirdTextStyle(deviceInfo).copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(points,
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(width: 5.w),
                                  Image.asset('assets/images/points.png'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 4.w),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            color: thirdColor,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    context.tr.number,
                                    // 'رقم ',
                                  ),
                                  Text(
                                    // 'ID',
                                    context.tr.id,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: Color(0xFF8BCAFF).withOpacity(0.65),
                                    width: 2.w,
                                  ),
                                ),
                                child: Text(
                                  code,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: code));
                                  showToast(
                                      msg: context.tr.copied_to_clipboard,
                                      state: ToastStates.SUCCESS);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 5.h),
                                  child: Text(
                                    context.tr.copy,
                                    style: thirdTextStyle(deviceInfo)
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: trailing != null ? 21.h : 0),
                        if (trailing != null) trailing!,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class ProfileImage extends StatelessWidget {
//   const ProfileImage(
//       {Key? key,
//       required this.image,
//       required this.isMe,
//       required this.student})
//       : super(key: key);

//   final String image;
//   final Student student;
//   final bool isMe;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: !isMe ? null : () => _onImageTapped(context),
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           Container(
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Color(0xffE2E2E2),
//             ),
//             child: CachedNetworkImage(
//               imageUrl: image,
//             ),
//           ),
//           if (isMe)
//             Positioned(
//               bottom: 10,
//               child: CircleAvatar(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 child: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () async {
//                     try {
//                       final res = (await MultiImagePicker.pickImages(
//                         maxImages: 1,
//                         enableCamera: true,
//                         cupertinoOptions: CupertinoOptions(
//                           takePhotoIcon: "E-learning app",
//                           doneButtonTitle: context.tr.done,
//                         ),
//                         materialOptions: MaterialOptions(
//                           actionBarColor: "#4C5FFB",
//                           actionBarTitle: "E-learning app",
//                           allViewTitle: "All Photos",
//                           useDetailsView: true,
//                           selectCircleStrokeColor: "#000000",
//                         ),
//                       ))
//                           .first;
//                       final path = await FlutterAbsolutePath.getAbsolutePath(
//                           res.identifier!);
//                       File tempFile = File(path!);
//                       final authCubit = AuthCubit.get(context);
//                       log('${authCubit.selectedCountryId} ${authCubit.selectedClassIndex}');

//                       authCubit.studentRegisterAndEdit(
//                         context: context,
//                         type: AuthType.Edit,
//                         model: StudentModel(
//                           name: student.name!,
//                           email: student.email!,
//                           avatar: tempFile,
//                         ),
//                       );
//                     } catch (e) {
//                       log(e.toString());
//                       showToast(
//                           msg: context.tr.error_happened_enter_images_again,
//                           state: ToastStates.WARNING);
//                     }
//                   },
//                   color: Colors.white,
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }

//   void _onImageTapped(BuildContext context) async {
//     // final cubit = AuthCubit.get(context);
//     // cubit.onChangeCountry(student.country);
//     // final countries = cubit.getAllCountriesAndStagesModel!.countries!;
//     // final specificCountryIndex = countries
//     //     .indexWhere((element) => element.name == cubit.selectedCountryName);
//     // final stages = countries[specificCountryIndex].stages;
//     // // final specifcStageIndex = stages.indexWhere((element) => element.name==student.country)
//     // return;
//     // print('Before');
//     // print(cubit.stagesNamesList[cubit.selectedCountryIndex!]);
//     // final res = cubit.getAllCountriesAndStagesModel!.countries!.where(
//     //   (element) =>
//     //       element.name == cubit.stagesNamesList[cubit.selectedCountryIndex!],
//     // );
//     // print(res);
//     // print('After');

//     // return;
//     List<Asset> resultList = <Asset>[];
//     List<Asset> images = [];

//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 1,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(
//           takePhotoIcon: "E-learning app",
//           doneButtonTitle: context.tr.done,
//         ),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#4C5FFB",
//           actionBarTitle: "E-learning app",
//           allViewTitle: "All Photos",
//           useDetailsView: true,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );

//       final image = resultList[0];
//       final path = await FlutterAbsolutePath.getAbsolutePath(image.identifier!);
//       File tempFile = File(path!);
//       print(student.email!);
//       print(student.name!);

//       // print(student.!);
//       // final countryIndex = cubit.countryNamesList
//       //     .indexWhere((element) => element == student.country);
//       // final countryId =
//       //     cubit.getAllCountriesAndStagesModel!.countries![(countryIndex)].id;
//       // AuthCubit.get(context).studentRegisterAndEdit(
//       //     context: context,
//       //     type: AuthType.Edit,
//       //     model: StudentModel(
//       //         name: student.name!,
//       //         email: student.email!,
//       //         countryId: AuthCubit.get(context).selectedCountryId!,
//       //         classroomId: AuthCubit.get(context).selectedClassId!,
//       //         avatar: tempFile));

//       print(image.identifier);
//     } catch (e) {
//       print(e);
//       showToast(
//           msg: context.tr.error_happened_enter_images_again,
//           state: ToastStates.WARNING);
//       throw e;
//     }
//   }
// }
