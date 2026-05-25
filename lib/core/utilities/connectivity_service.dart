import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

// Mock internet bağlantı durumu yayınlayan StreamNotifier.
@Riverpod(keepAlive: true)
class ConnectivityService extends _$ConnectivityService {
  @override
  Stream<bool> build() {
    final controller = StreamController<bool>();
    var isConnected = true;
    controller.add(isConnected);

    // 5 sn'de bir %95 ihtimalle bağlantı var, %5 ihtimalle yok.
    final timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final random = DateTime.now().millisecondsSinceEpoch % 100;
      final newStatus = random < 95;
      if (isConnected != newStatus) {
        isConnected = newStatus;
        controller.add(newStatus);
      }
    });

    ref.onDispose(() {
      timer.cancel();
      controller.close();
    });

    return controller.stream;
  }
}
