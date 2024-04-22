import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class UploadRepository {
  Future<Either<Failure, String>> uploadImage({required String path});
}
