// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/bloc/bloc.dart';
import '../../../../news_feed/news_feed.dart';
import '../../../group.dart';

part 'group_post_event.dart';
part 'group_post_state.dart';

class GroupPostBloc extends Bloc<GroupPostEvent, GroupPostState> {
  final GetListPostUC getListPostUC;
  final CreatePostUC createPostUC;

  final AppBloc appBloc;
  final ListPostBloc listPostBloc;

  GroupPostBloc({
    required this.getListPostUC,
    required this.createPostUC,
    required this.appBloc,
    required this.listPostBloc,
  }) : super(GroupPostInitialState()) {
    on<GetListPost>(_onGetListPost);
    on<LoadMoreListPost>(_onLoadMoreListPost);
    on<CreateGroupPostSubmit>(_onCreateGroupPostSubmit);
  }

  FutureOr<void> _onGetListPost(
    GetListPost event,
    Emitter<GroupPostState> emit,
  ) async {
    emit(GroupPostInProgressState());

    final result = await getListPostUC(GetListPostParams(
      page: event.page,
      size: event.size,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => emit(GroupPostFailureState(failure.toString())),
      (response) => emit(
        GroupPostSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          posts: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreListPost(
    LoadMoreListPost event,
    Emitter<GroupPostState> emit,
  ) async {
    if (state is GroupPostInProgressState) return;

    // Previous value
    GroupPostSuccessfulState preLoaded = state as GroupPostSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListPostUC(GetListPostParams(
      page: event.page,
      size: event.size,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => emit(GroupPostFailureState(failure.toString())),
      (response) => emit(
        GroupPostSuccessfulState(
          posts: [...preLoaded.posts, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onCreateGroupPostSubmit(
    CreateGroupPostSubmit event,
    Emitter<GroupPostState> emit,
  ) async {
    if (state is GroupPostInProgressState) return;
    GroupPostSuccessfulState preState = state as GroupPostSuccessfulState;

    final result = await createPostUC(CreatePostParams(
      groupId: event.group.id,
      description: event.description,
      files: event.files,
      status: event.status,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        ShortGroupModel group = ShortGroupModel.fromGroupModel(event.group);

        Map<String, dynamic> _postData = {
          ...data.data['post'],
          "group": group.toMap(),
        };

        PostModel post = PostModel.fromMap({
          "post": _postData,
          "can_edit": 1,
          "banned": 0,
        });

        emit(preState.copyWith(posts: [post, ...preState.posts]));

        event.onSuccess();

        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user
              ?.copyWith(coins: int.parse(data.data['coins'])),
          triggerRedirect: false,
        ));
        listPostBloc.add(AddPost(post));
      },
    );
  }
}
