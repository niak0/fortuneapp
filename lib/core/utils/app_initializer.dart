import 'package:flutter/material.dart';
import 'package:fortuneapp/core/models/current_user.dart';
import 'package:fortuneapp/core/network/mock_service.dart';
import 'package:provider/provider.dart';

class AppInitializer {
  static Future<void> init(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Mock servisi başlat
    await _initializeMockService();

    // Mock kullanıcıyı yükle
    await _initializeMockUser(context);

    await Future.wait([
      _initializeSettings(),
      _initializeTheme(),
    ]);
  }

  static Future<void> _initializeMockService() async {
    await MockService.initializeData();
  }

  static Future<void> _initializeMockUser(BuildContext context) async {
    final currentUser = Provider.of<CurrentUser>(context, listen: false);
    await currentUser.initializeMockUser();
  }

  static Future<void> _initializeSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  static Future<void> _initializeTheme() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
