import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:unetpedia/api/api.dart';
import 'package:unetpedia/models/generic/file_model.dart';
import 'package:unetpedia/models/documents/documents.dart';
import 'package:unetpedia/core/constants/end_point_constant.dart';
import 'package:unetpedia/models/generic/data_exception_model.dart';

class DocumentsProvider {
  // Get Documents List
  Future<Either<DataException, DocumentsResponseModel>> getDocuments(
      {required int page, required int subjectId, required String name}) async {
    final params = {"page": page, "name": name};
    try {
      final response = await Api().dio.get(
          "${EndPointConstant.getDocuments}/$subjectId",
          queryParameters: params);
      return Right(DocumentsResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Create Document
  Future<Either<DataException, CreateDocumentResponseModel>> createDocument(
      {required String name,
      required int category,
      required int subject}) async {
    final params = {"name": name, "category": category, "subject": subject};
    try {
      final response = await Api()
          .dioFormData
          .post(EndPointConstant.addDocument, data: params);
      return Right(CreateDocumentResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Upload Profile Photo (After Register)
  Future<Either<DataException, String>> uploadDocument(
      {required String presignedUrl, required FileModel file}) async {
    try {
      final response = await Api().noBearer.put(
            presignedUrl,
            options: Options(headers: {
              "Content-Type": "application/pdf",
              "Connection": "keep-alive"
            }),
            data: file.file.readAsBytesSync(),
          );

      return Right(response.data.toString());
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Get Document Detail
  Future<Either<DataException, DetailDocumentResponseModel>> getDocument(
      {required int docId}) async {
    try {
      final response =
          await Api().dio.get("${EndPointConstant.addDocument}/$docId");
      return Right(DetailDocumentResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(DataException(details: e.response?.data.toString()));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }
}
