// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/core/base/base_usecase.dart';
import 'package:sns_deepfake/features/news_feed/news_feed.dart';

import '../../../../app/bloc/bloc.dart';
import '../../../../group/data/data.dart';
import '../../../../profile/profile.dart';

part 'post_action_event.dart';
part 'post_action_state.dart';

class PostActionBloc extends Bloc<PostActionEvent, PostActionState> {
  final CreatePostUC createPostUC;
  final EditPostUC editPostUC;
  final DeletePostUC deletePostUC;
  final GetPostDetailsUC getPostDetailsUC;
  final CreateCommentUC createCommentUC;
  final FeelPostUC feelPostUC;
  final UnfeelPostUC unfeelPostUC;

  final AppBloc appBloc;
  final ListPostBloc listPostBloc;
  final MyPostsBloc myPostsBloc;
  final ListCommentBloc listCommentBloc;

  PostActionBloc({
    required this.createPostUC,
    required this.editPostUC,
    required this.getPostDetailsUC,
    required this.deletePostUC,
    required this.createCommentUC,
    required this.feelPostUC,
    required this.unfeelPostUC,
    /*  */
    required this.appBloc,
    required this.listPostBloc,
    required this.myPostsBloc,
    required this.listCommentBloc,
  }) : super(PAInitialState()) {
    on<CreateCommentSubmit>(_onCreateCommentSubmit);
    on<CreatePostSubmit>(_onCreatePostSubmit);
    on<EditPostSubmit>(_onEditPostSubmit);
    on<DeletePostSubmit>(_onDeletePostSubmit);
    on<GetPostDetails>(_onGetPostDetails);
    on<FeelPost>(_onFeelPost);
    on<UnfeelPost>(_onUnfeelPost);
  }

  FutureOr<void> _onCreatePostSubmit(
    CreatePostSubmit event,
    Emitter<PostActionState> emit,
  ) async {
    final result = await createPostUC(CreatePostParams(
      groupId: event.groupId,
      description: event.description,
      files: event.files,
      status: event.status,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        ShortGroupModel? group;
        if (event.groupId != 0) {
          for (var gr in appBloc.state.groups) {
            if (gr.id == event.groupId) {
              group = ShortGroupModel.fromGroupModel(gr);
              break;
            }
          }
        }

        Map<String, dynamic> _postData = {
          ...data.data['post'],
          "group": group?.toMap(),
        };

        PostModel post = PostModel.fromMap({
          "post": _postData,
          "can_edit": 1,
          "banned": 0,
        });

        listPostBloc.add(AddPost(post));
        myPostsBloc.add(AddMyPost(post));

        /* Cập nhật coins */
        appBloc.emit(appBloc.state.copyWith(
          triggerRedirect: false,
          user: appBloc.state.user
              ?.copyWith(coins: int.parse(data.data['coins'])),
        ));

        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onEditPostSubmit(
    EditPostSubmit event,
    Emitter<PostActionState> emit,
  ) async {}

  FutureOr<void> _onDeletePostSubmit(
    DeletePostSubmit event,
    Emitter<PostActionState> emit,
  ) async {
    emit(PAInProgressState());

    final result = await deletePostUC(DeletePostParams(
      groupId: event.groupId,
      postId: event.postId,
    ));

    result.fold(
      (failure) => emit(PAFailureState(failure.toString())),
      (data) {
        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user?.copyWith(coins: int.parse(data)),
          triggerRedirect: false,
        ));

        listPostBloc.add(DeletePost(event.postId));
      },
    );
  }

  FutureOr<void> _onGetPostDetails(
    GetPostDetails event,
    Emitter<PostActionState> emit,
  ) async {
    emit(PAInProgressState());

    final result = await getPostDetailsUC(IdParams(event.postId));

    result.fold(
      (failure) => emit(PAFailureState(failure.toString())),
      (data) {
        emit(PASuccessfulState(post: data));
      },
    );
  }

  FutureOr<void> _onCreateCommentSubmit(
    CreateCommentSubmit event,
    Emitter<PostActionState> emit,
  ) async {
    final result = await createCommentUC(CreateCommentParams(
      postId: event.postId,
      content: event.content,
      type: event.type,
      page: event.page,
      size: event.size,
      markId: event.markId,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        listCommentBloc.add(UpdateListComment(
          comments: data["data"],
          hasReachedMax: data["pageIndex"] == data["totalPages"],
          totalCount: data["totalCount"],
        ));

        /* Cập nhật coins */
        appBloc.emit(appBloc.state.copyWith(
          triggerRedirect: false,
          user: appBloc.state.user?.copyWith(coins: int.parse(data['coins'])),
        ));

        event.onSuccess();

        int fakeCounts = 0;
        int trustCounts = 0;

        for (CommentModel comment in data["data"]) {
          if (comment.type == 1) {
            fakeCounts++;
          } else {
            trustCounts++;
          }
        }

        listPostBloc.add(UpdateCommentSummary(
          postId: event.postId,
          fakeCounts: fakeCounts,
          trustCounts: trustCounts,
        ));
      },
    );
  }

  FutureOr<void> _onFeelPost(
    FeelPost event,
    Emitter<PostActionState> emit,
  ) async {
    PASuccessfulState? preState;

    if (state is PASuccessfulState) {
      preState = state as PASuccessfulState;
    }

    final result = await feelPostUC(FeelPostParams(
      postId: event.postId,
      type: event.type,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        if (preState is PASuccessfulState) {
          emit(
            PASuccessfulState(
                post: preState.post.copyWith(
                  myFeel: event.type,
                  kudosCount: data["kudos"]!,
                  disappointedCount: data["disappointed"]!,
                ),
                timestamp: DateTime.now().millisecondsSinceEpoch),
          );
        }

        event.onSuccess();

        listPostBloc.add(UpdateFeelSummary(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: event.type,
        ));
      },
    );
  }

  FutureOr<void> _onUnfeelPost(
    UnfeelPost event,
    Emitter<PostActionState> emit,
  ) async {
    if (state is! PASuccessfulState) return;

    final preState = state as PASuccessfulState;

    final result = await unfeelPostUC(IdParams(event.postId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        emit(
          PASuccessfulState(
              post: preState.post.copyWith(
                myFeel: -1,
                kudosCount: data["kudos"]!,
                disappointedCount: data["disappointed"]!,
              ),
              timestamp: DateTime.now().millisecondsSinceEpoch),
        );

        event.onSuccess();

        listPostBloc.add(UpdateFeelSummary(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: -1,
        ));
      },
    );
  }
}
