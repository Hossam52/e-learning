import 'dart:io';

import 'package:dio/dio.dart';

Future<MultipartFile> uploadFile(File file) async {
  return await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
}
