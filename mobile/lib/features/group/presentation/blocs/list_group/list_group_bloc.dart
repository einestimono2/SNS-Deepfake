import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/features/app/bloc/bloc.dart';

import '../../../../app/app.dart';
import '../../../domain/domain.dart';

part 'list_group_event.dart';
part 'list_group_state.dart';

class ListGroupBloc extends Bloc<ListGroupEvent, ListGroupState> {
  final MyGroupsUC myGroupsUC;

  final AppBloc appBloc;

  ListGroupBloc({
    required this.myGroupsUC,
    required this.appBloc,
  }) : super(ListGroupInitialState()) {
    on<GetMyGroups>(_onGetMyGroups);
  }

  FutureOr<void> _onGetMyGroups(
    GetMyGroups event,
    Emitter<ListGroupState> emit,
  ) async {
    emit(ListGroupInProgressState());

    final result = await myGroupsUC(PaginationParams(
      size: event.size,
      page: event.page,
    ));

    result.fold(
      (failure) => emit(ListGroupFailureState(failure.toString())),
      // ignore: invalid_use_of_visible_for_testing_member
      (data) => appBloc.emit(appBloc.state.copyWith(
        user: appBloc.state.user,
        groups: data.data,
      )),
    );
  }
}
