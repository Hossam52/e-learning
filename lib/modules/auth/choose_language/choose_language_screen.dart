import 'package:e_learning/modules/auth/on_boarding/on_boarding_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

import 'build_choose_language.dart';

enum Language { arabic, english }

class ChooseLanguageScreen extends StatefulWidget {
  static String routeName = 'choose_language_screen';

  @override
  _ChooseLanguageScreenState createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  bool selectedLanguageArabic = true;
  Language language = Language.arabic;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color(0xffF7F8FB),
        body: responsiveWidget(responsive: (context, deviceInfo)
        {
          return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/7800@3x.png',
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 50),
                      Text(
                        'اختر اللغة',
                        style: TextStyle(
                          fontSize: deviceInfo.screenHeight * 0.028,
                          color: Color(0xff5F71FE),
                          fontFamily: "NeoSansArabic",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                          'Choose Language',
                          style: TextStyle(
                            fontSize: deviceInfo.screenHeight * 0.028,
                              color: Color(0xff5F71FE),
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                          ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildChooseLanguage(
                            deviceInfo,
                            choose: () {
                              setState(() {
                                language = Language.arabic;
                              });
                              AppCubit.get(context).changeLocaleApp('ar');
                              navigateTo(context, OnBoardingScreen());
                              lang = 'ar';
                              CacheHelper.saveData(
                                key: 'lang',
                                value: 'ar',
                              );
                            },
                            label: 'ع',
                            text: 'عربي',
                            colorContainer: language == Language.arabic
                                ? Colors.white
                                : Color(0xffF8F8FF),
                            colorLabel: language == Language.arabic
                                ? selectedColorLabel
                                : unselectedColorLabel,
                            colorText: language == Language.arabic
                                ? selectedColorText
                                : unselectedColorText,
                          ),
                          // Expanded(child: Container()),
                          SizedBox(width: 20),
                          buildChooseLanguage(
                            deviceInfo,
                            choose: () {
                              setState(() {
                                language = Language.english;
                              });
                              AppCubit.get(context).changeLocaleApp('en');
                              navigateTo(context, OnBoardingScreen());
                              lang = 'en';
                              CacheHelper.saveData(
                                key: 'lang',
                                value: 'en',
                              );
                            },
                            label: 'aA',
                            text: 'English',
                            colorContainer: language == Language.english
                                ? Colors.white
                                : Color(0xffF8F8FF),
                            colorLabel: language == Language.english
                                ? selectedColorLabel
                                : unselectedColorLabel,
                            colorText: language == Language.english
                                ? selectedColorText
                                : unselectedColorText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        }));
  }
}
