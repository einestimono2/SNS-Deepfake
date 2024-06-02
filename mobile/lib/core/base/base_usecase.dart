import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class IdParams extends Equatable {
  final int id;

  const IdParams(this.id);

  @override
  List<Object> get props => [id];
}

class PaginationParams extends Equatable {
  final int? page;
  final int? size;

  const PaginationParams({this.page, this.size});

  @override
  List<Object?> get props => [page, size];
}
