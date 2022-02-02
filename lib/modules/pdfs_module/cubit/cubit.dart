import 'dart:io';
import 'dart:typed_data';
import 'package:e_learning/models/teacher/files_module/teacher_get_subject_files.dart';
import 'package:e_learning/modules/pdfs_module/cubit/states.dart';
import 'package:e_learning/shared/network/end_points.dart';
import 'package:e_learning/shared/network/local/cache_helper.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_learning/models/teacher/files_module/filePostDataModel.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_state_button/progress_button.dart';

class FilesCubit extends Cubit<FilesStates> {
  // Cubit Constructor
  FilesCubit() : super(AppInitialState());

  // Cubit methode
  static FilesCubit get(context) => BlocProvider.of(context);

  /// ------------------------------------------------------
  /// Teacher
  FilePostDataModel? filePostDataModel;
  ButtonState addFileButtonState = ButtonState.idle;
  bool hasFileError = false;
  void filePostMethod({
    required BuildContext context,
    required String name,
    required int stageId,
    required int classroomId,
    required int termId,
    required int subjectId,
    required String url,
    required String type,
  }) async {
    try {
      hasFileError = false;
      addFileButtonState = ButtonState.loading;
      emit(FilePostLoadingState());
      Response response = await DioHelper.postFormData(
        url: TEACHER_POST_FILE,
        token: teacherToken,
        formData: FormData.fromMap({
          'name': name,
          'stage_id': stageId,
          'classroom_id': classroomId,
          'term_id': termId,
          'subject_id': subjectId,
          'url': url,
          'type': type,
        }),
      );
      if (response.data['status']) {
        addFileButtonState = ButtonState.success;
        filePostDataModel = FilePostDataModel.fromJson(response.data);
        getFiles(isStudent: false, subjectId: subjectId, type: type);
        emit(FilePostSuccessState());
      } else {
        addFileButtonState = ButtonState.fail;
        showSnackBar(context: context, text: response.data['message']);
        if(response.data['message'] == 'site.Url Is Not Valid') {
          hasFileError = true;
        }
        emit(FilePostErrorState());
      }
    } catch (e) {
      addFileButtonState = ButtonState.fail;
      emit(FilePostErrorState());
      throw e;
    }
  }

  /// Teacher get subject files
  TeacherGetSubjectFilesModel? getSubjectFilesModel;
  bool noFilesFound = false;

  void getFiles({
    required bool isStudent,
    required int subjectId,
    required String type,
    int? teacherId,
  }) async {
    emit(GetSubjectFilesLoadingState());
    try {
      Response response = await DioHelper.postFormData(
        url: isStudent ? STUDENT_GET_SUBJECT_FILES : TEACHER_GET_SUBJECT_FILES,
        token: isStudent ? studentToken : teacherToken,
        formData: FormData.fromMap({
          'subject_id': subjectId,
          'type': type,
          if (isStudent) 'teacher_id': teacherId,
        }),
      );
      if (response.data['status']) {
        getSubjectFilesModel =
            TeacherGetSubjectFilesModel.fromJson(response.data);
        noFilesFound = false;
        emit(GetSubjectFilesSuccessState());
      } else {
        noFilesFound = true;
        emit(GetSubjectFilesErrorState());
      }
    } catch (e) {
      noFilesFound = true;
      emit(GetSubjectFilesErrorState());
      throw e;
    }
  }

  /// Delete File with id
  void deleteTeacherFileWithId({
    required int fileId,
    required BuildContext context,
    required int subjectId,
    required String type,
  }) {
    emit(FileDeleteLoadingState());
    DioHelper.postFormData(
      url: TEACHER_DELETE_FILE_WITH_ID,
      token: teacherToken,
      formData: FormData.fromMap({'teacherfile_id': fileId}),
    ).then((value) {
      if (value.data['status']) {
        emit(FileDeleteSuccessState());
        showSnackBar(context: context, text: value.data['message']);
      } else {
        emit(FileDeleteErrorState());
        print(value.data['message']);
      }
      getFiles(
        subjectId: subjectId,
        type: type,
        isStudent: false,
      );
    }).catchError((error) {
      print(error.toString());
      emit(FileDeleteErrorState());
    });
  }

  /// download pdf file method
  Uint8List? document;
  void downloadFile(String url, String fileName) async {
    try {
      emit(FileDownloadLoadingState());
      final newDirectory =
      await Directory('/storage/emulated/0/Download/e-learning').create(recursive: true);
      final File file = File('${newDirectory.path}/$fileName.pdf');

      document = await http.readBytes(Uri.parse(url));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(document!);
      await raf.close();
      OpenFile.open(file.path);
      emit(FileDownloadSuccessState());
    } catch (e) {
      emit(FileDownloadErrorState());
      throw e;
    }
  }
  void changeFileCounter() {
    filesCounter = filesCounter + 1;
    CacheHelper.saveData(key: 'filesCounter', value: filesCounter);
  }
}
