import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/widgets/custom_grid.dart';

import '../../core/auth/current_user.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/mystic_dimens.dart';
import '../../core/theme/mystic_tokens.dart';
import '../../core/widgets/section_header.dart';
import 'model/home_items.dart';
import 'widgets/build_stream_builder.dart';
import 'widgets/fortune_card.dart';
import 'widgets/sign_up_prompt_banner.dart';

// Anasayfa — son fal balonu + selamlama + mistik fal kategori listesi.
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(
      currentUserProvider.select((value) => value.value?.name),
    );
    final navigator = ref.read(appNavigatorProvider);

    const items = HomeItemModel.homeItems;
    final featured = items.where((i) => i.feature).toList();
    final rest = items.where((i) => !i.feature).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            MysticSpace.x5,
            MysticSpace.x4,
            MysticSpace.x5,
            MysticSpace.x6,
          ),
          children: [
            const SignUpPromptBanner(),
            const BuildStreamBuilder(),
            _Greeting(name: userName),
            const SizedBox(height: MysticSpace.x5),
            for (final item in featured) ...[
              SizedBox(
                height: 168,
                child: FortuneCard(
                  item: item,
                  featured: true,
                  onTap: () => navigator.pushToPage(item.route),
                ),
              ),
              const SizedBox(height: MysticSpace.x5),
            ],
            const SectionHeader('Kehanet Kapıları'),
            const SizedBox(height: MysticSpace.x4),
            CustomGrid(
              itemCount: rest.length,
              itemBuilder: (context, index) {
                final item = rest[index];
                return FortuneCard(
                  item: item,
                  onTap: () => navigator.pushToPage(item.route),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// İki satırlı selamlama: italik "İyi akşamlar," + Cormorant isim.
class _Greeting extends StatelessWidget {
  const _Greeting({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İyi akşamlar,',
          style: text.titleMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: tokens.inkSoft,
          ),
        ),
        Text(
          name?.isNotEmpty == true ? name! : 'Hoş geldin',
          style: text.titleLarge?.copyWith(fontSize: 28),
        ),
      ],
    );
  }
}
