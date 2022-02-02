import 'package:e_learning/models/teacher/groups/group_response_model.dart';

class GroupsStudentResponse {
  bool? status;
  String? message;
  Groups? groups;

  GroupsStudentResponse({this.status, this.message, this.groups});

  GroupsStudentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    groups =
    json['groups'] != null ? new Groups.fromJson(json['groups']) : null;
  }
}

class Groups {
  List<Group>? groupsData = [];
  Links? links;
  Meta? meta;

  Groups({this.groupsData, this.links, this.meta});

  Groups.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        groupsData!.add(new Group.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
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
