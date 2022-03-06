import 'package:flutter/cupertino.dart';

import 'device_information.dart';
import 'get_device_type.dart';

Widget responsiveWidget(
    {required Widget responsive(context,DeviceInformation deviceInformation)}) 
    {
  return LayoutBuilder(builder: (context, constraints) 
  {
    var mediaQuereyData = MediaQuery.of(context);
    DeviceInformation deviceInformation = DeviceInformation(
        deviceType: getDeviceType(mediaQuereyData),
        localHeight: constraints.maxHeight,
        localWidth: constraints.maxWidth,
        screenHeight: mediaQuereyData.size.height,
        screenwidth: mediaQuereyData.size.width,
        orientation: mediaQuereyData.orientation);
    return responsive(context, deviceInformation);
  });
}
