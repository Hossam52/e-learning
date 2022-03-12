import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ResultsBuildItem extends StatelessWidget {
  ResultsBuildItem({
    Key? key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.isDismissible,
    this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  final String title;
  final String subtitle1;
  final String subtitle2;
  final bool isDismissible;
  Function()? onTap;
  Function()? onDelete;
  Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Slidable(
        key: UniqueKey(),
        enabled: isDismissible,
        startActionPane: ActionPane(
          extentRatio: 0.00001,
          children: [],
          motion: DrawerMotion(),
        ),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              backgroundColor: errorColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: context.tr.delete,
              onPressed: (context) {
                showDeleteDialog(
                  context,
                  name: title,
                  onDelete: onDelete,
                );
              },
            ),
            SlidableAction(
              backgroundColor: Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: context.tr.edit,
              onPressed: (context) {
                if (onEdit != null) onEdit!();
              },
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 16,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: secondaryTextStyle(null),
                ),
                SizedBox(height: 4.h),
                Text(subtitle1,
                    style: thirdTextStyle(null).copyWith(color: Colors.grey)),
                SizedBox(height: 4.h),
                Text(subtitle2,
                    style: thirdTextStyle(null).copyWith(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
