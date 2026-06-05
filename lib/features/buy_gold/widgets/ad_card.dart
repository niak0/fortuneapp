import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';

import '../buy_gold_providers.dart';

// "Reklam izle, altın kazan" kartı — ödüllü AdMob reklamını tetikler.
class AdCard extends ConsumerStatefulWidget {
  const AdCard({super.key});

  @override
  ConsumerState<AdCard> createState() => _AdCardState();
}

class _AdCardState extends ConsumerState<AdCard> {
  bool _isWatching = false;

  // Ödüllü reklamı gösterir ve sonucuna göre kullanıcıyı bilgilendirir.
  Future<void> _watchAd() async {
    if (_isWatching) return;
    setState(() => _isWatching = true);
    final earned =
        await ref.read(buyGoldViewModelProvider.notifier).watchRewardedAd();
    if (!mounted) return;
    setState(() => _isWatching = false);
    CustomSnackBar.show(
      earned
          ? 'Tebrikler! $kRewardedAdGold altın kazandın'
          : 'Reklam şu an hazır değil, birazdan tekrar dene',
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: _isWatching ? null : _watchAd,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          'Reklam İzle Kredi Kazan',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(Icons.video_library, color: scheme.primary),
        trailing: ElevatedButton.icon(
          onPressed: _isWatching ? null : _watchAd,
          icon: _isWatching
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.onPrimary,
                  ),
                )
              : Icon(Icons.play_circle_outline, color: scheme.onPrimary),
          label: Text(
            '+$kRewardedAdGold',
            style: TextStyle(color: scheme.onPrimary),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: scheme.primary,
          ),
        ),
      ),
    );
  }
}
