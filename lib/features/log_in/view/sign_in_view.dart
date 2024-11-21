import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/core/auth/auth_manager.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    final authManager = context.read<AuthManager>();
    ThemeData theme = Theme.of(context);

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
                    "Nasip: Fal, Astroloji",
                    style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.onSurface),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset(
                      Assets.iconIcLogo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text("Giriş Yap ya da Kayıt Ol", style: theme.textTheme.headlineSmall),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                      onPressed: () async {
                        if (kDebugMode) {
                          print("Apple ile Devam Et'e tıklandı");
                        }
                        await authManager.signIn();
                      },
                      title: 'Apple ile Devam Et',
                      icon: const Icon(Icons.apple_outlined)),
                  CustomElevatedButton(
                      onPressed: () async {
                        if (kDebugMode) {
                          print("Google ile Devam Et'e tıklandı");
                        }
                        await authManager.signIn();
                      },
                      title: 'Google ile Devam Et',
                      icon: const Icon(Icons.g_mobiledata_outlined)),
                ],
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Kayıt olarak ya da giriş yaparak Kullanım ve Gizlilik Koşullarını, okuduğumu ve kabul ettiğimi beyan ederim.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

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
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                width: 1,
                color: Colors.white,
              )),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50), // Genişliği ekranın tamamı, yüksekliği 50 olarak ayarlanır
        ),
        icon: icon,
        label: Text(title),
        onPressed: onPressed,
      ),
    );
  }
}
