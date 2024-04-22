part of 'upload_bloc.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

final class InitialState extends UploadState {}

final class InProgressState extends UploadState {}

final class SuccessfulState extends UploadState {
  final String url;

  const SuccessfulState({required this.url});

  @override
  List<Object> get props => [url];
}

final class FailureState extends UploadState {
  final String message;

  const FailureState({required this.message});

  @override
  List<Object> get props => [message];
}
