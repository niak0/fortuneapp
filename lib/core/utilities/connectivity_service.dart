import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

// Cihazın ağ bağlantısı olup olmadığını yayınlayan StreamNotifier.
@Riverpod(keepAlive: true)
class ConnectivityService extends _$ConnectivityService {
  @override
  Stream<bool> build() async* {
    final connectivity = Connectivity();
    // Açılışta mevcut durumu hemen yayınla.
    yield _isConnected(await connectivity.checkConnectivity());
    // Sonraki bağlantı değişikliklerini dinle.
    yield* connectivity.onConnectivityChanged.map(_isConnected);
  }

  // En az bir aktif ağ arayüzü varsa bağlantı var sayılır.
  bool _isConnected(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
