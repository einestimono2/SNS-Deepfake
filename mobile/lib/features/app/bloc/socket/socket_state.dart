part of 'socket_bloc.dart';

class SocketState extends Equatable {
  final String? errorMsg;

  final List<int> online;
  final SocketStatus status;

  const SocketState._({
    this.errorMsg,
    this.online = const [],
    this.status = SocketStatus.unknown,
  });

  factory SocketState.initial() => const SocketState._();
  factory SocketState.connected() =>
      const SocketState._(status: SocketStatus.connected);
  factory SocketState.disconnected() =>
      const SocketState._(status: SocketStatus.disconnected);

  @override
  List<Object?> get props => [errorMsg, online, status];

  SocketState copyWith({
    String? errorMsg,
    List<int>? online,
    SocketStatus? status,
  }) {
    return SocketState._(
      errorMsg: errorMsg,
      online: online ?? this.online,
      status: status ?? this.status,
    );
  }
}
