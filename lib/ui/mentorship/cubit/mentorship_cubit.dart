import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/mentorship/mentorship.dart';
import 'package:unetpedia/models/subject/subject_model.dart';
import 'package:unetpedia/providers/firestore_provider.dart';
import 'package:unetpedia/models/subject/department_model.dart';

part 'mentorship_state.dart';

class MentorshipCubit extends Cubit<MentorshipState> {
  MentorshipCubit() : super(const MentorshipState());

  final _firestoreProvider = FirestoreProvider();

  /// Guarda en el estado el departamento seleccionado por el usuario
  void selectDepartment(DepartmentModel? value) {
    emit(state.copyWith(departmentSelected: Wrapped.value(value)));
  }

  /// Guarda en el estado la materia seleccionada por el usuario
  void selectSubject(SubjectModel? value) =>
      emit(state.copyWith(subjectSelected: Wrapped.value(value)));

  // =========================================================================
  //  Mentorships
  // =========================================================================

  Future<void> getMentorships() async {
    if (state.genericStatus == WidgetStatus.loading) return;
    emit(state.copyWith(genericStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getMentorships();

    return response.fold(
      (l) {
        emit(state.copyWith(genericStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(
          state.copyWith(
            genericStatus: WidgetStatus.success,
            mentorships: Wrapped.value(r),
          ),
        );
      },
    );
  }

  Future<void> createMentorships({
    required String? userId,
    required MentorshipRequestModel data,
  }) async {
    if (state.genericStatus == WidgetStatus.loading) return;
    emit(state.copyWith(genericStatus: WidgetStatus.loading));

    if ((userId ?? "").isEmpty ||
        (state.departmentSelected?.id ?? "").isEmpty ||
        (state.subjectSelected?.id ?? "").isEmpty) {
      emit(
        state.copyWith(
          genericStatus: WidgetStatus.error,
          exception: DataException(
            details: "No hemos podido realizar la consulta.",
          ),
        ),
      );
      return;
    }

    final response = await _firestoreProvider.createMentorship(
      userId: userId!,
      departmentId: state.departmentSelected!.id!,
      subjectId: state.subjectSelected!.id!,
      data: data,
    );

    return response.fold(
      (l) {
        emit(state.copyWith(genericStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(state.copyWith(genericStatus: WidgetStatus.success));
      },
    );
  }
}
