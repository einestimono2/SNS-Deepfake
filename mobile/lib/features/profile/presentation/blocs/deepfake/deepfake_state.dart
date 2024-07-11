part of 'deepfake_bloc.dart';

sealed class DeepfakeState extends Equatable {
  const DeepfakeState();
  
  @override
  List<Object> get props => [];
}

final class DeepfakeInitialState extends DeepfakeState {}
