import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  final String? message;

  OfflineFailure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? 'OfflineFailure - message - null';
}

class ServerFailure extends Failure {
  final String? message;

  ServerFailure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? 'ServerFailure - message - null';
}

class HttpFailure extends Failure {
  final dynamic message;

  HttpFailure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? 'HttpFailure - message - null';
}

class EmptyCacheFailure extends Failure {
  final String? message;

  EmptyCacheFailure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? 'EmptyCacheFailure - message - null';
}

class UnauthenticatedFailure extends Failure {
  final String? message;

  UnauthenticatedFailure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message ?? 'UnauthenticatedFailure - message - null';
}
