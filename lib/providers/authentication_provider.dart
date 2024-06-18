import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:unetpedia/api/api.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/core/constants/end_point_constant.dart';
import 'package:unetpedia/models/authentication/authentication.dart';

class AuthenticationProvider {
  // Log In
  Future<Either<DataException, LoginResponseModel>> logIn(
      {required String email, required String password}) async {
    final body = {'email': email, 'password': password};

    try {
      final response =
          await Api().dioFormData.post(EndPointConstant.login, data: body);

      return Right(LoginResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Register
  Future<Either<DataException, RegisterResponseModel>> register(
      {required RegisterRequestModel data}) async {
    try {
      final response = await Api()
          .dioFormData
          .post(EndPointConstant.register, data: data.toJson());

      return Right(RegisterResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Log Out
  Future<Either<DataException, LoginResponseModel>> logOut() async {
    try {
      final response = await Api().dioFormData.post(EndPointConstant.logOut);

      return Right(LoginResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Change Password
  Future<Either<DataException, String>> changePassword(
      {required String currentPassword, required String newPassword}) async {
    final data = {
      "currentPassword": currentPassword,
      "newPassword": newPassword
    };
    try {
      final response = await Api()
          .dioFormData
          .put(EndPointConstant.changePassword, data: data);

      return Right(response.data.toString());
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Upload Profile Photo (After Register)
  Future<Either<DataException, String>> uploadPhoto(
      {required String presignedUrl, required PhotoModel photo}) async {
    try {
      final response = await Api().dioFormData.put(
            presignedUrl,
            options: Options(headers: {
              "Content-Type": "image/png",
              "Connection": "keep-alive"
            }),
            data: photo.file.readAsBytesSync(),
          );

      return Right(response.data.toString());
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }
}
