class GetAllCountriesAndStagesModel {
  GetAllCountriesAndStagesModel({
    this.status,
    this.countries,
  });
  String? status;
  List<Countries>? countries = [];

  GetAllCountriesAndStagesModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    countries = List.from(json['countries']).map((e)=>Countries.fromJson(e)).toList();
  }

}

class Countries {
  Countries({
    this.id,
    this.name,
    this.createdAt,
    this.stages,
  });
  int? id;
  String? name;
  String? createdAt;
  List<Stages>? stages = [];

  Countries.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    stages = List.from(json['stages']).map((e)=>Stages.fromJson(e)).toList();
  }

}

class Stages {
  Stages({
    this.id,
    this.name,
    this.createdAt,
    this.classrooms,
  });
  int? id;
  String? name;
  String? createdAt;
  List<Classrooms>? classrooms = [];

  Stages.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    classrooms = List.from(json['classrooms']).map((e)=>Classrooms.fromJson(e)).toList();
  }
}

class Classrooms {
  Classrooms({
    this.id,
    this.name,
    this.createdAt,
  });
  int? id;
  String? name;
  String? createdAt;

  Classrooms.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }
}