import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/chat_repository.dart';

class AddConversationMemberUC
    extends UseCase<List<MemberModel>, AddConversationMemberParams> {
  final ChatRepository repository;

  AddConversationMemberUC({required this.repository});

  @override
  Future<Either<Failure, List<MemberModel>>> call(params) async {
    return await repository.addMember(
      id: params.id,
      memberIds: params.memberIds,
    );
  }
}

class AddConversationMemberParams {
  final int id;
  final List<int> memberIds;

  const AddConversationMemberParams({
    required this.id,
    required this.memberIds,
  });
}
