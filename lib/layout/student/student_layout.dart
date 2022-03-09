import 'package:e_learning/layout/student/student_drawer_build_item.dart';
import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/modules/notifications/cubit/notification_cubit.dart';
import 'package:e_learning/modules/notifications/notification_screen.dart';
import 'package:e_learning/modules/search/student/student_search.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/icons/my_icons_icons.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/no_data_widget.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentLayout extends StatelessWidget {
  final topTeacherFollowing = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context)!;

    AppCubit appCubit = AppCubit.get(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) => DefaultTabController(
        length: 2,
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AuthCubit authCubit = AuthCubit.get(context);
            return Conditional.single(
              context: context,
              conditionBuilder: (context) => authCubit.profileDataLoading ==false,
              fallbackBuilder: (context) => Scaffold(body: DefaultLoader()),
              widgetBuilder: (context) => authCubit.noProfileData
                  ? Scaffold(
                  body: NoDataWidget(onPressed: ()
                  => authCubit.getProfile(true)))
                  :  Scaffold(
                key: scaffoldKey,
                backgroundColor: backgroundColor,
                drawer: Drawer(
                  child: StudentDrawerBuildItem(text: text, appCubit: appCubit),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: appCubit.currentIndex,
                  onTap: (index) {
                    appCubit.changeBottomNav(index);
                  },
                  elevation: 5,
                  selectedItemColor: primaryColor,
                  showUnselectedLabels: true,
                  unselectedItemColor: Colors.black,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(MyIcons.home),
                      label: text.home,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people_outline, size: 27),
                      label: text.my_groups,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(MyIcons.calendar),
                      label: text.my_schedule,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_rounded, size: 27),
                      label: text.my_profile,
                    ),
                  ],
                ),
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(appCubit.selectedTitle(text)),
                  elevation: 1,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(
                          MyIcons.menu,
                          color: primaryColor,
                          size: 18,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        navigateTo(context, StudentSearchScreen());
                      },
                      icon: Icon(CupertinoIcons.search),
                      padding: EdgeInsets.zero,
                    ),
                    BlocProvider(
                                create: (context) => NotificationCubit()
                                  ..getAllNotifications(
                                      NotificationType.Student),
                                child: BlocBuilder<NotificationCubit, NotificationState>(
                                  builder: (cubitContext, state) {
                                    return
                                     Stack(
                                      children: [
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () 
                                            {
                                              navigateTo(
                                                  context,
                                                  NotificationScreen(
                                                      type: NotificationType
                                                          .Student,cubitContext:cubitContext));
                                            },
                                            icon: Icon(
                                              MyIcons.bell,
                                            )),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            radius: 7.5,
                                            child:
                                          state is! NotificationGetLoading?  Text(
                                              '5',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.015,
                                              ),
                                            ):CircularProgressIndicator(color: Color.fromARGB(255, 243, 25, 9),),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                  ],
                ),
                body: Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: responsiveWidget(responsive: (context, deviceInfo) {
                      return appCubit.selectedScreens[appCubit.currentIndex];
                    },),),
              ),
            );
          },
        ),
      ),
    );
  }
}
