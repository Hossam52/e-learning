import 'package:animations/animations.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Dark theme
ThemeData darkTheme = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: "Janna",
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 30,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
    ),
    elevation: 5,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white,
    backgroundColor: Colors.white,
    elevation: 20,
    unselectedItemColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
);

// Light theme
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  fontFamily: "NeoSansArabic",
  tabBarTheme: TabBarTheme(
    labelStyle: thirdTextStyle(null).copyWith(color: Colors.white),
    unselectedLabelStyle: thirdTextStyle(null).copyWith(color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: backgroundColor,
    titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      fontFamily: "NeoSansArabic",
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 30,
    ),
    elevation: 0,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white,
    backgroundColor: Colors.white,
    elevation: 20,
    unselectedItemColor: Color(0xff3E4A5A),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
  buttonTheme: ButtonThemeData(
    splashColor: primaryColor,
    buttonColor: primaryColor,     //  <-- dark color
    textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
  ),
).copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
