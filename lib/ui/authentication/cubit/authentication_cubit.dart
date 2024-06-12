import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/providers/authentication_provider.dart';
import 'package:unetpedia/models/authentication/authentication.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState());

  final _authenticationProvider = AuthenticationProvider();

  void changePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void changeRemeberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void setImage(PhotoModel photo) {
    emit(state.copyWith(photoSelected: Wrapped.value(photo)));
  }

  void setDegree(DegreeResponseModel value) {
    emit(state.copyWith(degreeSelected: Wrapped.value(value)));
  }

  // ========================================================================
  // Basic Login
  // ========================================================================

  Future<void> login({required String email, required String password}) async {
    if (state.status == WidgetStatus.loading) return;
    emit(state.copyWith(status: WidgetStatus.loading));

    final response =
        await _authenticationProvider.logIn(email: email, password: password);

    return response.fold((l) {
      emit(state.copyWith(status: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(state.copyWith(
        email: Wrapped.value(email),
        password: Wrapped.value(password),
        status: WidgetStatus.success,
        loginResponseModel: Wrapped.value(r),
      ));
    });
  }

  // ========================================================================
  // Basic Register
  // ========================================================================

  Future<void> register(RegisterRequestModel data) async {
    if (state.status == WidgetStatus.loading) return;
    emit(state.copyWith(status: WidgetStatus.loading));

    final response = await _authenticationProvider.register(data: data);

    return response.fold((l) {
      emit(state.copyWith(status: WidgetStatus.error, errorText: l.details));
    }, (r) async {
      emit(state.copyWith(
        registerResponseModel: Wrapped.value(r),
        status: WidgetStatus.initial,
      ));

      login(email: data.email, password: data.password);
    });
  }
}
