// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../app/app.dart';
import '../../../../friend/friend.dart';

part 'profile_action_event.dart';
part 'profile_action_state.dart';

class ProfileActionBloc extends Bloc<ProfileActionEvent, ProfileActionState> {
  final UpdateProfileUC updateProfileUC;
  final GetUserProfileUC getUserProfileUC;
  final SetBlockUC setBlockUC;
  final UnBlockUC unBlockUC;
  final ChangePasswordUC changePasswordUC;
  final BuyCoinsUC buyCoinsUC;

  final AppBloc appBloc;
  final UserPostsBloc userPostsBloc;
  final UserFriendsBloc userFriendsBloc;
  final ListFriendBloc listFriendBloc;

  ProfileActionBloc({
    required this.updateProfileUC,
    required this.getUserProfileUC,
    required this.setBlockUC,
    required this.unBlockUC,
    required this.changePasswordUC,
    required this.buyCoinsUC,
    /*  */
    required this.appBloc,
    required this.userPostsBloc,
    required this.userFriendsBloc,
    required this.listFriendBloc,
  }) : super(ProfileActionInitialState()) {
    on<UpdateProfileSubmit>(_onUpdateProfileSubmit);
    on<UpdateFriendStatus>(_onUpdateFriendStatus);
    on<GetUserProfile>(_onGetUserProfile);
    on<BlockSubmit>(_onBlockSubmit);
    on<UnblockSubmit>(_onUnblockSubmit);
    on<ChangePasswordSubmit>(_onChangePasswordSubmit);
    on<BuyCoinSubmit>(_onBuyCoinSubmit);
  }

  FutureOr<void> _onUpdateProfileSubmit(
    UpdateProfileSubmit event,
    Emitter<ProfileActionState> emit,
  ) async {
    final result = await updateProfileUC(UpdateProfileParams(
      username: event.username,
      phoneNumber: event.phoneNumber,
      avatar: event.avatar,
      coverPhoto: event.coverPhoto,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        appBloc.emit(appBloc.state.copyWith(
          user: data,
          triggerRedirect: false,
        ));

        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onGetUserProfile(
    GetUserProfile event,
    Emitter<ProfileActionState> emit,
  ) async {
    if (state is ProfileActionSuccessfulState &&
        (state as ProfileActionSuccessfulState).profile.id == event.id) {
      return;
    }

    emit(ProfileActionInProgressState());

    final result = await getUserProfileUC(IdParams(event.id));

    result.fold(
      (failure) => emit(ProfileActionFailureState(failure.toString())),
      (data) {
        emit(ProfileActionSuccessfulState(profile: data));

        if (data.blockStatus != BlockStatus.blocked) {
          userFriendsBloc.add(GetUserFriends(
            page: 1,
            size: AppStrings.listFriendPageSize,
            id: data.id,
          ));

          userPostsBloc.add(GetUserPosts(
            page: 1,
            size: AppStrings.listPostPageSize,
            id: data.id,
          ));
        }
      },
    );
  }

  FutureOr<void> _onUpdateFriendStatus(
    UpdateFriendStatus event,
    Emitter<ProfileActionState> emit,
  ) async {
    if (state is! ProfileActionSuccessfulState) return;

    final preState = state as ProfileActionSuccessfulState;

    if (preState.profile.friendStatus == FriendStatus.accepted &&
        listFriendBloc.state is LFSuccessfulState) {
      final preFriendState = listFriendBloc.state as LFSuccessfulState;

      final _friends =
          preFriendState.friends.where((e) => e.id != event.id).toList();

      listFriendBloc.emit(preFriendState.copyWith(
        friends: _friends,
        totalCount: _friends.length,
      ));
    }

    emit(preState.copyWith(
      profile: preState.profile.copyWith(friendStatus: event.status),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  FutureOr<void> _onBlockSubmit(
    BlockSubmit event,
    Emitter<ProfileActionState> emit,
  ) async {
    if (state is! ProfileActionSuccessfulState) return;
    final preState = state as ProfileActionSuccessfulState;

    final result = await setBlockUC(IdParams(event.id));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        emit(preState.copyWith(
          profile: preState.profile.copyWith(blockStatus: BlockStatus.blocking),
        ));
        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onUnblockSubmit(
    UnblockSubmit event,
    Emitter<ProfileActionState> emit,
  ) async {
    if (state is! ProfileActionSuccessfulState) return;
    final preState = state as ProfileActionSuccessfulState;

    final result = await unBlockUC(IdParams(event.id));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        emit(preState.copyWith(
          profile: preState.profile.copyWith(blockStatus: BlockStatus.none),
        ));
        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onChangePasswordSubmit(
    ChangePasswordSubmit event,
    Emitter<ProfileActionState> emit,
  ) async {
    final result = await changePasswordUC(ChangePasswordParams(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onBuyCoinSubmit(
    BuyCoinSubmit event,
    Emitter<ProfileActionState> emit,
  ) async {
    final coins = await buyCoinsUC(BuyCoinsParams(event.amount));

    coins.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user?.copyWith(coins: data),
          triggerRedirect: false,
        ));

        event.onSuccess();
      },
    );
  }
}
