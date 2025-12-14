import 'dart:async';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/shared/cubits/socket_cubit/socket_cubit.dart';


class ConnectionWidget extends StatefulWidget {
  final Widget child;
  const ConnectionWidget({
    super.key,
    required this.child,
  });

  @override
  State<ConnectionWidget> createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  StreamSubscription? subscription;
  bool? hasInternet;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then(
      (value) => Connectivity().checkConnectivity().then(
        (results) {
          if (results.equals([ConnectivityResult.none]) ||
              results.equals([ConnectivityResult.bluetooth])) {
            onOffline();
            hasInternet = false;
          }
        },
      ),
    );
    subscription = Connectivity().onConnectivityChanged.listen(
      (results) {
        if (results.equals([ConnectivityResult.none]) ||
            results.equals([ConnectivityResult.bluetooth])) {
          if (hasInternet == true) {
            if (mounted) {
              // context.read<SocketCubit>().disconnect();
            }
            onOffline();
            hasInternet = false;
          }
        } else {
          if (hasInternet == false) {
            onOnline();
            if (mounted) {
              // context.read<SocketCubit>().connect();
            }
          }
          hasInternet = true;
        }
      },
    );
  }

  void onOffline() {}

  void onOnline() {}

  @override
  void dispose() {
    hasInternet = null;
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
