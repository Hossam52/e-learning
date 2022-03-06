import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/introduce/introduce_screen.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';

import 'componants.dart';

void signOutStudent(context) async {
  try {
    await AuthCubit.get(context).logoutMethod(true);
    CacheHelper.removeData(key: 'studentToken');
    CacheHelper.removeData(key: 'teacherToken');
    studentToken = null;
    teacherToken = null;
    navigateToAndFinish(context, IntroduceScreen());
  } catch (e) {
    throw e;
  }
}

void signOutTeacher(context) async {
  try {
    await AuthCubit.get(context).logoutMethod(false);
    await CacheHelper.removeData(key: 'teacherToken');
    await CacheHelper.removeData(key: 'studentToken');
    teacherToken = null;
    studentToken = null;
    navigateToAndFinish(context, IntroduceScreen());
  } catch (e) {
    throw e;
  }
}

// Print full text
void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

// token
String? studentToken;
String? teacherToken;
bool authType = false;
String? date;
int testCounter = 0;
int challengesCounter = 0;
int filesCounter = 0;

// language
String? lang;
