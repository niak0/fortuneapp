import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_notifier.dart';
import '../../core/ui/ui_helper.dart';

// Anasayfa banner'ından tetiklenen bottom sheet — Google/Apple OAuth seçenekleri.
class SignInSheet extends ConsumerStatefulWidget {
  const SignInSheet({super.key});

  @override
  ConsumerState<SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends ConsumerState<SignInSheet> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (kDebugMode) debugPrint('SignInSheet error: $e');
      ref.read(uiHelperProvider).showSnackBar('Giriş başarısız. Tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hesabını kaydet',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Verilerin kaybolmasın diye Apple ya da Google ile giriş yap.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _OAuthButton(
              icon: Icons.apple,
              label: 'Apple ile devam et',
              busy: _busy,
              onPressed: () => _run(
                () => ref.read(authProvider.notifier).signInWithApple(),
              ),
            ),
            const SizedBox(height: 8),
            _OAuthButton(
              icon: Icons.g_mobiledata,
              label: 'Google ile devam et',
              busy: _busy,
              onPressed: () => _run(
                () => ref.read(authProvider.notifier).signInWithGoogle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Geniş, ikonlu giriş butonu.
class _OAuthButton extends StatelessWidget {
  const _OAuthButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.busy,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 1, color: Colors.white),
          ),
          minimumSize: const Size.fromHeight(50),
        ),
        icon: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(label),
        onPressed: busy ? null : onPressed,
      ),
    );
  }
}
