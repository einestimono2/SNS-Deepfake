import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadImageUC uploadImageUC;

  UploadBloc({required this.uploadImageUC}) : super(InitialState()) {
    on<UploadImageSubmit>(_onUploadImageSubmit);
  }

  FutureOr<void> _onUploadImageSubmit(
    UploadImageSubmit event,
    Emitter<UploadState> emit,
  ) async {
    emit(InProgressState());

    final result = await uploadImageUC(UploadImageParams(path: event.path));

    result.fold(
      (failure) => emit(FailureState(message: failure.toString())),
      (url) => emit(SuccessfulState(url: url)),
    );
  }
}
