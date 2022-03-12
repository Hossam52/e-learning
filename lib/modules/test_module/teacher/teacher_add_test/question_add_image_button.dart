import 'dart:io';

import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'test_componants/test_image_remove_button.dart';

class QuestionAddImageButton extends StatelessWidget {
  QuestionAddImageButton({
    Key? key,
    required this.onTap,
    required this.cubit,
    required this.index,
    this.image,
  }) : super(key: key);

  final Function() onTap;
  File? image;
  final TestCubit cubit;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: image != null
          ? TestImageRemoveButton(
              onPressed: () {
                cubit.removeImageDataMethod(false, index);
              },
              image: Image.file(image!,
                  width: MediaQuery.of(context).size.width * 0.5),
              index: index,
            )
          : InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 22.w,
                  ),
                  SizedBox(width: 15.w),
                  Text(
                    context.tr.add_image,
                    style: subTextStyle(null),
                  ),
                ],
              ),
            ),
    );
  }
}
