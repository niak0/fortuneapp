import 'dart:async';
import 'package:flutter/material.dart';

// Mock internet bağlantı servisi
class ConnectivityService extends ChangeNotifier {
  bool isConnected = true;
  Timer? _mockTimer;

  ConnectivityService() {
    _initializeMockConnectivity();
  }

  void _initializeMockConnectivity() {
    // Her 5 saniyede bir %95 ihtimalle bağlantı var, %5 ihtimalle yok
    _mockTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final random = DateTime.now().millisecondsSinceEpoch % 100;
      final newStatus = random < 95; // %95 ihtimalle true

      if (isConnected != newStatus) {
        isConnected = newStatus;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _mockTimer?.cancel();
    super.dispose();
  }
}
