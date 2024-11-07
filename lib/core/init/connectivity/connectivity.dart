import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends StatefulWidget {
  final Widget child;

  const ConnectivityProvider({super.key, required this.child});

  static _ConnectivityProviderState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedConnectivityProvider>()?.state;
  }

  @override
  _ConnectivityProviderState createState() => _ConnectivityProviderState();
}

class _ConnectivityProviderState extends State<ConnectivityProvider> {
  late Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedConnectivityProvider(
      state: this,
      child: widget.child,
    );
  }
}

class _InheritedConnectivityProvider extends InheritedWidget {
  final _ConnectivityProviderState state;

  const _InheritedConnectivityProvider({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
