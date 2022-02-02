class NotificationResponseModel {
  bool? status;
  Notifications? notifications;

  NotificationResponseModel({this.status, this.notifications});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notifications = json['notifications'] != null
        ? new Notifications.fromJson(json['notifications'])
        : null;
  }
}

class Notifications {
  List<NotificationData>? data = [];
  Links? links;
  Meta? meta;

  Notifications({this.data, this.links, this.meta});

  Notifications.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

class NotificationData {
  int? id;
  String? title;
  String? body;
  StudentSender? studentSender;
  dynamic teacherSender;
  bool? read;

  NotificationData(
      {this.id,
        this.title,
        this.body,
        this.studentSender,
        this.teacherSender,
        this.read});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    studentSender = json['studentSender'] != null
        ? new StudentSender.fromJson(json['studentSender'])
        : null;
    teacherSender = json['TecherSender'];
    read = json['read'];
  }
}

class StudentSender {
  int? id;
  String? name;
  String? code;
  String? email;
  String? country;
  String? classroom;
  String? image;

  StudentSender(
      {this.id,
        this.name,
        this.code,
        this.email,
        this.country,
        this.classroom,
        this.image});

  StudentSender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    email = json['email'];
    country = json['country'];
    classroom = json['classroom'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['email'] = this.email;
    data['country'] = this.country;
    data['classroom'] = this.classroom;
    data['image'] = this.image;
    return data;
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}
