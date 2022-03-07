class PostResponseModel {
  bool? status;
  String? message;
  Post? post;

  PostResponseModel({this.status, this.message, this.post});

  PostResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }
}

class Post {
  int? id;
  String? text;
  String? teacher;
  String? student;
  String? teacherImage;
  String? studentImage;
  bool? adminPost;
  bool? studentPost;
  bool? teacherPost;
  bool? answer;
  int? likesNum;
  bool? authLikeTeacher;
  bool? authLikeStudent;
  String? date;
  String? studentId;
  String? teacherId;
  List<Comments>? comments = [];
  List<String>? images = [];

  Post({
    this.id,
    this.text,
    this.images,
    this.teacher,
    this.student,
    this.teacherImage,
    this.studentImage,
    this.adminPost,
    this.studentPost,
    this.teacherPost,
    this.answer,
    this.likesNum,
    this.authLikeTeacher,
    this.authLikeStudent,
    this.date,
    this.comments,
  });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    if (json['images'] != null) images = json['images'].cast<String>();
    teacher = json['teacher'];
    student = json['student'];
    teacherImage = json['teacher_image'];
    studentImage = json['student_image'];
    studentId = json['student_id']??'';
    teacherId = json['teacher_id']??'';
    adminPost = json['adminPost'];
    studentPost = json['studentPost']??false;
    teacherPost = json['teacherPost']??false;
    answer = json['answer'];
    likesNum = json['likes_num'];
    authLikeTeacher = json['authLikeTeacher'];
    authLikeStudent = json['authLikeStudent'];
    date = json['date'];
    if (json['comments'] != null) {
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }
}

class Comments {
  int? id;
  String? text;
  String? images;
  String? teacher;
  String? student;
  String? code;
  bool? adminComment;
  String? teacherImage;
  String? studentImage;
  bool? studentComment;
  bool? teacherComment;
  String? date;

  Comments({
    this.id,
    this.text,
    this.images,
    this.teacher,
    this.student,
    this.code,
    this.adminComment,
    this.teacherImage,
    this.studentImage,
    this.studentComment,
    this.teacherComment,
    this.date,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    images = json['images'];
    teacher = json['teacher'];
    student = json['student'];
    code = json['code'];
    adminComment = json['adminComment'];
    teacherImage = json['teacher_image'];
    studentImage = json['student_image'];
    studentComment = json['studentComment'];
    teacherComment = json['teacherComment'];
    date = json['date'];
  }
}
