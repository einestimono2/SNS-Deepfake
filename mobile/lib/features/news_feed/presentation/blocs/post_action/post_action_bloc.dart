import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/bloc/bloc.dart';
import '../../../../group/data/data.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../list_post/list_post_bloc.dart';

part 'post_action_event.dart';
part 'post_action_state.dart';

class PostActionBloc extends Bloc<PostActionEvent, PostActionState> {
  final CreatePostUC createPostUC;
  final EditPostUC editPostUC;
  final DeletePostUC deletePostUC;
  final GetPostDetailsUC getPostDetailsUC;

  final AppBloc appBloc;
  final ListPostBloc listPostBloc;

  PostActionBloc({
    required this.createPostUC,
    required this.editPostUC,
    required this.getPostDetailsUC,
    required this.deletePostUC,
    required this.appBloc,
    required this.listPostBloc,
  }) : super(PAInitialState()) {
    on<CreatePostSubmit>(_onCreatePostSubmit);
    on<EditPostSubmit>(_onEditPostSubmit);
    on<DeletePostSubmit>(_onDeletePostSubmit);
    on<GetPostDetails>(_onGetPostDetails);
    on<ResetState>(_onResetState);
  }

  FutureOr<void> _onCreatePostSubmit(
    CreatePostSubmit event,
    Emitter<PostActionState> emit,
  ) async {
    emit(PAInProgressState());

    final result = await createPostUC(CreatePostParams(
      groupId: event.groupId,
      description: event.description,
      files: event.files,
      status: event.status,
    ));

    result.fold(
      (failure) => emit(PAFailureState(
        message: failure.toString(),
        type: "CREATE_POST",
      )),
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
        appBloc.add(UpdateCoin(int.parse(data.data['coins'])));

        emit(const PASuccessfulState(type: "CREATE_POST"));
      },
    );
  }

  FutureOr<void> _onResetState(
    ResetState event,
    Emitter<PostActionState> emit,
  ) async {
    emit(PAInitialState());
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
      (failure) => emit(PAFailureState(
        message: failure.toString(),
        type: "DELETE_POST",
      )),
      (data) {
        appBloc.add(UpdateCoin(int.parse(data)));

        listPostBloc.add(DeletePost(event.postId));

        emit(const PASuccessfulState(type: "DELETE_POST"));
      },
    );
  }

  FutureOr<void> _onGetPostDetails(
    GetPostDetails event,
    Emitter<PostActionState> emit,
  ) async {}
}
