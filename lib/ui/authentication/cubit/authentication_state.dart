part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.errorText = "",
    this.showPassword = true,
    this.rememberMe = false,
    this.status = WidgetStatus.initial,
  });

  // Generic
  final WidgetStatus status;
  final String errorText;

  // Login
  final bool showPassword;
  final bool rememberMe;

  // Register

  // Forgot Password

  @override
  List<Object?> get props => [
        errorText,
        status,
        showPassword,
        rememberMe,
      ];

  AuthenticationState copyWith({
    String? errorText,
    WidgetStatus? status,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return AuthenticationState(
      errorText: errorText ?? this.errorText,
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
      //idUser: idUser != null ? idUser.value : this.idUser,
    );
  }
}
