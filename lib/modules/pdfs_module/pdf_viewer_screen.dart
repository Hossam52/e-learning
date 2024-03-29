import 'package:e_learning/modules/pdfs_module/cubit/cubit.dart';
import 'package:e_learning/modules/pdfs_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class PdfViewerScreen extends StatelessWidget {
  PdfViewerScreen({Key? key, required this.url, required this.title})
      : super(key: key);

  final String url;
  final String title;

  Key key = Key('dasfa');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            BlocProvider(
              create: (context) => FilesCubit()..changeFileCounter(),
              child: BlocBuilder<FilesCubit, FilesStates>(
                builder: (context, state) {
                  FilesCubit cubit = FilesCubit.get(context);

                  return IconButton(
                      icon: state is! FileDownloadLoadingState
                          ? Icon(state is! FileDownloadSuccessState
                              ? Icons.download
                              : Icons.done)
                          : Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: cubit.precentage,
                                color: Colors.red,
                              )),
                      tooltip: context.tr.download,
                      onPressed: () => state is! FileDownloadSuccessState
                          ? cubit.downloadFile(url, title)
                          : showSnackBar(
                              context: context,
                              text: context.tr.file_downloaded_before));
                },
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SfPdfViewer.network(
                url,
                onDocumentLoadFailed: (detail) {
                  print(detail.description);
                },
              ),
            ),
          ],
        ));
  }
}

class DownloadFile extends StatefulWidget {
  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
