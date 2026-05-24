

# Riverpod 3 – Claude Code Kural Seti

Claude Code, Flutter projelerinde **sadece modern Riverpod 3 + `riverpod_annotation` + codegen** yaklaşımını kullansın.  
Eski `StateNotifierProvider`, `ChangeNotifier`, `.autoDispose` suffix’leri vb. **kullanılmamalıdır**.

---

## 0. Genel Prensipler

- Tüm provider’lar `@riverpod` veya `@Riverpod()` annotation’ı ile tanımlanır.
- Provider’lar **top-level** tanımlanır; sınıf içinden dinamik provider yaratılmaz.
- Varsayılan olarak provider’lar **autoDispose** davranışına sahiptir (codegen varsayımı). Kalıcı/global state için `@Riverpod(keepAlive: true)` kullanılır.
- Provider’lar **iş mantığı & shared state** içindir; tamamen kısa ömürlü/ephemeral UI state (tek sayfalık form, geçici text field state, animasyon controller vs.) için provider kullanılmamalıdır.
- Mümkün olduğunca **küçük, tek sorumluluklu** provider’lar tercih edilir.

---

## 1. Paketler & Tooling

Riverpod 3 + codegen tabanlı projede aşağıdaki setup kullanılır:

```yaml
environment:
  sdk: ^3.9.0
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.0.3
  riverpod_annotation: ^3.0.3

dev_dependencies:
  build_runner:
  custom_lint:
  riverpod_generator: ^3.0.3
  riverpod_lint: ^3.0.3
```

`analysis_options.yaml` içinde:

```yaml
analyzer:
  plugins:
    - custom_lint
```

Codegen komutları:

```bash
dart run build_runner watch -d
# veya
flutter pub run build_runner watch --delete-conflicting-outputs
```

Lint’ler:

```bash
dart run custom_lint
```

---

## 2. Dosya & Katman Yapısı

Önerilen yapı **feature bazlı**dır:

- `features/home/`
  - `home_state.dart` → immutable state modelleri (Freezed veya manuel).
  - `home_providers.dart` → `@riverpod` provider tanımları.
  - `home_view.dart` / `home_page.dart` → UI (ConsumerWidget / HookConsumerWidget).

Ortak servisler:

- `core/services/storage_service.dart`
- `core/services/api_client.dart`

Bu servisler için functional provider’lar ile DI yapılır. State class’ları mümkün olduğunca ayrı dosyalarda, provider dosyalarında sadece `@riverpod` fonksiyon/sınıflar bulunur.

---

## 3. Provider Tipleri (Codegen ile)

### 3.1 Functional Provider (stateless / computable)

Kullanım alanı: stateless servisler, basit hesaplanmış değerler, formatlayıcılar.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_providers.g.dart';

@riverpod
StorageService storage(Ref ref) => StorageServiceImpl();

@riverpod
String appVersion(Ref ref) => '1.0.0';
```

- Functional provider’lar UI tarafından mutate edilmez; sadece okuma amaçlıdır.

---

### 3.2 Sync Notifier (Notifier – senkron state)

Kullanım alanı: tamamen sync işleyen state makineleri (ör. player, filter, UI mode).

```dart
@riverpod
class Recording extends _$Recording {
  @override
  RecordingState build() => RecordingState.initial();

  void start() => state = state.copyWith(isRecording: true);
  void stop()  => state = state.copyWith(isRecording: false);
}
```

Kurallar:

- `build()` sadece başlangıç state’ini ve hafif init logic’ini içerir.
- UI tarafından trigger edilecek tüm aksiyonlar public metotlar olarak tanımlanır.
- State her zaman immutable’dır; güncelleme `copyWith` ile yapılır.

---

### 3.3 Async Notifier (AsyncNotifier – async init / async state)

Kullanım alanı: network çağrıları, DB okuma, uzun süren async işler.

```dart
@riverpod
class Home extends _$Home {
  @override
  Future<HomeState> build() async {
    final api = ref.watch(apiClientProvider);
    final items = await api.fetchItems();
    return HomeState(items: items);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.watch(apiClientProvider);
      final items = await api.fetchItems();
      return state.value!.copyWith(items: items);
    });
  }
}
```

UI tarafı:

```dart
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHome = ref.watch(homeProvider);

    return asyncHome.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text('Hata: $e'),
      data: (state) => HomeBody(state: state),
    );
  }
}
```

Async provider’lar `AsyncValue<T>` ile çalışır ve loading/error yönetimi bu tip üzerinden yapılır.

---

### 3.4 Stream Notifier (StreamNotifier – real-time akış)

Kullanım alanı: WebSocket, Firestore snapshots, canlı TTS progress vb.

```dart
@riverpod
class ChatStream extends _$ChatStream {
  @override
  Stream<List<Message>> build() async* {
    final repo = ref.watch(chatRepositoryProvider);
    yield* repo.messagesStream();
  }
}
```

UI tarafında yine `AsyncValue<StreamData>` ile çalışılır (örn. `ref.watch(chatStreamProvider)`).

---

### 3.5 Family / Parametreli Provider

Riverpod 3 + codegen ile `.family` yerine fonksiyon parametreleri kullanılır:

```dart
@riverpod
Future<User> user(Ref ref, {required String id}) async {
  final api = ref.watch(apiClientProvider);
  return api.fetchUser(id);
}

