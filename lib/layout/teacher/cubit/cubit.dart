import 'package:e_learning/layout/teacher/cubit/states.dart';
import 'package:e_learning/modules/groups/teacher/teacher_groups_screen.dart';
import 'package:e_learning/modules/home_screen/teacher/teacher_home_screen.dart';
import 'package:e_learning/modules/profile/teacher/teacher_profile_screen.dart';
import 'package:e_learning/modules/teacher/results/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeacherLayoutCubit extends Cubit<TeacherLayoutStates>
{
  // Cubit Constructor
  TeacherLayoutCubit() : super(TeacherLayoutInitialState());
  // Cubit methode
  static TeacherLayoutCubit get(context) => BlocProvider.of(context);


  // variables
  Locale localeApp = Locale('ar');

  // Current nav index
  int currentIndex = 0;
  // List of nav screens
  List<Widget> selectedScreens = [
    TeacherHomeScreen(),
    TeacherGroupsScreen(),
    ResultsScreen(),
    TeacherProfileScreen(),
  ];
  String selectedTitle(BuildContext context)
  {
    var text = AppLocalizations.of(context)!;
    if (currentIndex == 0)
      return text.home;
    else if (currentIndex == 1)
      return text.my_groups;
    else if (currentIndex == 2)
      return text.results;
    else
      return text.my_profile;
  }
  // Change nav function
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void changeLocaleApp(String languageCode) {
    if (localeApp.countryCode != languageCode) {
      localeApp = Locale(languageCode);
      emit(ChangeLanguageState());
    }
  }
  // Home Layout Code
}