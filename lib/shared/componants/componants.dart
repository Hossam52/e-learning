import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/componants/widgets/default_form_field.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

// Navigate to Screen function
Future<dynamic> navigateTo(context, widget) async => await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

// Navigate to Screen and replacement function
void navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

void navigateToAndReplace(BuildContext context, Widget widget) =>
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
// Social app button
Widget socialButton({
  required String assetName,
  double width = double.infinity,
  double height = 50,
  Color background = Colors.transparent,
  Color border = Colors.transparent,
  required void Function() onPressed,
  required String text,
  bool isUpperCase = true,
  Color textColor = Colors.black,
  double fontSize = 15,
  bool isCenter = true,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: background,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
            color: border,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetName,
              width: 20,
            ),
            SizedBox(width: 12),
            Text(
              isUpperCase ? '$text'.toUpperCase() : '$text',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );

// default text form field

// Default text button
Widget defaultTextButton({
  required String text,
  required void Function() onPressed,
  double? fontSize,
  FontWeight? fontWeight,
  Color? textColor,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        '$text',
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );

// Toast
void showToast({
  required String msg,
  required ToastStates state,
  ToastGravity position = ToastGravity.BOTTOM,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: position,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}

void showSnackBar({
  required BuildContext context,
  required String text,
  Color backgroundColor = secondaryColor,
}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: backgroundColor,
    ),
  );
}

// Titles
Widget titleWidget({
  required String text,
  Color? color,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
    );

// Quantity button
Widget defaultQuantityBtn({
  required String text,
  required context,
}) =>
    InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: (Colors.grey[300])!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
            ),
            SizedBox(width: 10),
            Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
          ],
        ),
      ),
    );

// default back button
Widget defaultBackButton(BuildContext context, double height, {Color? color}) {
  return Row(
    children: [
      IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          size: height * 0.026,
          color: color,
        ),
      ),
    ],
  );
}

DropdownButtonFormField defaultDropdownButtonFormField(
    {required String label,
    required BuildContext context,
    String? hint,
    String? selectedValue,
    required Function onChanged,
    required String? Function(String?) validator,
    required DeviceInformation deviceInfo,
    required List<DropdownMenuItem<String>> items}) {
  return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, hintText: hint),
      value: selectedValue,
      validator: validator,
      onChanged: (newValue) {
        FocusScope.of(context).requestFocus(new FocusNode());
        onChanged(newValue);
      },
      items: items);
}

// Forget Password Dialog
Future<void> forgetPasswordDialog(
    BuildContext context, DeviceInformation deviceInfo) async {
  return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            titleTextStyle:
                secondaryTextStyle(deviceInfo).copyWith(color: Colors.black),
            title: Text(
              context.tr.enter_email_for_new_password,
              // 'ادخل البريد الالكتروني الخاص بك لكي تصلك رسالة للتأكيد  لأنشاء كلمة مرور جديدة',
            ),
            content: DefaultFormField(
                controller: TextEditingController(),
                type: TextInputType.emailAddress,
                labelText: context.tr.email, //'البريد الالكتروني',
                validation: (email) {
                  if (email == null || email.isEmpty)
                    return context.tr.enter_email;
                  // 'من فضلك ادخل البريد الالكتروني';
                  return null;
                }),
            actions: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultAppButton(
                      onPressed: () {},
                      text: context.tr.follow,
                      width: 100,
                      isLoading: false,
                      textStyle: thirdTextStyle(deviceInfo),
                      isDisabled: false,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(context.tr.back))
                  ],
                ),
              )
            ],
          ));
}

// default dialog
void defaultDialog({
  required BuildContext context,
  required DeviceInformation deviceInfo,
  required Widget image,
  required String text,
  required String buttonText,
  required Function() onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25.h),
              image,
              SizedBox(height: 25.h),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35.h),
              DefaultAppButton(
                onPressed: onPressed,
                text: buttonText,
                background: secondaryColor,
                isLoading: false,
                width: 140.w,
                textStyle: thirdTextStyle(deviceInfo),
              ),
              SizedBox(height: 20),
            ]),
      );
    },
  );
}

