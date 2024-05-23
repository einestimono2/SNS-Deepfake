part of 'friend_action_bloc.dart';

sealed class FriendActionEvent extends Equatable {
  const FriendActionEvent();

  @override
  List<Object> get props => [];
}

// Chấp nhận kết bạn
class AcceptRequestSubmit extends FriendActionEvent {
  final int targetId;

  const AcceptRequestSubmit(this.targetId);

  @override
  List<Object> get props => [targetId];
}

// Từ chối kết bạn
class RefuseRequestSubmit extends FriendActionEvent {
  final int targetId;

  const RefuseRequestSubmit(this.targetId);

  @override
  List<Object> get props => [targetId];
}

// Gửi yêu cầu kết bạn
class SendRequestSubmit extends FriendActionEvent {
  final int targetId;

  const SendRequestSubmit(this.targetId);

  @override
  List<Object> get props => [targetId];
}

// Xóa bạn bè
class UnfriendSubmit extends FriendActionEvent {
  final int targetId;

  const UnfriendSubmit(this.targetId);

  @override
  List<Object> get props => [targetId];
}
