import 'package:dio/dio.dart';
import 'package:e_learning/models/enums/enums.dart';

class CommentModel {
  late int id;
  late String text;
  String? image;

  CommentModel({
    required this.id,
    required this.text,
    this.image,
  });


  FormData toFormData(CommentType type) {
    FormData formData;
    switch (type) {
      case CommentType.Add:
        formData = FormData.fromMap({
          'text': this.text,
          if (image != null) 'images': MultipartFile.fromFileSync(image!),
          'post_id': this.id,
        });
        break;
      case CommentType.Edit:
        formData = FormData.fromMap({
          'text': this.text,
          if (image != null) 'images': MultipartFile.fromFileSync(image!),
          'comment_id': this.id,
        });
        break;
      case CommentType.playlistVideo:
        formData = FormData.fromMap({
          'text': this.text,
          if (image != null) 'images': MultipartFile.fromFileSync(image!),
          'playlistdetail_id': this.id,
        });
        break;
      case CommentType.groupVideo:
        formData = FormData.fromMap({
          'text': this.text,
          if (image != null) 'images': MultipartFile.fromFileSync(image!),
          'video_id': this.id,
        });
        break;
    }
    return formData;
  }
}
