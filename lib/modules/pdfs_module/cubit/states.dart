abstract class FilesStates {}

class AppInitialState extends FilesStates {}

/// Teacher File Post States
class FilePostLoadingState extends FilesStates {}

class FilePostSuccessState extends FilesStates {}

class FilePostErrorState extends FilesStates {}

/// Teacher validate File States
class ValidateFileLoadingState extends FilesStates {}

class ValidateFileSuccessState extends FilesStates {}

class ValidateFileErrorState extends FilesStates {}

/// Teacher Get Subject Files States
class GetSubjectFilesLoadingState extends FilesStates {}

class GetSubjectFilesSuccessState extends FilesStates {}

class GetSubjectFilesErrorState extends FilesStates {}

/// Teacher Delete Subject File States
class FileDeleteLoadingState extends FilesStates {}

class FileDeleteSuccessState extends FilesStates {}

class FileDeleteErrorState extends FilesStates {}

/// File download
class FileDownloadLoadingState extends FilesStates {}

class FileDownloadSuccessState extends FilesStates {}

class FileDownloadErrorState extends FilesStates {}

