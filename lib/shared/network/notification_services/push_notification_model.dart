// import 'dart:convert';


// class PushNotificationModel {
//   String body;
//   String title;
//   PushNotificationData data;
//   PushNotificationModel({
//     required this.body,
//     required this.title,
//     required this.data,
//   });

//   PushNotificationModel copyWith({
//     String? body,
//     String? title,
//     PushNotificationData? data,
//   }) {
//     return PushNotificationModel(
//       body: body ?? this.body,
//       title: title ?? this.title,
//       data: data ?? this.data,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'body': body,
//       'title': title,
//       'data': data.toMap(),
//     };
//   }

//   factory PushNotificationModel.fromMap(Map<String, dynamic> map) {
//     return PushNotificationModel(
//       body: map['body'] ?? '',
//       title: map['title'] ?? '',
//       data: PushNotificationData.fromJson(map['data']),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory PushNotificationModel.fromJson(String source) =>
//       PushNotificationModel.fromMap(json.decode(source));

//   @override
//   String toString() =>
//       'PushNotificationModel(body: $body, title: $title, data: $data)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is PushNotificationModel &&
//         other.body == body &&
//         other.title == title &&
//         other.data == data;
//   }

//   @override
//   int get hashCode => body.hashCode ^ title.hashCode ^ data.hashCode;
// }

// class PushNotificationData {
//   OrderModel order_id;
//   PushNotificationData({
//     required this.order_id,
//   });

//   PushNotificationData copyWith({
//     OrderModel? order_id,
//   }) {
//     return PushNotificationData(
//       order_id: order_id ?? this.order_id,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'order_id': order_id.toMap(),
//     };
//   }

//   factory PushNotificationData.fromMap(Map<String, dynamic> map) {
//     return PushNotificationData(
//       order_id: OrderModel.fromMap(map['order_id']),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory PushNotificationData.fromJson(String source) =>
//       PushNotificationData.fromMap(json.decode(source));

//   @override
//   String toString() => 'PushNotificationData(order_id: $order_id)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is PushNotificationData && other.order_id == order_id;
//   }

//   @override
//   int get hashCode => order_id.hashCode;
// }
