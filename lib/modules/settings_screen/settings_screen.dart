import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/componants/widgets/default_drop_down.dart';
import 'package:e_learning/shared/cubit/cubit.dart';
import 'package:e_learning/shared/cubit/states.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'build_row_setting.dart';

class SettingsScreen extends StatelessWidget {
  static final String routeName = 'settingsScreen';
  final double sizeBetweenItems = 0.015;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFF0FC),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.tr.settings,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Color(0xffEFF0FC),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return responsiveWidget(
            responsive: (_, deviceInfo) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: buildRowSetting(
                        title: context.tr.language,
                        child: Expanded(
                          child: DefaultDropDown(
                            onChanged: (value) {
                              AppCubit.get(context).changeLocaleApp(
                                  value == context.tr.arabic ? 'ar' : 'en');
                            },
                            validator: (value) {},
                            items: [context.tr.arabic, context.tr.english],
                            selectedValue: lang == 'ar'
                                ? context.tr.arabic
                                : context.tr.english,
                          ),
                        ),
                        deviceInfo: deviceInfo,
                      ),
                      decoration: containerDecoration,
                    ),
                    SizedBox(
                      height: deviceInfo.screenHeight * sizeBetweenItems,
                    ),
                    Container(
                      decoration: containerDecoration,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          buildRowSetting(
                              title: context.tr.show_id_on_profile,
                              child: Switch(
                                  value: true, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                          SizedBox(
                            height: deviceInfo.screenHeight * sizeBetweenItems,
                          ),
                          buildRowSetting(
                              title: context.tr
                                  .enable_users_write_to_my_profile, // 'تمكين المستخدمين من الكتابة على بروفايلي',
                              child: Switch(
                                  value: false, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceInfo.screenHeight * sizeBetweenItems,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: containerDecoration,
                      child: Column(
                        children: [
                          buildRowSetting(
                              title:
                                  context.tr.recieve_notification_from_outside,
                              child: Switch(
                                  value: false, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                          SizedBox(
                            height: deviceInfo.screenHeight * sizeBetweenItems,
                          ),
                          buildRowSetting(
                              title: context.tr
                                  .recieve_notification_from_followed_teachers,
                              child: Switch(
                                  value: false, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                          SizedBox(
                            height: deviceInfo.screenHeight * sizeBetweenItems,
                          ),
                          buildRowSetting(
                              title: context.tr.compititors_notifications,
                              child: Switch(
                                  value: false, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
