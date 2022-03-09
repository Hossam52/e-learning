import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class FriendRequestBuildItem extends StatelessWidget {
  const FriendRequestBuildItem({
    Key? key,
    required this.deviceInfo,
    required this.name,
    required this.image,
    required this.onAccept,
    required this.onReject,
    required this.isLoading,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final String name;
  final String image;
  final Function() onAccept;
  final Function() onReject;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: deviceInfo.screenwidth * 0.13,
            height: deviceInfo.screenwidth * 0.13,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  image,
                ),
              ),
            ),
          ),
          SizedBox(width: deviceInfo.screenwidth * 0.02),
          Text(name),
          Spacer(),
          Container(
            width: deviceInfo.screenwidth * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: isLoading ? null : onAccept,
                    color: successColor,
                    child: isLoading
                        ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : Icon(Icons.check),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    onPressed: isLoading ? null : onReject,
                    color: errorColor,
                    child: isLoading
                        ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : Icon(Icons.close),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
