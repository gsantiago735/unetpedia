import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void setDegree(CareerModel value) {
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
        emit(state.copyWith(genericStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        // 1. Actualizando campo de ultimo inicio de sesion
        await _firestoreProvider.updateLastSignIn(r.user!.uid);

        emit(
          state.copyWith(
            email: Wrapped.value(email),
            password: Wrapped.value(password),
            genericStatus: WidgetStatus.success,
          ),
        );
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
        emit(state.copyWith(genericStatus: WidgetStatus.error, exception: l));
      },
      (r) async {
        // Validando campos
        if (r.user?.uid == null || state.photoSelected?.file == null) {
          emit(
            state.copyWith(
              genericStatus: WidgetStatus.error,
              exception: DataException(details: "Campos invalidos."),
            ),
          );
          return;
        }

        // 1. Creando documento con la informacion completa del registro
        await _firestoreProvider.createUserDocument(data, r.user!.uid);

        // 2. Subiendo imagen de perfil
        final url = await _firestoreProvider.uploadStorageFile(
          storagePath: StoragePath.profile,
          path: "${r.user!.uid}/${DateTime.now().toString()}.jpg",
          file: state.photoSelected!.file,
        );

        // 3. Actualizando campo de foto de perfil con la url en el documento
        await _firestoreProvider.updateProfileUrl(r.user!.uid, url);

        emit(state.copyWith(genericStatus: WidgetStatus.success));
      },
    );
  }

  // ========================================================================
  // Update
  // ========================================================================

  Future<void> updateUserProfile({
    required String name,
    required String lastName,
  }) async {
    try {
      if (state.genericStatus == WidgetStatus.loading) return;
      emit(state.copyWith(genericStatus: WidgetStatus.loading));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Usuario no autenticado");

      String? photoUrl;

      // 1. Subir nueva imagen si se seleccionó
      if (state.photoSelected != null) {
        photoUrl = await _firestoreProvider.uploadStorageFile(
          storagePath: StoragePath.profile,
          path: "${user.uid}/${DateTime.now().toString()}.jpg",
          file: state.photoSelected!.file,
        );

        // 2. Actualizar campo photoUrl en documento Firestore
        await _firestoreProvider.updateProfileUrl(user.uid, photoUrl);
      }

      // 3. Actualizar nombre en Firestore
      await _firestoreProvider.updateProfile(
        uid: user.uid,
        name: name,
        lastName: lastName,
      );

      // 4. (Opcional) actualizar nombre e imagen en Firebase Auth
      await user.updateDisplayName(name);
      await user.updateDisplayName(lastName);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      emit(state.copyWith(genericStatus: WidgetStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          genericStatus: WidgetStatus.error,
          exception: DataException(
            details: "Error al actualizar perfil: ${e.toString()}",
          ),
        ),
      );
    }
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
  //     emit(state.copyWith(status: WidgetStatus.error, exception: l));
  //   }, (r) async {
  //     emit(state.copyWith(
  //         status: WidgetStatus.success, password: Wrapped.value(newPassword)));
  //   });
  // }
}
