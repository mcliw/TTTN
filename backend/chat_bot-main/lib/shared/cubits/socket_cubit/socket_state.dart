import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_state.freezed.dart';

@freezed
class SocketState with _$SocketState {
  factory SocketState.connecting() = _SocketConnectingState;
  factory SocketState.connected() = _SocketConnectedState;
  factory SocketState.disconnected() = _SocketDisconnectedState;
}
