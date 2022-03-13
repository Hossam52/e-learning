import 'dart:developer';

import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/student_layout.dart';
import 'package:e_learning/layout/teacher/teacher_layout.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/introduce/introduce_screen.dart';
import 'package:e_learning/modules/groups/cubit/cubit.dart';
import 'package:e_learning/modules/splash/splash_screen.dart';
import 'package:e_learning/modules/student/cubit/cubit/cubit.dart';
import 'package:e_learning/modules/test_module/cubit/cubit.dart';
import 'package:e_learning/shared/bloc_observer.dart';
import 'package:e_learning/shared/componants/shared_methods.dart';
import 'package:e_learning/shared/network/notification_services/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'l10n/l10n.dart';
import 'modules/auth/choose_language/choose_language_screen.dart';
import 'modules/auth/on_boarding/on_boarding_screen.dart';
import 'shared/componants/constants.dart';
import 'shared/cubit/cubit.dart';
import 'shared/cubit/states.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");
void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      FCM.notificationOnAppBackgroundOrTerminated);
  DioHelper.init(); // Dio Initialize
  await CacheHelper.init(); // Cache Initialize
  log(await SharedMethods.getToken());

  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  lang = CacheHelper.getData(key: 'lang');
  studentToken = CacheHelper.getData(key: 'studentToken');
  teacherToken = CacheHelper.getData(key: 'teacherToken');

  ///
  date = CacheHelper.getData(key: 'date');
  testCounter = CacheHelper.getData(key: 'testCounter') ?? 0;
  challengesCounter = CacheHelper.getData(key: 'challengesCounter') ?? 0;
  filesCounter = CacheHelper.getData(key: 'filesCounter') ?? 0;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  print(teacherToken);
  print(studentToken);
  if (lang != null) {
    if (onBoarding != null) {
      if (studentToken != null)
        widget = StudentLayout();
      else if (teacherToken != null)
        widget = TeacherLayout();
      else
        widget = IntroduceScreen();
    } else
      widget = OnBoardingScreen();
  } else {
    widget = ChooseLanguageScreen();
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatefulWidget {
  final Widget startWidget;

  MyApp({
    required this.startWidget,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    FCM().setNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => GroupCubit()),
        BlocProvider(create: (context) => StudentCubit()),
        BlocProvider(create: (context) => TestCubit()),
        BlocProvider(create: (context) => TestLayoutCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          return ScreenUtilInit(
            designSize: Size(375, 812),
            builder: () => MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Tag Al Qemma',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              // darkTheme: darkTheme,
              themeMode: ThemeMode.light,
              // home: AnimatedSplashScreen.withScreenFunction(
              //   splash: 'assets/images/icons/drawable.png',
              //   screenFunction: () async{
              //     if(startWidget is StudentLayout) {
              //       await AuthCubit.get(context).getProfile(true);
              //     } else if(startWidget is TeacherLayout) {
              //       await AuthCubit.get(context).getProfile(false);
              //     }
              //     return startWidget;
              //   },
              //   splashTransition: SplashTransition.fadeTransition,
              //   splashIconSize: 200,
              // ),
              home: SplashScreen(
                image: 'assets/images/icons/drawable.png',
                initializers: () async {
                  if (widget.startWidget is StudentLayout) {
                    await AuthCubit.get(context).getProfile(true);
                  } else if (widget.startWidget is TeacherLayout) {
                    await AuthCubit.get(context).getProfile(false);
                  }
                },
                startWidget: widget.startWidget,
              ),
              supportedLocales: L10n.all,
              locale: lang != null
                  ? Locale(lang!)
                  : AppCubit.get(context).localeApp,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}
