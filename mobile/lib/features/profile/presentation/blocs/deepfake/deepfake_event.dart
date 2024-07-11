part of 'deepfake_bloc.dart';

sealed class DeepfakeEvent extends Equatable {
  const DeepfakeEvent();

  @override
  List<Object?> get props => [];
}

class CreateVideoDeepfakeSubmit extends DeepfakeEvent {
  final String title;
  final String video;
  final String image;
  final List<String>? audios;
  final Function() onSuccess;
  final Function(String) onError;

  const CreateVideoDeepfakeSubmit({
    required this.title,
    required this.video,
    required this.image,
    this.audios,
    required this.onSuccess,
    required this.onError,
  });
}
