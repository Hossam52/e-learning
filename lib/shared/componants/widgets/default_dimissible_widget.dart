import 'package:e_learning/shared/componants/extentions.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class DefaultDismissibleWidget extends StatelessWidget {
  const DefaultDismissibleWidget({
    Key? key,
    required this.child,
    required this.onDelete,
    required this.onEdit,
    required this.name,
    required this.hasEdit,
    required this.widgetContext,
  }) : super(key: key);

  final Widget child;
  final Function onDelete;
  final Function onEdit;
  final String name;
  final bool hasEdit;
  final BuildContext widgetContext;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: hasEdit ? editWidget() : deleteWidget(),
      secondaryBackground: hasEdit ? deleteWidget() : null,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("${context.tr.sure_to_delete} $name؟"),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        context.tr.cancel,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(widgetContext).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        context.tr.delete,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        onDelete();
                        Navigator.of(widgetContext).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          onEdit();
        }
      },
      child: child,
    );
  }

  Widget deleteWidget() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: errorColor,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 32,
        ),
      );

  Widget editWidget() => Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: hasEdit ? primaryColor : errorColor,
        child: Icon(
          hasEdit ? Icons.edit_outlined : Icons.delete_outline,
          color: Colors.white,
          size: 32,
        ),
      );
}
