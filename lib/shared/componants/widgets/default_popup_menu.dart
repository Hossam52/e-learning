import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class DefaultPopupMenu extends StatelessWidget {
  DefaultPopupMenu({
    Key? key,
    required this.items,
    required this.values,
    required this.onSelected,
    this.icons,
  }) : super(key: key);

  final List<String> items;
  List<IconData>? icons;
  final List<String> values;
  final Function(Object? value) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_outlined,
        color: primaryColor,
      ),
      onSelected: onSelected,
      itemBuilder: (context) {
        return List.generate(items.length, (index) {
          return PopupMenuItem(
            child: ListTile(
              title: Text(items[index]),
              leading: icons != null ? Icon(icons![index]) : null,
            ),
            value: values[index],
          );
        });
      },
    );
  }
}
