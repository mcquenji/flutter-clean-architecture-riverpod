import 'package:dartz/dartz.dart';
import 'package:flutter_project/shared/domain/models/paginated_response.dart';
import 'package:flutter_project/shared/exceptions/http_exception.dart';

abstract class DashboardDatasource {
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedProducts({required int skip});
  Future<Either<AppException, PaginatedResponse>> searchPaginatedProducts({required int skip, required String query});
}