ElevatedButton defaultElevatedButton({
  required DeviceInformation deviceInfo,
  required Function onPressed,
  required String title,
  Color? background,
  Color? textColor,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: background,
        padding: EdgeInsets.symmetric(
            horizontal: deviceInfo.screenwidth * 0.1, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(deviceInfo.screenwidth * 0.027),
        )),
    onPressed: () {
      onPressed();
    },
    child: Text(
      title,
      style: thirdTextStyle(deviceInfo).copyWith(color: textColor),
    ),
  );
}

/// Default Like button
Widget defaultLikeButton({
  required DeviceInformation deviceInfo,
  required String text,
  required IconData icon,
  Function()? onPressed,
  EdgeInsets? padding,
  Color color = Colors.grey,
}) =>
    MaterialButton(
      onPressed: onPressed,
      textColor: color,
      padding: padding,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1.2,
          color: (Colors.grey[400])!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: thirdTextStyle(deviceInfo),
          ),
        ],
      ),
    );

Widget defaultMaterialIconButton({
  Function()? onPressed,
  required IconData icon,
  required String text,
  required Color backgroundColor,
  double? elevation,
  double height = 8,
  Color textColor = Colors.black,
  bool isLoading = false,
}) =>
    MaterialButton(
      elevation: elevation,
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      // padding: EdgeInsets.all(10),
      height: 10,
      onPressed: onPressed,
      child: isLoading
          ? Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: textColor,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
                Icon(
                  icon,
                  color: textColor,
                ),
              ],
            ),
    );

Widget defaultDivider() => Divider(
      thickness: 0.5,
      color: primaryColor,
      height: 0,
    );

Widget noData(String text) => Center(
      child: Text(
        text,
        style: thirdTextStyle(null).copyWith(color: Colors.grey),
      ),
    );

void defaultAlertDialog({
  required BuildContext context,
  required String title,
  required String subTitle,
  required String buttonConfirm,
  required String buttonReject,
  required void Function() onConfirm,
  required void Function() onReject,
  bool isLoading = false,
  Color? confirmButtonColor,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(subTitle),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(buttonReject),
            onPressed: () {
              onReject();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: isLoading == false
                ? Text(buttonConfirm,
                    style: TextStyle(
                      color: confirmButtonColor,
                    ))
                : Container(
                    width: 20, height: 20, child: CircularProgressIndicator()),
            onPressed: () {
              onConfirm();
            },
          ),
        ],
      );
    },
  );
}

Future<void> alertDialogImagePicker({
  required BuildContext context,
  required cubit,
  required Function() onTap,
}) async {
  await showDialog(
    context: context,
    builder: (con) {
      return AlertDialog(
        title: Text(
          context.tr.choose_image_from + ' :',
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () async {
                await cubit.getImage(ImageSource.gallery);
                onTap();
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: secondaryColor,
                child: Icon(
                  Icons.image_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await cubit.getImage(ImageSource.camera);
                onTap();
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: secondaryColor,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Color resultPercentageColor(int percent) {
  if (percent > 75)
    return successColor;
  else if (percent >= 50)
    return Colors.orangeAccent;
  else
    return errorColor;
}

Widget defaultModalSheetTopControl() => Container(
      width: 90.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    );

Widget listTile(
    {required String title, required String asset, double? fontSize}) {
  return Container(
    height: 35.h,
    child: ListTile(
      title: Text(
        title,
        style: secondaryTextStyle(null).copyWith(fontSize: fontSize),
        maxLines: 1,
      ),
      leading: SvgPicture.asset(asset),
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 12,
    ),
  );
}

void showDeleteDialog(
  BuildContext context, {
  Function()? onDelete,
  required String name,
}) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("${context.tr.sure_to_delete} $name؟"),
          actions: <Widget>[
            TextButton(
              child: Text(
                context.tr.cancel,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                context.tr.delete,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: onDelete ?? () {},
            ),
          ],
        );
      });
}
