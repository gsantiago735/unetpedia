import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState());

  //final _userProvider = UserProvider();

  void changePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void changeRemeberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void setImage(PhotoModel photo) {
    emit(state.copyWith(photoSelected: Wrapped.value(photo)));
  }

  void setDegree(String value) {
    emit(state.copyWith(degreeSelected: Wrapped.value(value)));
  }

  // ========================================================================
  // Basic Login
  // ========================================================================

  Future<void> login() async {
    if (state.status == WidgetStatus.loading) return;
    emit(state.copyWith(status: WidgetStatus.loading));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: WidgetStatus.error));
  }

  // ========================================================================
  // Basic Register
  // ========================================================================

  Future<void> register() async {
    if (state.status == WidgetStatus.loading) return;
    emit(state.copyWith(status: WidgetStatus.loading));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: WidgetStatus.error));
  }
}
