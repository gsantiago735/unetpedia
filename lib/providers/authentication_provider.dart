import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/authentication/register_request_model.dart';

class AuthenticationProvider {
  final _firebaseAuth = FirebaseAuth.instance;

  // Log In
  Future<Either<DataException, UserCredential>> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final resp = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(resp);
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } on FirebaseAuthException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Register
  Future<Either<DataException, UserCredential>> createUser({
    required RegisterRequestModel data,
  }) async {
    try {
      final resp = await _firebaseAuth.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      return Right(resp);
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } on FirebaseAuthException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Log Out
  Future<Either<DataException, String>> logOut() async {
    try {
      await _firebaseAuth.signOut();

      return Right("ok");
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Forgot Password
  Future<Either<DataException, String>> forgotPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return Right("ok");
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } on FirebaseAuthException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Upload Profile Photo (After Register)
  // Future<Either<DataException, String>> uploadPhoto({
  //   required String presignedUrl,
  //   required PhotoModel photo,
  // }) async {
  //   try {
  //     final response = await Api().dioFormData.put(
  //       presignedUrl,
  //       options: Options(
  //         headers: {"Content-Type": "image/png", "Connection": "keep-alive"},
  //       ),
  //       data: photo.file.readAsBytesSync(),
  //     );
  //
  //     return Right(response.data.toString());
  //   } on DioException catch (e) {
  //     return Left(DataException(details: e.response?.data.toString()));
  //   } catch (e) {
  //     return Left(DataException(details: e.toString()));
  //   }
  // }
}
