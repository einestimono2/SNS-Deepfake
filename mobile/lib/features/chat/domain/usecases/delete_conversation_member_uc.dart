import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class DeleteConversationMemberUC
    extends UseCase<bool, DeleteConversationMemberParams> {
  final ChatRepository repository;

  DeleteConversationMemberUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteMember(
      id: params.id,
      memberId: params.memberId,
      kick: params.kick,
    );
  }
}

class DeleteConversationMemberParams {
  final int id;
  final int memberId;
  final bool kick;

  const DeleteConversationMemberParams({
    required this.id,
    required this.memberId,
    required this.kick,
  });
}
