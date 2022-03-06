// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

// part 'manage_files_state.dart';

// class ManageFilesCubit extends Cubit<ManageFilesState> {
//   ManageFilesCubit() : super(ManageFilesInitial());
  
//   void downloadFile(String url, String fileName) async {
//     try {
//       print(url);
//       emit(FileDownloadLoadingState());
//       final directory = await getApplicationDocumentsDirectory();
//       File file = File('${directory.path}/$fileName.pdf');
//       // final newDirectory =
//       //     await Directory('/storage/emulated/0/Download/e-learning')
//       //         .create(recursive: true);
//       // final File file = File('${newDirectory.path}/$fileName.pdf');
//       final response = await Dio().get(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           receiveTimeout: 0, //no timeout
//         ),
//         onReceiveProgress: (received, total) 
//         {
//           totalRecieved = ((received / total) * 100).toStringAsFixed(0)+" %";
//           print(received.toString() + ' ' + total.toString());
//         },
//       );
//       final document = file.openSync(mode: FileMode.write);
//       document.writeFromSync(response.data);
//       await document.close();
//       //   document = await http.readBytes(Uri.parse(url));

//       // final raf = file.openSync(mode: FileMode.write);
//       // raf.writeFromSync(document!);
//       // await raf.close();
//       // OpenFile.open(file.path);
//       emit(FileDownloadSuccessState());
//     } catch (e) {
//       emit(FileDownloadErrorState());
//       throw e;
//     }
//   }
// }
