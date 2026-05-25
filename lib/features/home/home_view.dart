import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/custom_grid.dart';

import '../../core/models/current_user.dart';
import '../../core/navigation/app_navigator_manager.dart';
import 'model/home_items.dart';
import 'widgets/build_stream_builder.dart';

// Anasayfa — son fal balonu + fal kategori grid'i.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(
      currentUserProvider.select((value) => value.value?.name),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BuildStreamBuilder(),
            Text(
              'İyi günler, ${userName ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: CustomGrid(
                itemCount: HomeItemModel.homeItems.length,
                itemBuilder: (context, index) {
                  final item = HomeItemModel.homeItems[index];
                  return InkWell(
                    onTap: () =>
                        AppNavigatorManager.instance.pushToPage(item.route),
                    child: item.tile,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
