import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import 'package:fortuneapp/core/widgets/shimmer.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/features/buy_gold/widgets/ad_card.dart';
import 'package:fortuneapp/features/buy_gold/widgets/product_card.dart';

import '../../core/widgets/custom_grid.dart';
import 'buy_gold_view_model.dart';

// Altın satın alma ekranı.
class BuyGoldView extends ConsumerWidget {
  const BuyGoldView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(buyGoldViewModelProvider);
    final notifier = ref.read(buyGoldViewModelProvider.notifier);
    final isLoading = asyncState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Altın Marketi')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Shimmer(
          isLoading: isLoading,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const AdCard(),
              const SizedBox(height: 16),
              Flexible(
                child: CustomGrid(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        LoadingDialog.show(context);
                        final result = await notifier.buyPackage('');
                        if (context.mounted) LoadingDialog.hide(context);
                        CustomSnackBar.show(
                          result
                              ? 'Hesabınıza altınlar yüklendi'
                              : 'Satın alma başarısız',
                        );
                      },
                      child: const ProductCard(
                        title: 'package.storeProduct.title',
                        price: 'package.storeProduct.priceString',
                        description: 'package.storeProduct.description',
                        icon: Icons.attach_money,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
