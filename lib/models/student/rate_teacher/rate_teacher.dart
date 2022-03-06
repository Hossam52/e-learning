import 'dart:convert';

class RateTeacherModel {
  bool status;
  bool authType;
  String message;
  RateTeacherModel({
    required this.status,
    required this.authType,
    required this.message,
  });

  RateTeacherModel copyWith({
    bool? status,
    bool? authType,
    String? message,
  }) {
    return RateTeacherModel(
      status: status ?? this.status,
      authType: authType ?? this.authType,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'authType': authType,
      'message': message,
    };
  }

  factory RateTeacherModel.fromMap(Map<String, dynamic> map) {
    return RateTeacherModel(
      status: map['status'] ?? false,
      authType: map['authType'] ?? false,
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RateTeacherModel.fromJson(String source) =>
      RateTeacherModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RateTeacherModel(status: $status, authType: $authType, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RateTeacherModel &&
        other.status == status &&
        other.authType == authType &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ authType.hashCode ^ message.hashCode;
}
