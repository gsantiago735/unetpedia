import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unetpedia/utils/generic_utils.dart';
import 'package:unetpedia/models/generic/wrapped.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/providers/firestore_provider.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/subject/document_model.dart';
import 'package:unetpedia/models/generic/data_exception_model.dart';
import 'package:unetpedia/models/subject/document_request_model.dart';

part 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit() : super(const SubjectsState());

  final _firestoreProvider = FirestoreProvider();

  // void setDocumentsQuery(String value) {
  //   emit(
  //     state.copyWith(
  //       documentsQuery: value,
  //       documents: const Wrapped.value(null),
  //     ),
  //   );
  // }

  void selectFile(FileModel value) =>
      emit(state.copyWith(fileSelected: Wrapped.value(value)));

  void setDocument(DocumentModel? value) =>
      emit(state.copyWith(documentSelected: Wrapped.value(value)));

  void _setDownloadPercent(int count, int total) {
    if (total >= 1) {
      emit(state.copyWith(downloadPercent: Wrapped.value(count / total)));
    }
  }
  // ========================================================================
  // Get Documents
  // ========================================================================

  Future<void> getFilesBySubject({
    required String? departmentId,
    required String? subjectId,
  }) async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    if ((departmentId ?? "").isEmpty || (subjectId ?? "").isEmpty) {
      emit(
        state.copyWith(
          getDocumentsStatus: WidgetStatus.error,
          exception: DataException(
            details: "No hemos podido realizar la consulta.",
          ),
        ),
      );
      return;
    }

    final response = await _firestoreProvider.getFilesBySubject(
      departmentId: departmentId!,
      subjectId: subjectId!,
    );

    return response.fold(
      (l) {
        emit(
          state.copyWith(getDocumentsStatus: WidgetStatus.error, exception: l),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            getDocumentsStatus: WidgetStatus.success,
            documents: Wrapped.value(r),
          ),
        );
      },
    );
  }

  Future<void> getFilesByUser(String userId) async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getFilesByUser(userId: userId);

    return response.fold(
      (l) {
        emit(
          state.copyWith(getDocumentsStatus: WidgetStatus.error, exception: l),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            getDocumentsStatus: WidgetStatus.success,
            documents: Wrapped.value(r),
          ),
        );
      },
    );
  }

  /*Future<void> getDocumentDetail() async {
    if (state.getDocumentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getDocumentsStatus: WidgetStatus.loading));

    final response = await _documentsProvider.getDocument(docId: 26);

    return response.fold(
      (l) {
        emit(
          state.copyWith(
            getDocumentsStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            //getDocumentsStatus: WidgetStatus.success,
            documentDetail: Wrapped.value(r.data),
          ),
        );
        await _download();
      },
    );
  }*/

  // ========================================================================
  // Upload Documents
  // ========================================================================

  // Se sube un archivo al storage y se crea el documento en la base de datos
  Future<void> createDocument({
    required String description,
    required String? userId,
    required String? departmentId,
    required String? subjectId,
  }) async {
    if (state.uploadStatus == WidgetStatus.loading ||
        state.fileSelected?.file == null) {
      return;
    }
    emit(state.copyWith(uploadStatus: WidgetStatus.loading));

    if ((userId ?? "").isEmpty ||
        (departmentId ?? "").isEmpty ||
        (subjectId ?? "").isEmpty) {
      emit(
        state.copyWith(
          getDocumentsStatus: WidgetStatus.error,
          exception: DataException(
            details: "No hemos podido realizar la consulta.",
          ),
        ),
      );
      return;
    }

    // 1. Subiendo el archivo seleccionado
    final fileUrl = await _firestoreProvider.uploadStorageFile(
      storagePath: StoragePath.files,
      path: "$userId/${state.fileSelected?.name}",
      file: state.fileSelected!.file,
    );

    // 2. Creando el documento
    final response = await _firestoreProvider.createFileDocument(
      userId: userId!,
      departmentId: departmentId!,
      subjectId: subjectId!,
      data: DocumentRequestModel(
        name: state.fileSelected!.name,
        description: description,
        url: fileUrl,
        size: state.fileSelected!.getSizeInBytes,
        extension: state.fileSelected!.getExtension,
      ),
    );

    return response.fold(
      (l) {
        emit(state.copyWith(uploadStatus: WidgetStatus.error, exception: l));
      },
      (r) {
        emit(state.copyWith(uploadStatus: WidgetStatus.success));
      },
    );
  }

  // ========================================================================
  // Delete Documents
  // ========================================================================

  // Elimina un archivo en el storage y elimina el documento en la base de datos
  Future<void> deleteDocument(DocumentModel document) async {
    if (state.deleteStatus == WidgetStatus.loading) return;
    emit(state.copyWith(deleteStatus: WidgetStatus.loading));

    final resp = await _firestoreProvider.deleteFileDocument(
      userId: FirebaseAuth.instance.currentUser!.uid,
      document: document,
    );

    return resp.fold(
      (l) {
        emit(state.copyWith(deleteStatus: WidgetStatus.error, exception: l));
      },
      (r) {
        // Creando una nueva lista
        final newList = [...state.documents!];
        // Eliminando localmente el item
        newList.removeWhere((e) => (e.id == document.id));

        emit(
          state.copyWith(
            deleteStatus: WidgetStatus.success,
            documents: Wrapped.value(newList),
          ),
        );
      },
    );
  }

  // ========================================================================
  // Download Files
  // ========================================================================

  Future<void> downloadFile({void Function()? onAlreadyExists}) async {
    if (state.getDocumentsStatus == WidgetStatus.loading ||
        state.documentSelected == null) {
      return;
    }
    emit(
      state.copyWith(
        getDocumentsStatus: WidgetStatus.loading,
        downloadPercent: Wrapped.value(null),
      ),
    );

    try {
      await GenericUtils.downloadFile(
        url: state.documentSelected!.url!,
        fileName: state.documentSelected!.name!,
        onReceiveProgress: (count, total) => _setDownloadPercent(count, total),
        onAlreadyExists: () {
          if (onAlreadyExists != null) onAlreadyExists();
        },
      );

      emit(state.copyWith(getDocumentsStatus: WidgetStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          getDocumentsStatus: WidgetStatus.error,
          exception: DataException(details: e.toString()),
        ),
      );
    }
  }
}
