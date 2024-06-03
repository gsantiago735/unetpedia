import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';

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

  // ========================================================================
  // Basic Login
  // ========================================================================

  Future<void> login() async {
    if (state.status == WidgetStatus.loading) return;
    emit(state.copyWith(status: WidgetStatus.loading));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(status: WidgetStatus.error));
  }
}
