import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class DefaultDropDown extends StatelessWidget {
  DefaultDropDown({
    Key? key,
    this.label,
    required this.onChanged,
    required this.validator,
    this.hint,
    required this.items,
    this.selectedValue,
    this.haveBackground = false,
    this.isLoading = false,
  }) : super(key: key);

  String? label;
  String? hint;
  String? selectedValue;
  final Function onChanged;
  String? Function(String?) validator;
  final List<String> items;
  bool haveBackground;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(haveBackground)
          Text(label!),
        Container(
          padding: haveBackground
              ? EdgeInsets.symmetric(horizontal: 16) : null,
          decoration: haveBackground ? BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(13)) : null,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            // hint: haveBackground ? Text(hint) : null,
            decoration: InputDecoration(
              labelText: haveBackground ? null : label,
              hintText: hint,
              border: haveBackground
                  ? UnderlineInputBorder(borderSide: BorderSide.none)
                  : null,
            ),
            value: selectedValue,
            validator: validator,
            onChanged: (newValue) {
              FocusScope.of(context).requestFocus(new FocusNode());
              onChanged(newValue);
            },
            icon: isLoading ? Container(
                width: 20,
                height: 20, child: CircularProgressIndicator()) : null,
            items: items.map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                ).toList(),
          ),
        ),
      ],
    );
  }
}
