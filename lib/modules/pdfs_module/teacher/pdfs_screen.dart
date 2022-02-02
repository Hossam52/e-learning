import 'package:e_learning/modules/pdfs_module/cubit/cubit.dart';
import 'package:e_learning/modules/pdfs_module/cubit/states.dart';
import 'package:e_learning/shared/componants/componants.dart';
import 'package:e_learning/shared/componants/constants.dart';
import 'package:e_learning/shared/componants/widgets/default_loader.dart';
import 'package:e_learning/shared/componants/widgets/file_tile_build_item.dart';
import 'package:e_learning/shared/responsive_ui/device_information.dart';
import 'package:e_learning/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pdf_viewer_screen.dart';
import 'add_pdf_screen.dart';

// ignore: must_be_immutable
class PdfsScreen extends StatelessWidget {
  PdfsScreen({
    Key? key,
    required this.isStudent,
    required this.deviceInfo,
    required this.title,
    required this.type,
    required this.subjectId,
    this.teacherId,
  }) : super(key: key);

  final DeviceInformation deviceInfo;
  final bool isStudent;
  final String title;
  final String type;
  final int subjectId;
  int? teacherId;

  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => FilesCubit()
        ..getFiles(
          isStudent: isStudent,
          teacherId: teacherId,
          subjectId: subjectId,
          type: type,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          elevation: 1,
          centerTitle: true,
          leading: defaultBackButton(context, deviceInfo.screenHeight),
        ),
        floatingActionButton: isStudent
            ? null
            : BlocBuilder<FilesCubit, FilesStates>(
                builder: (context, state) {
                  return FloatingActionButton(
                    onPressed: () {
                      navigateTo(
                          context,
                          AddPdfScreen(
                            title: title,
                            deviceInfo: deviceInfo,
                            type: type,
                            oldContext: context,
                          ));
                    },
                    child: Icon(Icons.add),
                  );
                },
              ),
        body: BlocConsumer<FilesCubit, FilesStates>(
          listener: (context, state) {},
          builder: (context, state) {
            FilesCubit cubit = FilesCubit.get(context);
            return Conditional.single(
              context: context,
              conditionBuilder: (context) =>
                  state is! GetSubjectFilesLoadingState,
              fallbackBuilder: (context) => DefaultLoader(),
              widgetBuilder: (context) => cubit.noFilesFound
                  ? noData('لا يوجد ملفات حتى الان')
                  : ListView.separated(
                      itemCount: cubit.getSubjectFilesModel!.files!.length,
                      padding: EdgeInsets.all(22),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        var file = cubit.getSubjectFilesModel!.files![index];
                        return FileTileBuildItem(
                          isStudent: isStudent,
                          deviceInfo: deviceInfo,
                          text: file.name!,
                          fileId: file.fileId!,
                          onTap: () {
                            if (filesCounter < 10) {
                              navigateTo(
                                context,
                                PdfViewerScreen(
                                  url:
                                      'https://drive.google.com/u/0/uc?id=${file.fileId!}&export=download',
                                  title: file.name!,
                                ),
                              );
                            } else {
                              showSnackBar(
                                context: context,
                                text: translate.you_reached_limit,
                                backgroundColor: errorColor,
                              );
                            }
                          },
                          onEdit: () {},
                          onDelete: () {
                            cubit.deleteTeacherFileWithId(
                              fileId:
                                  cubit.getSubjectFilesModel!.files![index].id!,
                              context: context,
                              subjectId: subjectId,
                              type: type,
                            );
                          },
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
