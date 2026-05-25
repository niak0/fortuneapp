import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Test'lerde tek satırla override'lı ProviderContainer kurar; dispose teardown'a bağlar.
ProviderContainer makeContainer({List<dynamic> overrides = const []}) {
  final container = ProviderContainer(overrides: overrides.cast());
  addTearDown(container.dispose);
  return container;
}
