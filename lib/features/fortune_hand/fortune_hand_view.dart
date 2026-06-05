import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/widgets/loading_dialog.dart';
import 'fortune_hand_providers.dart';

// Kullanıcının el fotoğrafını çekip el falı için gönderdiği ekran.
class FortuneHandView extends ConsumerWidget {
  const FortuneHandView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fortuneHandViewModelProvider);
    final notifier = ref.read(fortuneHandViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('El Falı')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.photoPath != null)
              Expanded(
                child: Image.file(File(state.photoPath!), fit: BoxFit.contain),
              )
            else
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'El falın için avucunun net bir fotoğrafını çek.',
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: notifier.pickPhoto,
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(state.hasPhoto ? 'Yeniden Çek' : 'Fotoğraf Çek'),
              ),
            ),
            if (state.hasPhoto)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ElevatedButton(
                  onPressed: () => _interpret(context, ref, notifier),
                  child: const Text('Yorumla'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // El falı yorumlama akışını başlatır; başarılıysa ekranı kapatır.
  Future<void> _interpret(
    BuildContext context,
    WidgetRef ref,
    FortuneHandViewModel notifier,
  ) async {
    LoadingDialog.show(context);
    final ok = await notifier.submit();
    if (context.mounted) LoadingDialog.hide(context);
    if (ok) ref.read(appNavigatorProvider).pop();
  }
}