// UI:
final userAsync = ref.watch(userProvider(id: '123'));
```

Kurallar:

- Parametreler `==` açısından stabil olmalıdır (primitive tipler veya value object).
- Parametreli provider’lar için default autoDispose davranışı korunur.

---

### 3.6 keepAlive Provider’lar (global state)

Global app state (auth, settings, theme, player vb.) için:

```dart
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    // ilk açılışta user’ı yükle
  }

  Future<void> login(...) async { /* ... */ }
  Future<void> logout() async { /* ... */ }
}
```

Kurallar:

- Global durumlar (Auth, Settings, TTS, global Player vb.) için `keepAlive: true` kullanılır.
- Çoğu ekran spesifik provider autoDispose olarak bırakılır.

---

## 4. AutoDispose / Lifecycle

- Codegen ile provider’lar varsayılan olarak autoDispose’tur.
- Kalıcı olması gereken provider’lar için `@Riverpod(keepAlive: true)` kullanılır.
- Parametreli provider’lar autoDispose bırakılmalıdır (memory kullanımını optimize eder).
- Özel lifecycle ihtiyaçları için Notifier içinde `ref.onDispose` kullanılabilir:

```dart
@riverpod
class Player extends _$Player {
  @override
  PlayerState build() {
    final controller = AudioController();
    ref.onDispose(controller.dispose);
    return PlayerState.initial();
  }
}
```

---

## 5. View Tarafında Kullanım (Flutter)

Her Flutter ekranı **ConsumerWidget** veya **HookConsumerWidget** olmalıdır.

```dart
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHome = ref.watch(homeProvider);

    return asyncHome.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => ErrorView(e),
      data: (state) => HomeBody(state: state),
    );
  }
}
```

Kurallar:

- State okumak için **her zaman** `ref.watch(provider)` kullanılır.
- Action çağırmak için **her zaman** `ref.read(provider.notifier).method()` kullanılır.
- Yan etkiler (snackbar, navigation, dialog) için:
  - `ref.listen(provider, (prev, next) { ... })`, veya
  - Hook tabanlı yapılarda `useEffect` + `ref.listen` kombinasyonu tercih edilir.

Widget içinde doğrudan HTTP çağrısı, DB erişimi, complex business logic yazılmaz; bunlar provider’lara taşınır.

---

## 6. Yan Etkiler & Mutations (Riverpod 3)

Genel kural:

- Provider’lar **okuma/yansıtma** (read operations + state expose) için vardır.
- “Write” / side-effect (form submit, ödeme çağrısı, loglama) için:
  - Notifier içinde ayrı action metotları tanımlanır (ör. `submitForm()`).
  - Gerekirse Riverpod 3’ün Mutations API’si (experimental) kullanılabilir.

Kurallar:

- Provider init sırasında HTTP POST veya “yazma” tipi side-effect yapılmamalıdır.
- Side-effect gerektiren işler:
  - UI aksiyonu (buton tıklaması) → Notifier metodu çağrısı.
  - Bu metot içinde gerekli async çağrılar yapılır ve state güncellenir.

---

## 7. Offline Persistence (Experimental, Riverpod 3)

Gerekli durumlarda Notifier tabanlı provider’lar için **offline persistence** kullanılabilir (`persist(...)` API’si).

Örnek pattern:

```dart
@riverpod
Future<JsonSqFliteStorage> storage(Ref ref) async {
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), 'riverpod.db'));
}

@riverpod
class Todos extends _$Todos {
  @override
  Future<List<Todo>> build() async {
    persist(
      ref.watch(storageProvider.future),
      key: 'todos',
      encode: jsonEncode,
      decode: (json) {
        final decoded = jsonDecode(json) as List;
        return decoded
            .map((e) => Todo.fromJson(e as Map<String, Object?>))
            .toList();
      },
    );

    final todos = await fetchTodos();
    return todos;
  }

