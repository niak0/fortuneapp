import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/custom_button.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/widgets/snackbar.dart';
import '../../generated/assets.dart';
import 'fortune_dream_providers.dart';

// Kullanıcının rüyasını yazıp yorumlatabildiği ekran.
class FortuneDreamView extends ConsumerStatefulWidget {
  const FortuneDreamView({super.key});

  @override
  ConsumerState<FortuneDreamView> createState() => _FortuneDreamViewState();
}

// Rüya metni controller'ının ömrünü yöneten state.
class _FortuneDreamViewState extends ConsumerState<FortuneDreamView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Rüya metnini yorumlatma akışını başlatır.
  Future<void> _interpret() async {
    final notifier = ref.read(fortuneDreamViewModelProvider.notifier);
    if (!ref.read(fortuneDreamViewModelProvider).isValid) {
      CustomSnackBar.show('Lütfen rüyanızı yazınız');
      return;
    }
    LoadingDialog.show(context);
    final ok = await notifier.submit();
    if (!mounted) return;
    LoadingDialog.hide(context);
    if (ok) ref.read(appNavigatorProvider).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rüya Tabiri')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: 300,
                child: Image.asset(Assets.iconImageDream, fit: BoxFit.fill),
              ),
              const SizedBox(height: 20),
              Text(
                'Gördüğün rüyanın sana ne anlatmak istediğini merak ediyor musun?',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                autofocus: false,
                maxLines: 10,
                onChanged: (value) => ref
                    .read(fortuneDreamViewModelProvider.notifier)
                    .setDreamText(value),
                decoration: const InputDecoration(
                  hintText:
                      'Gördüğünüz rüyayı tüm ayrıntılarıyla birlikte gördüklerinizi, '
                      'hissettiklerinizi ve gördüklerinizin fiziksel '
                      'özelliklerini açıklayınız',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(text: 'Rüyayı Yorumla', onPressed: _interpret),
            ],
          ),
        ),
      ),
    );
  }
}
