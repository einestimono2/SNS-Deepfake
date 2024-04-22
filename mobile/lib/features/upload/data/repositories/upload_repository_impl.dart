import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';
import '../datasources/upload_remote_datasource.dart';

class UploadRepositoryImpl extends BaseRepositoryImpl
    implements UploadRepository {
  final UploadRemoteDataSource remote;

  UploadRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, String>> uploadImage({required String path}) async {
    return await checkNetwork<String>(
      () async {
        final url = await remote.uploadImage(path);

        return Right(url);
      },
    );
  }
}
