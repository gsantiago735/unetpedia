import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/subject/subject.dart';
import 'package:unetpedia/providers/firestore_provider.dart';
import 'package:unetpedia/providers/authentication_provider.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(const GeneralState());

  final _firestoreProvider = FirestoreProvider();
  final _authenticationProvider = AuthenticationProvider();

  void clean() => emit(const GeneralState());

  /// Aplica filtrado por nombre al listado de departamentos
  void setDepartmentQuery(String value) {
    emit(state.copyWith(departmentsQuery: value));

    if ((state.departments ?? []).isEmpty) return;

    // Si el valor es vacio, se limpian los filtros
    if (value.isEmpty) {
      emit(state.copyWith(departmentsFiltered: Wrapped.value(null)));
      return;
    }

    // Encontrando coincidencias en la lista
    final values = state.departments
        ?.where((e) => (e.name!.toLowerCase().contains(value.toLowerCase())))
        .toList();

    // Aplicando el filtro localmente
    emit(state.copyWith(departmentsFiltered: Wrapped.value(values)));
  }

  /// Aplica filtrado por nombre al listado de materias
  void setSubjectQuery(String value) {
    emit(state.copyWith(subjectQuery: value));

    emit(state.copyWith(subjectQuery: value));

    if ((state.subjects ?? []).isEmpty) return;

    // Si el valor es vacio, se limpian los filtros
    if (value.isEmpty) {
      emit(state.copyWith(subjectsFiltered: Wrapped.value(null)));
      return;
    }

    // Encontrando coincidencias en la lista
    final values = state.subjects
        ?.where((e) => (e.name!.toLowerCase().contains(value.toLowerCase())))
        .toList();

    // Aplicando el filtro localmente
    emit(state.copyWith(subjectsFiltered: Wrapped.value(values)));
  }

  /// Guarda en el estado el departamento seleccionado por el usuario
  void selectDepartment(DepartmentModel? value) {
    emit(
      state.copyWith(
        subjectsStatus: WidgetStatus.initial,
        departmentSelected: Wrapped.value(value),
        subjects: const Wrapped.value(null),
        subjectsFiltered: const Wrapped.value(null),
      ),
    );
  }

  /// Guarda en el estado la materia seleccionada por el usuario
  void selectSubject(SubjectModel? value) =>
      emit(state.copyWith(subjectSelected: Wrapped.value(value)));

  /// Actualiza localmente el contador de archivos de la materia seleccionada
  void updateFileCount() {
    if (state.subjectSelected == null || (state.subjects ?? []).isEmpty) return;

    // Se recorre la lista para generar una nueva
    final List<SubjectModel> newList = state.subjects!.map((e) {
      // Evaluando el elemento de la lista que necesita ser actualizado
      if (e.id == state.subjectSelected!.id) {
        return e.copyWith(fileCount: (e.fileCount ?? 0) + 1);
      } else {
        return e;
      }
    }).toList();

    List<SubjectModel>? filteredList = [];

    if (((state.subjectsFiltered ?? []).isNotEmpty)) {
      // Se recorre la lista filtrada para generar una nueva
      filteredList = state.subjectsFiltered!.map((e) {
        // Evaluando el elemento de la lista que necesita ser actualizado
        if (e.id == state.subjectSelected!.id) {
          return e.copyWith(fileCount: (e.fileCount ?? 0) + 1);
        } else {
          return e;
        }
      }).toList();
    }

    emit(
      state.copyWith(
        subjects: Wrapped.value(newList),
        subjectsFiltered: (filteredList.isNotEmpty)
            ? Wrapped.value(filteredList)
            : null,
      ),
    );
  }

  // =======================================================================
  // Careers
  // =======================================================================

  Future<void> getCareers() async {
    if (state.careersStatus == WidgetStatus.loading) return;
    emit(state.copyWith(careersStatus: WidgetStatus.loading));

    final resp = await _firestoreProvider.getCareers();

    return resp.fold(
      (l) {
        emit(state.copyWith(careersStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(
          state.copyWith(
            careersStatus: WidgetStatus.success,
            careers: Wrapped.value(r),
          ),
        );
      },
    );
  }

  // =======================================================================
  // Authentication
  // =======================================================================

  Future<void> getUser() async {
    if (state.getUserStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getUserStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );

    return response.fold(
      (l) {
        emit(state.copyWith(getUserStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        // Asignando la carrera a la que pertenece el usuario
        if (state.userCareer == null) {
          // Verificando si la lista de carreras esta vacía
          if ((state.careers ?? []).isEmpty) {
            await getCareers();
          }

          final userCareer = state.careers?.firstWhere(
            (e) => (e.id == r.careerId),
          );

          emit(state.copyWith(userCareer: Wrapped.value(userCareer)));
        }

        emit(
          state.copyWith(
            getUserStatus: WidgetStatus.success,
            user: Wrapped.value(r),
          ),
        );
      },
    );
  }

  Future<void> logOut() async {
    if (state.logOutStatus == WidgetStatus.loading) return;
    emit(state.copyWith(logOutStatus: WidgetStatus.loading));

    await Future.delayed(Duration(seconds: 1));
    final response = await _authenticationProvider.logOut();

    return response.fold(
      (l) {
        emit(state.copyWith(logOutStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(state.copyWith(logOutStatus: WidgetStatus.success));
      },
    );
  }

  // =======================================================================
  // Categories (Departments)
  // =======================================================================

  Future<void> getDepartments() async {
    if (state.departmentsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(departmentsStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getDepartments();

    return response.fold(
      (l) {
        emit(
          state.copyWith(departmentsStatus: WidgetStatus.error, exception: l),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            departmentsStatus: WidgetStatus.success,
            departments: Wrapped.value(r),
          ),
        );
      },
    );
  }

  // =======================================================================
  // Subjects
  // =======================================================================

  Future<void> getSubjects(String? departmentId) async {
    if (departmentId == null) return;
    if (state.subjectsStatus == WidgetStatus.loading) return;
    emit(state.copyWith(subjectsStatus: WidgetStatus.loading));

    final response = await _firestoreProvider.getSubjects(id: departmentId);

    return response.fold(
      (l) {
        emit(state.copyWith(subjectsStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        emit(
          state.copyWith(
            subjectsStatus: WidgetStatus.success,
            subjects: Wrapped.value(r),
          ),
        );
      },
    );
  }
}
