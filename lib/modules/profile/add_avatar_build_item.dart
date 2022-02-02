import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class AvatarBuildItem extends StatelessWidget {
  const AvatarBuildItem({
    Key? key,
    required this.image,
    required this.appCubit,
  }) : super(key: key);

  final String image;
  final AppCubit appCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: DecorationImage(
                image: appCubit.imageFile != null
                    ? FileImage(appCubit.imageFile!) as ImageProvider
                    : CachedNetworkImageProvider("$image"),
              )),
        ),
        if (authType)
          Positioned.directional(
            textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            bottom: 0,
            end: 0,
            child: GestureDetector(
              onTap: () {
                alertDialogImagePicker(
                  context: context,
                  cubit: appCubit,
                  onTap: () {},
                );
              },
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 15,
                child: Icon(Icons.add),
              ),
            ),
          )
      ],
    );
  }
}