  Future<void> add(Todo todo) async {
    state = AsyncData([...await future, todo]);
  }
}
```

- Bu özellik opsiyoneldir; sadece gerekli senaryolarda kullanılmalıdır.

---

## 8. Test Yazımı (Kısaca Kurallar)

Unit test için:

```dart
void main() {
  test('home initial fetch', () async {
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(FakeApiClient()),
      ],
    );

    addTearDown(container.dispose);

    final result = await container.read(homeProvider.future);
    expect(result.items, isNotEmpty);
  });
}
```

Widget test’te:

- `ProviderScope(overrides: [...])` ile test spesifik override’lar yapılır.
- Gerekirse `WidgetTester` uzantıları ile container’a erişilip provider state’i okunur veya manipüle edilir.

Kurallar:

- Testler her zaman `ProviderContainer` veya `ProviderScope` üzerinden provider’lara erişmelidir.
- Global singleton kullanımı (GetIt vs.) testlerde yasaktır; bağımlılıklar provider üzerinden override edilir.

---

## 9. DO / DON’T Özet Kuralları

**Yapılmaması gerekenler:**

1. Widget `initState` içinde provider init etmek:
   - `ref.read(provider).init()` sadece kullanıcı aksiyonu veya route açılışı gibi durumlarda kullanılmalı; mümkünse init mantığı `build()` içine taşınmalıdır.

2. Ephemeral UI state için provider kullanmak:
   - Seçili tab index’i, tek sayfalık form field değerleri, animasyon controller gibi kısa ömürlü state’ler için `StatefulWidget` veya hooks kullanılmalıdır.

3. Provider init sırasında side-effect (HTTP POST, DB yazma vb.) yapmak:
   - Bu tip işlemler UI aksiyonlarıyla tetiklenen Notifier metotlarında veya Mutations API’de tutulmalıdır.

4. Dinamik provider oluşturmak:
   - Provider’lar **top-level final** olmalıdır. Sınıf içinde `final provider = Provider(...);` tanımı yapılmamalıdır.

5. Statik olarak bilinmeyen provider referanslarını `ref.watch`’a parametre geçmek:
   - Lint’lerin doğru çalışması için provider referansları compile-time bilinir olmalıdır.

**Tercih edilmesi gerekenler:**

- Her durumda `@riverpod` / `@Riverpod` + Notifier/AsyncNotifier pattern’i.
- Servisler/repository’ler için functional provider.
- Global durumlar için `keepAlive` provider’lar.
- Test, override ve DI için her zaman Riverpod graph’ı kullanmak.

---

## 10. Örnek Template’ler

### 10.1 Feature Template (Async + Sync)

**State**

```dart
// home_state.dart
class HomeState {
  final List<Item> items;
  final bool isGrid;

  const HomeState({
    required this.items,
    required this.isGrid,
  });

  factory HomeState.initial() => const HomeState(
        items: [],
        isGrid: true,
      );

  HomeState copyWith({
    List<Item>? items,
    bool? isGrid,
  }) {
    return HomeState(
      items: items ?? this.items,
      isGrid: isGrid ?? this.isGrid,
    );
  }
}
```

**Provider**

```dart
// home_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'home_state.dart';
import '../../core/services/api_client.dart';

part 'home_providers.g.dart';

@riverpod
class Home extends _$Home {
  @override
  Future<HomeState> build() async {
    final api = ref.watch(apiClientProvider);
    final items = await api.fetchItems();
    return HomeState(items: items, isGrid: true);
  }

  Future<void> toggleLayout() async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(isGrid: !current.isGrid));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.watch(apiClientProvider);
      final items = await api.fetchItems();
      return HomeState(items: items, isGrid: state.value?.isGrid ?? true);
    });
  }
}
```

**View**

```dart
// home_view.dart
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHome = ref.watch(homeProvider);

    return asyncHome.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => ErrorView(e),
      data: (state) => HomeBody(
        items: state.items,
        isGrid: state.isGrid,
        onToggleLayout: () =>
            ref.read(homeProvider.notifier).toggleLayout(),
        onRefresh: () =>
            ref.read(homeProvider.notifier).refresh(),
      ),
    );
  }
}
```

Bu dokümandaki kurallar, projede Riverpod 3 kullanımının **standart referansı** olarak kabul edilir.