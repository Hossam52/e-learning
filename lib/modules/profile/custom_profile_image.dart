import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class CustomProfileImage extends StatelessWidget {
  const CustomProfileImage(
      {Key? key,
      required this.image,
      required this.isMe,
      required this.onChangePicture})
      : super(key: key);

  final String image;
  // final Student student;
  final void Function(File) onChangePicture;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isMe ? null : () => _onImageTapped(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffE2E2E2),
            ),
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
          if (isMe)
            Positioned(
              bottom: 10,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    try {
                      final res = (await MultiImagePicker.pickImages(
                        maxImages: 1,
                        enableCamera: true,
                        cupertinoOptions: CupertinoOptions(
                          takePhotoIcon: "E-learning app",
                          doneButtonTitle: context.tr.done,
                        ),
                        materialOptions: MaterialOptions(
                          actionBarColor: "#4C5FFB",
                          actionBarTitle: "E-learning app",
                          allViewTitle: "All Photos",
                          useDetailsView: true,
                          selectCircleStrokeColor: "#000000",
                        ),
                      ))
                          .first;
                      final path = await FlutterAbsolutePath.getAbsolutePath(
                          res.identifier!);
                      File tempFile = File(path!);
                      final authCubit = AuthCubit.get(context);
                      log('${authCubit.selectedCountryId} ${authCubit.selectedClassIndex}');

                      onChangePicture(tempFile);
                    } catch (e) {
                      log(e.toString());
                      showToast(
                          msg: context.tr.error_happened_enter_images_again,
                          state: ToastStates.WARNING);
                    }
                  },
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }

  void _onImageTapped(BuildContext context) async {
    // final cubit = AuthCubit.get(context);
    // cubit.onChangeCountry(student.country);
    // final countries = cubit.getAllCountriesAndStagesModel!.countries!;
    // final specificCountryIndex = countries
    //     .indexWhere((element) => element.name == cubit.selectedCountryName);
    // final stages = countries[specificCountryIndex].stages;
    // // final specifcStageIndex = stages.indexWhere((element) => element.name==student.country)
    // return;
    // print('Before');
    // print(cubit.stagesNamesList[cubit.selectedCountryIndex!]);
    // final res = cubit.getAllCountriesAndStagesModel!.countries!.where(
    //   (element) =>
    //       element.name == cubit.stagesNamesList[cubit.selectedCountryIndex!],
    // );
    // print(res);
    // print('After');

    // return;
    List<Asset> resultList = <Asset>[];
    List<Asset> images = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "E-learning app",
          doneButtonTitle: context.tr.done,
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#4C5FFB",
          actionBarTitle: "E-learning app",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );

      final image = resultList[0];
      final path = await FlutterAbsolutePath.getAbsolutePath(image.identifier!);
      File tempFile = File(path!);

      // print(student.!);
      // final countryIndex = cubit.countryNamesList
      //     .indexWhere((element) => element == student.country);
      // final countryId =
      //     cubit.getAllCountriesAndStagesModel!.countries![(countryIndex)].id;
      // AuthCubit.get(context).studentRegisterAndEdit(
      //     context: context,
      //     type: AuthType.Edit,
      //     model: StudentModel(
      //         name: student.name!,
      //         email: student.email!,
      //         countryId: AuthCubit.get(context).selectedCountryId!,
      //         classroomId: AuthCubit.get(context).selectedClassId!,
      //         avatar: tempFile));

      print(image.identifier);
    } catch (e) {
      print(e);
      showToast(
          msg: context.tr.error_happened_enter_images_again,
          state: ToastStates.WARNING);
      throw e;
    }
  }
}
