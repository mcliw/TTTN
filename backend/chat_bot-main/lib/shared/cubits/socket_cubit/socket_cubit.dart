// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'socket_state.dart';
// export 'socket_state.dart';

// class SocketCubit extends Cubit<SocketState> {
//   final UserRepository userRepository;

//   SocketCubit({
//     required this.userRepository,
//   }) : super(SocketState.connecting());

//   void connect() {
//     userRepository.initSocket();
//     userRepository.socket
//       ?..on('connect', _onConnect)
//       ..on('connect_error', _onConnectError)
//       ..on('disconnect', _onDisConnect)
//       ..on('error', _onConnectError)
//       ..on('reconnect', _onReconnect)
//       ..on('reconnect_attempt', _onReconnect)
//       ..on('reconnect_failed', _onConnectError)
//       ..on('reconnect_error', _onConnectError);
//   }

//   void disconnect() {
//     userRepository.disconnectSocket();
//     userRepository.socket
//       ?..off('connect', _onConnect)
//       ..off('connect_error', _onConnectError)
//       ..off('disconnect', _onDisConnect)
//       ..off('error', _onConnectError)
//       ..off('reconnect', _onReconnect)
//       ..off('reconnect_attempt', _onReconnect)
//       ..off('reconnect_failed', _onConnectError)
//       ..off('reconnect_error', _onConnectError);
//     userRepository.closeSocket();
//     emit(SocketState.disconnected());
//   }

//   void _onConnect(dynamic data) {
//     emit(SocketState.connected());
//   }

//   void _onDisConnect(dynamic data) {
//     emit(SocketState.disconnected());
//   }

//   void _onConnectError(dynamic data) {
//     emit(SocketState.disconnected());
//   }

//   void _onReconnect(dynamic data) {
//     emit(SocketState.connecting());
//   }

//   void reconnect() {
//     disconnect();
//     connect();
//   }

//   @override
//   Future<void> close() {
//     disconnect();
//     return super.close();
//   }
// }

// mixin SocketMixin<Page extends StatefulWidget> on State<Page> {
//   late StreamSubscription socketSubscription;
//   @override
//   void initState() {
//     super.initState();
//     socketSubscription = context.read<SocketCubit>().stream.listen((state) {
//       state.whenOrNull(
//         connected: () => onSocketConnected(),
//         disconnected: () => onSocketDisconnected(),
//         connecting: () => onSocketConnecting(),
//       );
//     });
//   }

//   void onSocketConnected() {}

//   void onSocketDisconnected() {}

//   void onSocketConnecting() {}

//   @override
//   void dispose() {
//     socketSubscription.cancel();
//     super.dispose();
//   }
// }
