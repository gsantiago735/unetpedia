import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:unetpedia/api/api.dart';
import 'package:unetpedia/utils/local_storage.dart';
import 'package:unetpedia/models/generic/generic.dart';
import 'package:unetpedia/models/subject/subject.dart';
import 'package:unetpedia/core/constants/end_point_constant.dart';
import 'package:unetpedia/models/authentication/register_response_model.dart';

class GenericProvider {
  // Get Degrees List
  Future<Either<DataException, DegreesResponseModel>> getDegrees() async {
    try {
      final response = await Api().dio.get(EndPointConstant.getDegrees);

      return Right(DegreesResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Get Categories List
  Future<Either<DataException, CategoriesResponseModel>> getCategories() async {
    try {
      final response = await Api().dio.get(EndPointConstant.categories);

      return Right(CategoriesResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Get User
  Future<Either<DataException, RegisterResponseModel>> getUser() async {
    try {
      final id = LocalStorage.getUserId();
      final response = await Api().dio.get("${EndPointConstant.register}/$id/");

      return Right(RegisterResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }
}
