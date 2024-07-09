// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/core/base/base_usecase.dart';
import 'package:sns_deepfake/features/group/group.dart';
import 'package:sns_deepfake/features/news_feed/news_feed.dart';
import 'package:sns_deepfake/features/profile/presentation/blocs/blocs.dart';
import 'package:sns_deepfake/features/search/blocs/search_post/search_post_bloc.dart';

import '../../../../app/bloc/bloc.dart';
import '../../../../profile/profile.dart';
import '../../../../search/blocs/blocs.dart';

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
  final ReportPostUC reportPostUC;

  final AppBloc appBloc;
  final ListPostBloc listPostBloc;
  final MyPostsBloc myPostsBloc;
  final UserPostsBloc userPostsBloc;
  final ListCommentBloc listCommentBloc;
  final GroupPostBloc groupPostBloc;
  final SearchPostBloc searchPostBloc;

  PostActionBloc({
    required this.createPostUC,
    required this.editPostUC,
    required this.getPostDetailsUC,
    required this.deletePostUC,
    required this.createCommentUC,
    required this.feelPostUC,
    required this.unfeelPostUC,
    required this.reportPostUC,
    /*  */
    required this.appBloc,
    required this.listPostBloc,
    required this.myPostsBloc,
    required this.userPostsBloc,
    required this.listCommentBloc,
    required this.groupPostBloc,
    required this.searchPostBloc,
  }) : super(PAInitialState()) {
    on<CreateCommentSubmit>(_onCreateCommentSubmit);
    on<CreatePostSubmit>(_onCreatePostSubmit);
    on<EditPostSubmit>(_onEditPostSubmit);
    on<DeletePostSubmit>(_onDeletePostSubmit);
    on<GetPostDetails>(_onGetPostDetails);
    on<FeelPost>(_onFeelPost);
    on<UnfeelPost>(_onUnfeelPost);
    on<ReportPostSubmit>(_onReportPostSubmit);
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
  ) async {
    final result = await editPostUC(EditPostParams(
      postId: event.postId,
      description: event.description,
      groupId: event.groupId,
      status: event.status,
      imageDel: event.imageDel,
      images: event.images,
      videos: event.videos,
      videoDel: event.videoDel,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user?.copyWith(coins: int.parse(data['coins'])),
          triggerRedirect: false,
        ));

        listPostBloc.add(UpdatePost(
          postId: event.postId,
          groupId: event.groupId,
          description: event.description,
        ));

        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onDeletePostSubmit(
    DeletePostSubmit event,
    Emitter<PostActionState> emit,
  ) async {
    final result = await deletePostUC(IdParams(event.postId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user?.copyWith(coins: int.parse(data)),
          triggerRedirect: false,
        ));

        listPostBloc.add(DeletePost(event.postId));

        event.onSuccess();
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

        groupPostBloc.add(UpdateGroupPostComment(
          postId: event.postId,
          fakeCounts: fakeCounts,
          trustCounts: trustCounts,
        ));

        searchPostBloc.add(UpdateSearchPostComment(
          postId: event.postId,
          fakeCounts: fakeCounts,
          trustCounts: trustCounts,
        ));

        myPostsBloc.add(UpdateMyPostsComment(
          postId: event.postId,
          fakeCounts: fakeCounts,
          trustCounts: trustCounts,
        ));

        userPostsBloc.add(UpdateUserPostsComment(
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

        groupPostBloc.add(UpdateGroupPostFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: event.type,
        ));

        searchPostBloc.add(UpdateSearchPostFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: event.type,
        ));

        myPostsBloc.add(UpdateMyPostsFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: event.type,
        ));

        userPostsBloc.add(UpdateUserPostsFeel(
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
    PASuccessfulState? preState;
    if (state is PASuccessfulState) {
      preState = state as PASuccessfulState;
    }

    final result = await unfeelPostUC(IdParams(event.postId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        if (preState is PASuccessfulState) {
          emit(
            PASuccessfulState(
                post: preState.post.copyWith(
                  myFeel: -1,
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
          type: -1,
        ));

        groupPostBloc.add(UpdateGroupPostFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: -1,
        ));

        searchPostBloc.add(UpdateSearchPostFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: -1,
        ));

        myPostsBloc.add(UpdateMyPostsFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: -1,
        ));

        userPostsBloc.add(UpdateUserPostsFeel(
          postId: event.postId,
          kudosCount: data["kudos"]!,
          disappointedCount: data["disappointed"]!,
          type: -1,
        ));
      },
    );
  }

  FutureOr<void> _onReportPostSubmit(
    ReportPostSubmit event,
    Emitter<PostActionState> emit,
  ) async {
    final result = await reportPostUC(ReportPostParams(
      postId: event.postId,
      content: event.content,
      subject: event.subject,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) => event.onSuccess(),
    );
  }
}
