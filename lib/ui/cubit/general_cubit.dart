import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/providers/providers.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/subject/subject.dart';
import 'package:unetpedia/models/authentication/register_response_model.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(const GeneralState());

  final _genericProvider = GenericProvider();
  final _authenticationProvider = AuthenticationProvider();

  void clean() => emit(const GeneralState());

  void setCategoryQuery(String value) {
    emit(state.copyWith(categoryQuery: value));
  }

  void setSubjectQuery(String value) {
    emit(
      state.copyWith(
        subjectQuery: value,
        subjectsResponseModel: const Wrapped.value(null),
      ),
    );
  }

  void selectCategory(CategoryResponseModel? value) {
    emit(
      state.copyWith(
        categorySelected: Wrapped.value(value),
        subjectsResponseModel: const Wrapped.value(null),
        subjectsStatus: WidgetStatus.initial,
        moreSubjectsStatus: WidgetStatus.initial,
        subjectQuery: "",
      ),
    );
  }

  void selectSubject(SubjectResponseModel? value) {
    emit(state.copyWith(subjectSelected: Wrapped.value(value)));
  }

  // =======================================================================
  // Degree
  // =======================================================================

  Future<void> getDegrees() async {
    if (state.degreesStatus == WidgetStatus.loading) return;
    emit(state.copyWith(degreesStatus: WidgetStatus.loading));

    final response = await _genericProvider.getDegrees();

    return response.fold(
      (l) {
        emit(
          state.copyWith(
            degreesStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            degreesStatus: WidgetStatus.success,
            degrees: Wrapped.value(r),
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

    final response = await _genericProvider.getUser();

    return response.fold(
      (l) {
        emit(
          state.copyWith(
            getUserStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            getUserStatus: WidgetStatus.success,
            userResponseModel: Wrapped.value(r),
          ),
        );
      },
    );
  }

  Future<void> logOut() async {
    if (state.logOutStatus == WidgetStatus.loading) return;
    emit(state.copyWith(logOutStatus: WidgetStatus.loading));

    final response = await _authenticationProvider.logOut();

    return response.fold(
      (l) {
        emit(
          state.copyWith(
            logOutStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        emit(state.copyWith(logOutStatus: WidgetStatus.success));
      },
    );
  }

  // =======================================================================
  // Categories (Departments)
  // =======================================================================

  Future<void> getCategories() async {
    if (state.categoryStatus == WidgetStatus.loading) return;
    emit(state.copyWith(categoryStatus: WidgetStatus.loading));

    final response = await _genericProvider.getCategories(
      query: state.categoryQuery,
    );

    return response.fold(
      (l) {
        emit(
          state.copyWith(
            categoryStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            categoryStatus: WidgetStatus.success,
            categoriesResponseModel: Wrapped.value(r),
          ),
        );
      },
    );
  }

  // =======================================================================
  // Subjects
  // =======================================================================

  // Subjects List with pagination
  Future<void> getSubjects() async {
    if (state.subjectsStatus == WidgetStatus.loading ||
        state.moreSubjectsStatus == WidgetStatus.loading) {
      return;
    }

    int? page = 1;

    if (state.subjectsResponseModel != null) {
      if ((state.subjectsResponseModel?.pages?.next) == null) return;

      page = state.subjectsResponseModel?.pages?.next;
    }

    if (page != 1) {
      emit(state.copyWith(moreSubjectsStatus: WidgetStatus.loading));
    } else {
      emit(state.copyWith(subjectsStatus: WidgetStatus.loading));
    }

    final response = await _genericProvider.getSubjects(
      page: page!,
      categoryId: state.categorySelected!.id!,
      query: state.subjectQuery,
    );

    return response.fold(
      (l) {
        if (page != 1) {
          emit(
            state.copyWith(
              moreSubjectsStatus: WidgetStatus.error,
              errorText: l.details,
            ),
          );
        } else {
          emit(
            state.copyWith(
              subjectsStatus: WidgetStatus.error,
              errorText: l.details,
            ),
          );
        }
      },
      (r) async {
        emit(
          state.copyWith(
            subjectsStatus: WidgetStatus.success,
            moreSubjectsStatus: WidgetStatus.success,
            subjectsResponseModel: Wrapped.value(
              (state.subjectsResponseModel ?? SubjectsResponseModel()).copyWith(
                data: [
                  ...(state.subjectsResponseModel?.data ?? []),
                  ...r.data!,
                ],
                pages: r.pages,
                count: r.count,
              ),
            ),
          ),
        );
      },
    );
  }
}
