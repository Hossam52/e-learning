import 'package:e_learning/models/onboarding_model.dart';
import 'package:e_learning/modules/auth/introduce/introduce_screen.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/widgets/default_button.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:e_learning/shared/responsive_ui/responsive_widget.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:e_learning/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'build_boarding_item.dart';

class OnBoardingScreen extends StatefulWidget {

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController boardController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    var text = AppLocalizations.of(context);

    // boarding list
    List<BoardingModel> boarding = [
      BoardingModel(
        image: "assets/images/onboarding_0.png",
        title: text!.boarding1,
        last: false,
      ),
      BoardingModel(
        image: "assets/images/onboarding_1.png",
        title: text.boarding2,
        last: false,
      ),
      BoardingModel(
        image: "assets/images/onboarding_2.png",
        title: text.boarding3,
        last: true,
      ),
    ];

    void skipSubmit() {
      CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
        if(value) {
          navigateToAndFinish(context, IntroduceScreen());
          print('done');
        }
      });
    }

    return Scaffold(
      body: responsiveWidget(responsive: (context, deviceInfo) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        if(isLast)
                          skipSubmit();
                        else {
                          boardController.animateToPage(
                            boarding.indexOf(boarding.last),
                            duration: Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeInOutQuad,
                          );
                        }
                      },
                      child: Text(
                        text.skip,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                        // textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: boardController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        BuildBoardingItem(model: boarding[index],),
                    itemCount: boarding.length,
                    onPageChanged: (int index)
                    {
                      if(index == boarding.indexOf(boarding.last)) {
                        setState(() {
                          isLast = true;
                        });
                      }
                      else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 140,
                      child: DefaultAppButton(
                        onPressed: () {
                          if(isLast) {
                            skipSubmit();
                          } else {
                            boardController.nextPage(
                              duration: Duration(
                                milliseconds: 500,
                              ),
                              curve: Curves.easeInOutQuad,
                            );
                          }
                        },
                        text: isLast ? text.start : text.next,
                        background: primaryColor,
                        isLoading: false,
                        textStyle: thirdTextStyle(deviceInfo),
                        isDisabled: false,
                      ),
                    ),
                    Spacer(),
                    SmoothPageIndicator(
                      controller: boardController,
                      count: boarding.length,
                      effect: ExpandingDotsEffect(
                        dotColor: (Colors.grey[400])!,
                        activeDotColor: primaryColor,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 2.7,
                        spacing: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      ),
    );
  }
}
