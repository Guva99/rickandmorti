import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  String get message => switch (this) {
    NetworkFailure() =>
      'No internet connection. Check your network and try again.',
    ServerFailure() =>
      'The server is not responding right now. Try again later.',
    UnexpectedFailure() => 'Something went wrong. Please try again.',
  };

  @override
  List<Object?> get props => const [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class ServerFailure extends Failure {
  const ServerFailure(this.statusCode);

  final int? statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();
}
