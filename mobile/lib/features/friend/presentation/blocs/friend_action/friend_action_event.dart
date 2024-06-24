part of 'friend_action_bloc.dart';

sealed class FriendActionEvent extends Equatable {
  const FriendActionEvent();

  @override
  List<Object> get props => [];
}

// Chấp nhận kết bạn
class AcceptRequestSubmit extends FriendActionEvent {
  final int targetId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const AcceptRequestSubmit({
    required this.targetId,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [targetId];
}

// Từ chối kết bạn
class RefuseRequestSubmit extends FriendActionEvent {
  final int targetId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const RefuseRequestSubmit({
    required this.targetId,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [targetId];
}

// Gửi yêu cầu kết bạn
class SendRequestSubmit extends FriendActionEvent {
  final int targetId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const SendRequestSubmit({
    required this.targetId,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [targetId];
}

// Hủy yêu cầu kết bạn đã gửi
class UnsentRequestSubmit extends FriendActionEvent {
  final int targetId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const UnsentRequestSubmit({
    required this.targetId,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [targetId];
}

// Xóa bạn bè
class UnfriendSubmit extends FriendActionEvent {
  final int targetId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const UnfriendSubmit({
    required this.targetId,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [targetId];
}
