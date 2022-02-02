import 'package:e_learning/models/teacher/test/test_response_model.dart';

class ChampionResponseModel {
  bool? status;
  String? message;
  Champion? champion;

  ChampionResponseModel({this.status, this.message, this.champion});

  ChampionResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    champion = json['champion'] != null
        ? new Champion.fromJson(json['champion'])
        : null;
  }
}

class Champion {
  List<ChampionData>? championData = [];
  Links? links;
  Meta? meta;

  Champion({this.championData, this.links, this.meta});

  Champion.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        championData!.add(new ChampionData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }
}

class ChampionData {
  bool? myChampion;
  String? status;
  String? results;
  Test? test;

  ChampionData({this.myChampion, this.status, this.results, this.test});

  ChampionData.fromJson(Map<String, dynamic> json) {
    myChampion = json['mychampion'];
    status = json['status'];
    results = json['results'];
    test = json['test'] != null ? new Test.fromJson(json['test'], false) : null;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}
