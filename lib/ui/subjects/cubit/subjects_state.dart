part of 'subjects_cubit.dart';

class SubjectsState extends Equatable {
  const SubjectsState({
    this.errorText = "",
    this.getDocumentsStatus = WidgetStatus.initial,
    this.getMoreDocsStatus = WidgetStatus.initial,
    this.documents,
    this.subjectSelected,
    this.documentsQuery = "",
    this.uploadStatus = WidgetStatus.initial,
    this.fileSelected,
    this.documentDetail,
  });

  // General
  final String errorText;
  final SubjectResponseModel? subjectSelected;

  // Get Documents
  final String documentsQuery;
  final DocumentsResponseModel? documents;
  final DocumentDetail? documentDetail;
  final WidgetStatus getDocumentsStatus;
  final WidgetStatus getMoreDocsStatus;

  // Upload Document
  final WidgetStatus uploadStatus;
  final FileModel? fileSelected;

  @override
  List<Object?> get props => [
        errorText,
        getDocumentsStatus,
        getMoreDocsStatus,
        documents,
        subjectSelected,
        documentsQuery,
        uploadStatus,
        fileSelected,
        documentDetail,
      ];

  SubjectsState copyWith({
    String? errorText,
    WidgetStatus? getDocumentsStatus,
    WidgetStatus? getMoreDocsStatus,
    Wrapped<DocumentsResponseModel?>? documents,
    Wrapped<SubjectResponseModel?>? subjectSelected,
    String? documentsQuery,
    WidgetStatus? uploadStatus,
    Wrapped<FileModel?>? fileSelected,
    Wrapped<DocumentDetail?>? documentDetail,
  }) {
    return SubjectsState(
      errorText: errorText ?? this.errorText,
      getDocumentsStatus: getDocumentsStatus ?? this.getDocumentsStatus,
      getMoreDocsStatus: getMoreDocsStatus ?? this.getMoreDocsStatus,
      documents: documents != null ? documents.value : this.documents,
      subjectSelected: subjectSelected != null
          ? subjectSelected.value
          : this.subjectSelected,
      documentsQuery: documentsQuery ?? this.documentsQuery,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      fileSelected:
          fileSelected != null ? fileSelected.value : this.fileSelected,
      documentDetail:
          documentDetail != null ? documentDetail.value : this.documentDetail,
    );
  }
}
