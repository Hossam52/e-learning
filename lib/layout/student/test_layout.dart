import 'package:e_learning/layout/student/cubit/cubit.dart';
import 'package:e_learning/layout/student/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestLayout extends StatelessWidget {
  const TestLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(
      responsive: (context, deviceInfo) {
        return BlocProvider(
          create: (context) => TestLayoutCubit(),
          child: BlocConsumer<TestLayoutCubit, TestLayoutStates>(
            listener: (context, state) {},
            builder: (context, state) {
              TestLayoutCubit appCubit = TestLayoutCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  title: Text(appCubit.selectedTitle()),
                  elevation: 1,
                  centerTitle: true,
                  leading: defaultBackButton(context, deviceInfo.screenHeight),
                ),
                body: responsiveWidget(responsive: (context, deviceInfo) {
                  return appCubit.selectedScreens[appCubit.currentIndex];
                }),
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
                      icon: SvgPicture.asset(
                        'assets/images/icons/test_inactive.svg',
                        width: 20,
                      ),
                      activeIcon: SvgPicture.asset(
                        'assets/images/icons/test_active.svg',
                        width: 25,
                      ),
                      label: context.tr.test,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/images/icons/challenge_inactive.svg',
                        width: 20,
                      ),
                      activeIcon: SvgPicture.asset(
                        'assets/images/icons/challenge_active.svg',
                        width: 25,
                      ),
                      label: context.tr.competition,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/images/icons/my-challenges_inactive.svg',
                        width: 20,
                      ),
                      activeIcon: SvgPicture.asset(
                        'assets/images/icons/my-challenges_active.svg',
                        width: 25,
                      ),
                      // label: 'بطولات',
                      label: context.tr.championships,
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/images/icons/invite_freind_inactive.svg',
                        width: 20,
                      ),
                      activeIcon: SvgPicture.asset(
                        'assets/images/icons/invite_freind_active.svg',
                        width: 25,
                      ),
                      // label: 'دعواتي',
                      label: context.tr.my_invitation,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
