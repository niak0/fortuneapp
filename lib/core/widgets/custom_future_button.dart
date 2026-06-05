import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomFutureButton extends StatelessWidget {
  final AsyncValueGetter<void> onPressed;
  final String title;

  /// setState ihtiyacını kaldırır. değişime göre ui günceller
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  CustomFutureButton({required this.onPressed, required this.title, super.key});

  Future<void> _onPressed() async {
    _isLoading.value = true;
    try {
      await onPressed();
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onPressed,
            child: isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : Text(title),
          ),
        );
      },
    );
  }
}
