import 'package:e_learning/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
    required this.initializers,
    required this.startWidget,
    required this.image,
    this.imageSize = 150,
    this.backgroundColor,
  }) : super(key: key);

  final Future Function() initializers;
  final Widget startWidget;
  final String image;
  final double imageSize;
  final Color? backgroundColor;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /// We require the initializers to run after the loading screen is rendered
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      runInitTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
      ),
      backgroundColor: widget.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              widget.image,
              width: widget.imageSize,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 75,
          ),
          SizedBox(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  @protected
  Future runInitTasks() async {
    try {
      await widget.initializers();
      Future.delayed(Duration(milliseconds: 300),
          () => navigateToAndFinish(context, widget.startWidget));
    } catch (e) {
      print(e.toString());
      navigateToAndFinish(context, widget.startWidget);
    }
  }
}
