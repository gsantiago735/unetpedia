import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/models/generic/wrapped.dart';
import 'package:unetpedia/models/documents/documents.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/providers/documents_provider.dart';
import 'package:unetpedia/models/subject/subjects_response_model.dart';
import 'package:unetpedia/utils/generic_utils.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit() : super(const SubjectsState());

  final _documentsProvider = DocumentsProvider();

  void setSubject(SubjectResponseModel? value) {
    emit(state.copyWith(subjectSelected: Wrapped.value(value)));
  }

  void setDocumentsQuery(String value) {
    emit(state.copyWith(
        documentsQuery: value, documents: const Wrapped.value(null)));
  }

  void selectFile(FileModel value) {
    emit(state.copyWith(fileSelected: Wrapped.value(value)));
  }

  // ========================================================================
  // Get Documents
  // ========================================================================

  Future<void> getDocuments() async {
    if (state.getDocumentsStatus == WidgetStatus.loading ||
        state.getMoreDocsStatus == WidgetStatus.loading) return;

    int? page = 1;

    if (state.documents != null) {
      if ((state.documents?.pages?.next) == null) return;

      page = state.documents?.pages?.next;
    }

    if (page != 1) {
      emit(state.copyWith(getMoreDocsStatus: WidgetStatus.loading));
    } else {
      emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));
    }

    final response = await _documentsProvider.getDocuments(
      page: page!,
      subjectId: state.subjectSelected!.id!,
      name: state.documentsQuery,
    );

    return response.fold((l) {
      if (page != 1) {
        emit(state.copyWith(
            getMoreDocsStatus: WidgetStatus.error, errorText: l.details));
      } else {
        emit(state.copyWith(
            getDocumentsStatus: WidgetStatus.error, errorText: l.details));
      }
    }, (r) async {
      emit(state.copyWith(
        getDocumentsStatus: WidgetStatus.success,
        getMoreDocsStatus: WidgetStatus.success,
        documents: Wrapped.value(
            (state.documents ?? DocumentsResponseModel()).copyWith(
          data: [...(state.documents?.data ?? []), ...r.data!],
          pages: r.pages,
          count: r.count,
        )),
      ));
    });
  }

  Future<void> getDocumentDetail() async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    final response = await _documentsProvider.getDocument(docId: 26);

    return response.fold((l) {
      emit(state.copyWith(
          getDocumentsStatus: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(state.copyWith(
        //getDocumentsStatus: WidgetStatus.success,
        documentDetail: Wrapped.value(r.data),
      ));
      await _download();
    });
  }

  // ========================================================================
  // Upload Documents
  // ========================================================================

  Future<void> createDocument({required int category}) async {
    if (state.uploadStatus == WidgetStatus.loading) return;
    emit(state.copyWith(uploadStatus: WidgetStatus.loading));

    final response = await _documentsProvider.createDocument(
      name: state.fileSelected!.name,
      category: category,
      subject: state.subjectSelected!.id!,
    );

    return response.fold((l) {
      emit(state.copyWith(
          uploadStatus: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      await _uploadDocument(r.presignedUrl);
    });
  }

  Future<void> _uploadDocument(String? presigned) async {
    final response = await _documentsProvider.uploadDocument(
      presignedUrl: presigned!,
      file: state.fileSelected!,
    );

    return response.fold((l) {
      emit(state.copyWith(
          errorText: l.details, uploadStatus: WidgetStatus.initial));
    }, (r) async {
      emit(state.copyWith(uploadStatus: WidgetStatus.success));
    });
  }

  // Download

  Future<void> _download() async {
    final file = await GenericUtils.checkDownloadFile(
        url: state.documentDetail!.url!, fileName: state.documentDetail!.name!);

    emit(state.copyWith(
      fileSelected:
          Wrapped.value(FileModel(id: "0", name: "name", file: file!)),
      getDocumentsStatus: WidgetStatus.success,
    ));
  }
}
