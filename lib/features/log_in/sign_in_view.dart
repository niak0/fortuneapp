import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/auth/auth_notifier.dart';

import '../../../generated/assets.dart';

// Apple/Google ile giriş ekranı (mock auth).
class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.read(authProvider.notifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nasip: Fal, Astroloji',
                    style: theme.textTheme.headlineLarge
                        ?.copyWith(color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset(Assets.iconIcLogo, fit: BoxFit.cover),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text('Giriş Yap ya da Kayıt Ol',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    onPressed: () async {
                      if (kDebugMode) print("Apple ile Devam Et'e tıklandı");
                      await auth.signIn();
                    },
                    title: 'Apple ile Devam Et',
                    icon: const Icon(Icons.apple_outlined),
                  ),
                  CustomElevatedButton(
                    onPressed: () async {
                      if (kDebugMode) print("Google ile Devam Et'e tıklandı");
                      await auth.signIn();
                    },
                    title: 'Google ile Devam Et',
                    icon: const Icon(Icons.g_mobiledata_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Kayıt olarak ya da giriş yaparak Kullanım ve Gizlilik Koşullarını, okuduğumu ve kabul ettiğimi beyan ederim.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Geniş, ikonlu özel elevated buton.
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 1, color: Colors.white),
          ),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
        ),
        icon: icon,
        label: Text(title),
        onPressed: onPressed,
      ),
    );
  }
}
