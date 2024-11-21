import 'package:flutter/material.dart';

class GoldOptionDialog extends StatelessWidget {
  const GoldOptionDialog({
    super.key,
    required this.onWatchAd,
    required this.onBuyGold,
  });

  final VoidCallback onWatchAd;
  final VoidCallback onBuyGold;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onWatchAd,
    required VoidCallback onBuyGold,
  }) {
    return showDialog(
      context: context,
      builder: (context) => GoldOptionDialog(
        onBuyGold: onBuyGold,
        onWatchAd: onWatchAd,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Yetersiz Altın"),
      content: const Text("Devam etmek için altın gerekiyor. Altın satın al veya reklam izle."),
      actions: <Widget>[
        TextButton(
          onPressed: onWatchAd,
          child: const Text("Reklam İzle"),
        ),
        TextButton(
          onPressed: onBuyGold,
          child: const Text("Altın Satın Al"),
        ),
      ],
    );
  }
}
