import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/features/authentication/authentication.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

part 'my_children_event.dart';
part 'my_children_state.dart';

class MyChildrenBloc extends Bloc<MyChildrenEvent, MyChildrenState> {
  final GetMyChildrenUC getMyChildrenUC;

  MyChildrenBloc({required this.getMyChildrenUC})
      : super(MyChildrenInitialState()) {
    on<GetMyChildren>(_onGetMyChildren);
  }

  FutureOr<void> _onGetMyChildren(
    GetMyChildren event,
    Emitter<MyChildrenState> emit,
  ) async {
    emit(MyChildrenInProgressState());

    final result = await getMyChildrenUC(NoParams());

    result.fold(
      (failure) => emit(MyChildrenFailureState(failure.toString())),
      (children) => emit(MyChildrenSuccessfulState(children)),
    );
  }
}
