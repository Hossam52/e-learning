import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmExit extends StatelessWidget {
  const ConfirmExit({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('Will Pop from new');
        final result = await showDialog(
          context: context,
          builder: (_) => _confirmDialogWidget(),
        );
        return result != null && result;
      },
      child: child,
    );
  }

  Widget _confirmDialogWidget() {
    return AlertDialog(
      title: Text(
        'Are you sure to exit',
        style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
      ),
      actions: [
        _confirmAction('Yes', true, Colors.red),
        _confirmAction('No', false, Colors.black),
      ],
    );
  }

  Widget _confirmAction(String text, bool val, Color color) {
    return Builder(builder: (context) {
      return TextButton(
          onPressed: () {
            Navigator.of(context).pop(val);
          },
          child: Text(text),
          style:
              ButtonStyle(foregroundColor: MaterialStateProperty.all(color)));
    });
  }
}
