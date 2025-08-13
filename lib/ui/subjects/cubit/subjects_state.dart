part of 'subjects_cubit.dart';

class SubjectsState extends Equatable {
  const SubjectsState({
    this.exception,
    this.getDocumentsStatus = WidgetStatus.initial,
    this.documents,
    this.documentsQuery = "",
    this.uploadStatus = WidgetStatus.initial,
    this.fileSelected,
    this.documentSelected,
    this.downloadPercent,
    this.deleteStatus = WidgetStatus.initial,
  });

  // General
  final DataException? exception;
  final double? downloadPercent;

  // Get Documents
  final String documentsQuery;
  final List<DocumentModel>? documents;
  final WidgetStatus getDocumentsStatus;
  final DocumentModel? documentSelected;

  // Delete Document
  final WidgetStatus deleteStatus;

  // Upload Document
  final WidgetStatus uploadStatus;
  final FileModel? fileSelected;

  @override
  List<Object?> get props => [
    exception,
    getDocumentsStatus,
    documents,
    documentsQuery,
    uploadStatus,
    fileSelected,
    documentSelected,
    downloadPercent,
    deleteStatus,
  ];

  SubjectsState copyWith({
    DataException? exception,
    WidgetStatus? getDocumentsStatus,
    Wrapped<List<DocumentModel>?>? documents,
    String? documentsQuery,
    WidgetStatus? uploadStatus,
    Wrapped<FileModel?>? fileSelected,
    Wrapped<DocumentModel?>? documentSelected,
    Wrapped<double?>? downloadPercent,
    WidgetStatus? deleteStatus,
  }) {
    return SubjectsState(
      exception: exception ?? this.exception,
      getDocumentsStatus: getDocumentsStatus ?? this.getDocumentsStatus,
      documents: documents != null ? documents.value : this.documents,
      documentsQuery: documentsQuery ?? this.documentsQuery,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      fileSelected: fileSelected != null
          ? fileSelected.value
          : this.fileSelected,
      documentSelected: documentSelected != null
          ? documentSelected.value
          : this.documentSelected,
      downloadPercent: downloadPercent != null
          ? downloadPercent.value
          : this.downloadPercent,
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }
}
