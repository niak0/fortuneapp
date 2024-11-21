import 'package:flutter/material.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import 'package:fortuneapp/core/widgets/shimmer.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/features/buy_gold/widgets/ad_card.dart';
import 'package:fortuneapp/features/buy_gold/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/custom_grid.dart';
import '../../core/utils/gold_manager.dart';
import 'buy_gold_view_model.dart';

class BuyGoldView extends StatefulWidget {
  const BuyGoldView({super.key});

  @override
  State<BuyGoldView> createState() => _BuyGoldViewState();
}

class _BuyGoldViewState extends State<BuyGoldView> {
  @override
  Widget build(BuildContext context) {
    final goldManager = Provider.of<GoldManager>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => BuyGoldViewModel(goldManager)..initializeRevenueCat(),
      child: Consumer<BuyGoldViewModel>(builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: const Text("Altın Marketi")),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer(
              isLoading: viewModel.isLoading,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const AdCard(),
                  const SizedBox(height: 16),
                  Flexible(
                    child: CustomGrid(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final package = "";
                        return GestureDetector(
                          onTap: () async {
                            LoadingDialog.show(context);
                            final result = await viewModel.buyPackage(package);

                            if (context.mounted) {
                              LoadingDialog.hide(context);
                            }
                            (result) ? CustomSnackBar.show("Hesabınıza altınlar yüklendi") : CustomSnackBar.show("Satın alma başarısız");
                          },
                          child: ProductCard(
                            title: "package.storeProduct.title",
                            price: "package.storeProduct.priceString",
                            description: "package.storeProduct.description",
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
      }),
    );
  }
}
