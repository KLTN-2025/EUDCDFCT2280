import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetProvider extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  StreamSubscription? _internetSubscription;

  InternetProvider() {
    _internetSubscription =
        InternetConnection().onStatusChange.listen((status) {
      _isConnected = status == InternetStatus.connected;
      notifyListeners(); // Cập nhật tất cả màn hình
    });
  }

  @override
  void dispose() {
    _internetSubscription?.cancel();
    super.dispose();
  }
}
