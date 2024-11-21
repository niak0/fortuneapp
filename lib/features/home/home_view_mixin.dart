import 'package:flutter/material.dart';
import 'package:fortuneapp/core/utils/gold_manager.dart';
import 'package:provider/provider.dart';
import '../../core/network/mock_firebase_service.dart';
import 'home_view.dart';

mixin HomeViewMixin on State<HomeView> {
  late MockFirebaseService firebaseService;
  late GoldManager goldManager;

  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    firebaseService = context.read<MockFirebaseService>();
    goldManager = context.read<GoldManager>();
  }
}
