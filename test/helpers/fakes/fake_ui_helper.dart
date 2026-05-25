import 'package:fortuneapp/core/ui/ui_helper.dart';

// SnackBar/loading çağrılarını yakalayan fake.
class FakeUiHelper implements UiHelper {
  final List<String> snackBars = [];
  int loadingShowCount = 0;
  int loadingHideCount = 0;

  @override
  void showSnackBar(String message) => snackBars.add(message);

  @override
  void showLoading() => loadingShowCount++;

  @override
  void hideLoading() => loadingHideCount++;
}
