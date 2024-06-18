part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.errorText = "",
    this.showPassword = true,
    this.rememberMe = false,
    this.status = WidgetStatus.initial,
    this.photoSelected,
    this.degreeSelected,
    this.loginResponseModel,
    this.email,
    this.password,
    this.registerResponseModel,
    this.presignedStatus = WidgetStatus.initial,
  });

  // Generic
  final String? email;
  final String? password;
  final WidgetStatus status;
  final String errorText;

  // Login
  final bool showPassword;
  final bool rememberMe;
  final LoginResponseModel? loginResponseModel;

  // Register
  final PhotoModel? photoSelected;
  final DegreeResponseModel? degreeSelected;
  final WidgetStatus presignedStatus;
  final RegisterResponseModel? registerResponseModel;

  // Forgot Password

  @override
  List<Object?> get props => [
        errorText,
        status,
        showPassword,
        rememberMe,
        photoSelected,
        degreeSelected,
        loginResponseModel,
        email,
        password,
        registerResponseModel,
        presignedStatus,
      ];

  AuthenticationState copyWith({
    String? errorText,
    WidgetStatus? status,
    bool? showPassword,
    bool? rememberMe,
    Wrapped<PhotoModel?>? photoSelected,
    Wrapped<DegreeResponseModel?>? degreeSelected,
    Wrapped<LoginResponseModel?>? loginResponseModel,
    Wrapped<String?>? email,
    Wrapped<String?>? password,
    Wrapped<RegisterResponseModel?>? registerResponseModel,
    WidgetStatus? presignedStatus,
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
      loginResponseModel: loginResponseModel != null
          ? loginResponseModel.value
          : this.loginResponseModel,
      email: email != null ? email.value : this.email,
      password: password != null ? password.value : this.password,
      registerResponseModel: registerResponseModel != null
          ? registerResponseModel.value
          : this.registerResponseModel,
      presignedStatus: presignedStatus ?? this.presignedStatus,
    );
  }
}
