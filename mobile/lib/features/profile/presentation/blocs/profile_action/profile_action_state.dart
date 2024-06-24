part of 'profile_action_bloc.dart';

sealed class ProfileActionState extends Equatable {
  const ProfileActionState();

  @override
  List<Object> get props => [];
}

final class ProfileActionInitialState extends ProfileActionState {}

final class ProfileActionInProgressState extends ProfileActionState {}

class ProfileActionSuccessfulState extends ProfileActionState {
  final ProfileModel profile;
  final int timestamp;

  const ProfileActionSuccessfulState({
    required this.profile,
    this.timestamp = 0,
  });

  @override
  List<Object> get props => [profile, timestamp];

  ProfileActionSuccessfulState copyWith({
    ProfileModel? profile,
    int? timestamp,
  }) {
    return ProfileActionSuccessfulState(
      profile: profile ?? this.profile,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class ProfileActionFailureState extends ProfileActionState {
  final String message;

  const ProfileActionFailureState(this.message);

  @override
  List<Object> get props => [message];
}
