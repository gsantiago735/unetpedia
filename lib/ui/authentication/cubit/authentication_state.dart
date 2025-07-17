part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.errorText = "",
    this.showPassword = true,
    this.rememberMe = false,
    this.genericStatus = WidgetStatus.initial,
    this.photoSelected,
    this.degreeSelected,
    this.email,
    this.password,
    this.presignedStatus = WidgetStatus.initial,
  });

  // Generic
  final String? email;
  final String? password;
  final WidgetStatus genericStatus;
  final String errorText;

  // Login
  final bool showPassword;
  final bool rememberMe;

  // Register
  final PhotoModel? photoSelected;
  final DegreeResponseModel? degreeSelected;
  final WidgetStatus presignedStatus;

  // Forgot Password

  @override
  List<Object?> get props => [
    errorText,
    genericStatus,
    showPassword,
    rememberMe,
    photoSelected,
    degreeSelected,
    email,
    password,
    presignedStatus,
  ];

  AuthenticationState copyWith({
    String? errorText,
    WidgetStatus? genericStatus,
    bool? showPassword,
    bool? rememberMe,
    Wrapped<PhotoModel?>? photoSelected,
    Wrapped<DegreeResponseModel?>? degreeSelected,
    Wrapped<String?>? email,
    Wrapped<String?>? password,
    WidgetStatus? presignedStatus,
  }) {
    return AuthenticationState(
      errorText: errorText ?? this.errorText,
      genericStatus: genericStatus ?? this.genericStatus,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
      photoSelected: photoSelected != null
          ? photoSelected.value
          : this.photoSelected,
      degreeSelected: degreeSelected != null
          ? degreeSelected.value
          : this.degreeSelected,
      email: email != null ? email.value : this.email,
      password: password != null ? password.value : this.password,
      presignedStatus: presignedStatus ?? this.presignedStatus,
    );
  }
}
