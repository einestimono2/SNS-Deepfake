part of 'profile_action_bloc.dart';

sealed class ProfileActionEvent extends Equatable {
  const ProfileActionEvent();

  @override
  List<Object?> get props => [];
}

class GetUserProfile extends ProfileActionEvent {
  final int id;

  const GetUserProfile(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateProfileSubmit extends ProfileActionEvent {
  final String? username;
  final String? avatar;
  final String? coverPhoto;
  final String? phoneNumber;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const UpdateProfileSubmit({
    this.username,
    this.avatar,
    this.coverPhoto,
    this.phoneNumber,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [username, avatar, coverPhoto, phoneNumber];
}

class UpdateFriendStatus extends ProfileActionEvent {
  final FriendStatus status;
  final int id;

  const UpdateFriendStatus(this.status, this.id);

  @override
  List<Object?> get props => [status, id];
}

class BlockSubmit extends ProfileActionEvent {
  final int id;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const BlockSubmit({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [id];
}

class UnblockSubmit extends ProfileActionEvent {
  final int id;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const UnblockSubmit({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [id];
}

class ChangePasswordSubmit extends ProfileActionEvent {
  final String oldPassword;
  final String newPassword;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const ChangePasswordSubmit({
    required this.oldPassword,
    required this.newPassword,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class BuyCoinSubmit extends ProfileActionEvent {
  final VoidCallback onSuccess;
  final Function(String) onError;
  final int amount;

  const BuyCoinSubmit({
    required this.onSuccess,
    required this.onError,
    required this.amount,
  });

  @override
  List<Object?> get props => [amount];
}
