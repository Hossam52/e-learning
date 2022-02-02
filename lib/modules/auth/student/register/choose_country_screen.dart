import 'package:e_learning/modules/auth/cubit/cubit.dart';
import 'package:e_learning/modules/auth/cubit/states.dart';
import 'package:e_learning/shared/componants/widgets/default_gesture_widget.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseCountryScreen extends StatefulWidget {
  ChooseCountryScreen({
    required this.cubit,
    required this.countries,
  });

  final AuthCubit cubit;
  final List countries;

  @override
  _ChooseCountryScreenState createState() => _ChooseCountryScreenState();
}

class _ChooseCountryScreenState extends State<ChooseCountryScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthCubit.get(context).getAllCountriesAndStages();
  }

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          text!.country,
        ),
        elevation: 2,
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return DefaultGestureWidget(
              child: responsiveWidget(
                responsive: (context, deviceInfo) => Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      widget.cubit.getAllCountriesAndStagesModel != null,
                  fallbackBuilder: (context) => DefaultLoader(),
                  widgetBuilder: (context) => Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            thickness: 1,
                          ),
                          itemCount: widget.countries.length,
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          itemBuilder: (context, index) => Card(
                            margin: EdgeInsets.zero,
                            color: backgroundColor,
                            elevation: 0,
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                widget.cubit
                                    .onChangeCountry(widget.countries[index]);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.countries[index],
                                      style: thirdTextStyle(deviceInfo),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
