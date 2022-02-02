import 'package:e_learning/shared/componants/constants.dart';
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
          'الاعدادات',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Color(0xffEFF0FC),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return responsiveWidget(
            responsive: (context, deviceInfo) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: buildRowSetting(
                        title: 'اللغة',
                        child: Expanded(
                          child: DefaultDropDown(
                            onChanged: (value) {
                              AppCubit.get(context).changeLocaleApp(value == 'لعربية'
                                  ? 'ar' : 'en');
                            },
                            validator: (value) {},
                            items: ['لعربية', 'english'],
                            selectedValue: lang == 'ar' ? 'لعربية' : 'english',
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
                              title: 'اظهار الاي دي على بروفايلي',
                              child: Switch(
                                  value: true, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                          SizedBox(
                            height: deviceInfo.screenHeight * sizeBetweenItems,
                          ),
                          buildRowSetting(
                              title: 'تمكين المستخدمين من الكتابة على بروفايلي',
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
                                  'تلقي اشعارات التطبيق على الهاتف من الخارج',
                              child: Switch(
                                  value: false, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                          SizedBox(
                            height: deviceInfo.screenHeight * sizeBetweenItems,
                          ),
                          buildRowSetting(
                              title: 'تلقي اشعارات من المعلمين الذي اتابعهم',
                              child: Switch(
                                  value: false, onChanged: (toggleIdAppear) {}),
                              deviceInfo: deviceInfo),
                          SizedBox(
                            height: deviceInfo.screenHeight * sizeBetweenItems,
                          ),
                          buildRowSetting(
                              title: 'تلقي اشعارات المنافسين',
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
