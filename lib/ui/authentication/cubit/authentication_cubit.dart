import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/providers/firestore_provider.dart';
import 'package:unetpedia/providers/authentication_provider.dart';
import 'package:unetpedia/models/authentication/authentication.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState());

  final _authenticationProvider = AuthenticationProvider();
  final _firestoreProvider = FirestoreProvider();

  void changePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  void setRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
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
  if (state.genericStatus == WidgetStatus.loading) return;

  emit(state.copyWith(genericStatus: WidgetStatus.loading));

  final response = await _authenticationProvider.logIn(
    email: email,
    password: password,
  );

  return response.fold(
    (l) {
      emit(state.copyWith(
        genericStatus: WidgetStatus.error,
        errorText: l.details,
      ));
    },
    (r) async {
      emit(state.copyWith(
        email: Wrapped.value(email),
        password: Wrapped.value(password),
        genericStatus: WidgetStatus.success,
      ));
    },
  );
}


  // ========================================================================
  // Basic Register
  // ========================================================================

  Future<void> register(RegisterRequestModel data) async {
    if (state.genericStatus == WidgetStatus.loading) return;
    emit(state.copyWith(genericStatus: WidgetStatus.loading));

    final response = await _authenticationProvider.createUser(data: data);

    response.fold(
      (l) {
        emit(
          state.copyWith(
            genericStatus: WidgetStatus.error,
            errorText: l.details,
          ),
        );
      },
      (r) async {
        // Validando campos
        if (r.user?.uid == null || state.photoSelected?.file == null) {
          emit(
            state.copyWith(
              genericStatus: WidgetStatus.error,
              errorText: "Campos invalidos.",
            ),
          );
          return;
        }

        // 1. Creando documento con la informacion completa del registro
        await _firestoreProvider.createUserDocument(data, r.user!.uid);

        // 2. Subiendo imagen de perfil
        final url = await _firestoreProvider.uploadImage(
          storagePath: StoragePath.profile,
          path: "${r.user!.uid}/${DateTime.now().toString()}.jpg",
          image: state.photoSelected!.file,
        );

        // 3. Actualizando campo de foto de perfil con la url en el documento
        await _firestoreProvider.updateProfileUrl(r.user!.uid, url);

        emit(state.copyWith(genericStatus: WidgetStatus.success));
      },
    );
  }

  // ========================================================================
  // Change Password
  // ========================================================================

  // Future<void> changePassword(
  //     {required String currentPassword, required String newPassword}) async {
  //   if (state.status == WidgetStatus.loading) return;
  //   emit(state.copyWith(status: WidgetStatus.loading));
  //
  //   final response = await _authenticationProvider.changePassword(
  //       currentPassword: currentPassword, newPassword: newPassword);
  //
  //   return response.fold((l) {
  //     emit(state.copyWith(status: WidgetStatus.error, errorText: l.details));
  //   }, (r) async {
  //     emit(state.copyWith(
  //         status: WidgetStatus.success, password: Wrapped.value(newPassword)));
  //   });
  // }
}
