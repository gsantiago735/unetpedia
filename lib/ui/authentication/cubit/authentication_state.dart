part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.errorText = "",
    this.showPassword = true,
    this.rememberMe = false,
    this.status = WidgetStatus.initial,
    this.photoSelected,
    this.degreeSelected,
  });

  // Generic
  final WidgetStatus status;
  final String errorText;

  // Login
  final bool showPassword;
  final bool rememberMe;

  // Register
  final PhotoModel? photoSelected;
  final String? degreeSelected;

  // Forgot Password

  @override
  List<Object?> get props => [
        errorText,
        status,
        showPassword,
        rememberMe,
        photoSelected,
        degreeSelected,
      ];

  AuthenticationState copyWith({
    String? errorText,
    WidgetStatus? status,
    bool? showPassword,
    bool? rememberMe,
    Wrapped<PhotoModel?>? photoSelected,
    Wrapped<String?>? degreeSelected,
  }) {
    return AuthenticationState(
      errorText: errorText ?? this.errorText,
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
      photoSelected:
          photoSelected != null ? photoSelected.value : this.photoSelected,
      degreeSelected:
          degreeSelected != null ? degreeSelected.value : this.degreeSelected,
    );
  }
}
