import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/upload_repository.dart';

class UploadImageUC extends UseCase<String, UploadImageParams> {
  final UploadRepository repository;

  UploadImageUC({required this.repository});

  @override
  Future<Either<Failure, String>> call(params) async {
    return await repository.uploadImage(
      path: params.path,
    );
  }
}

class UploadImageParams {
  final String path;

  const UploadImageParams({required this.path});
}
