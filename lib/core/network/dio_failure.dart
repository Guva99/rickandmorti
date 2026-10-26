import 'package:clatch_rcikmorti/core/error/failure.dart';
import 'package:dio/dio.dart';

extension DioFailure on DioException {
  Failure toFailure() => switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => ServerFailure(response?.statusCode),
    DioExceptionType.badCertificate ||
    DioExceptionType.cancel ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.unknown => const UnexpectedFailure(),
  };
}
