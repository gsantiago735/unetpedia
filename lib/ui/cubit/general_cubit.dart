import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/authentication/register_response_model.dart';
import 'package:unetpedia/providers/providers.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/subject/categories_response_model.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(const GeneralState());

  final _genericProvider = GenericProvider();
  final _authenticationProvider = AuthenticationProvider();

  void clean() => emit(const GeneralState());

  // =======================================================================
  // Degree
  // =======================================================================

  Future<void> getDegrees() async {
    if (state.degreesStatus == WidgetStatus.loading) return;
    emit(state.copyWith(degreesStatus: WidgetStatus.loading));

    final response = await _genericProvider.getDegrees();

    return response.fold((l) {
      emit(state.copyWith(
          degreesStatus: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(state.copyWith(
        degreesStatus: WidgetStatus.success,
        degrees: Wrapped.value(r),
      ));
    });
  }

  // =======================================================================
  // Authentication
  // =======================================================================

  Future<void> getUser() async {
    if (state.getUserStatus == WidgetStatus.loading) return;
    emit(state.copyWith(getUserStatus: WidgetStatus.loading));

    final response = await _genericProvider.getUser();

    return response.fold((l) {
      emit(state.copyWith(
          getUserStatus: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(
        state.copyWith(
            getUserStatus: WidgetStatus.success,
            userResponseModel: Wrapped.value(r)),
      );
    });
  }

  Future<void> logOut() async {
    if (state.logOutStatus == WidgetStatus.loading) return;
    emit(state.copyWith(logOutStatus: WidgetStatus.loading));

    final response = await _authenticationProvider.logOut();

    return response.fold((l) {
      emit(state.copyWith(
          logOutStatus: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(state.copyWith(logOutStatus: WidgetStatus.success));
    });
  }

  // =======================================================================
  // Categories (Departments)
  // =======================================================================

  Future<void> getCategories() async {
    if (state.categoryStatus == WidgetStatus.loading) return;
    emit(state.copyWith(categoryStatus: WidgetStatus.loading));

    final response = await _genericProvider.getCategories();

    return response.fold((l) {
      emit(state.copyWith(
          categoryStatus: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(state.copyWith(
        categoryStatus: WidgetStatus.success,
        categoriesResponseModel: Wrapped.value(r),
      ));
    });
  }
}
