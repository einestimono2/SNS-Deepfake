part of 'upload_bloc.dart';

sealed class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class UploadImageSubmit extends UploadEvent {
  final String path;

  const UploadImageSubmit({required this.path});

  @override
  List<Object> get props => [path];
}
