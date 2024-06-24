part of 'download_bloc.dart';

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object> get props => [];
}

final class DownloadInitialState extends DownloadState {}

final class DownloadInProgressState extends DownloadState {}

final class DownloadSuccessfulState extends DownloadState {}

final class DownloadFailureState extends DownloadState {
  final String message;

  const DownloadFailureState(this.message);

  @override
  List<Object> get props => [message];
}
