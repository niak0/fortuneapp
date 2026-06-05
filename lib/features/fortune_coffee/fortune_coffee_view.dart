import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/enums/fortune_topic.dart';
import 'package:fortuneapp/enums/gender_options.dart';
import 'package:fortuneapp/enums/relationship_status.dart';
import 'package:fortuneapp/enums/work_status.dart';

import '../../core/auth/current_user.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/mystic_dimens.dart';
import '../../core/theme/mystic_tokens.dart';
import '../../core/utilities/gold_manager.dart';
import '../../core/widgets/custom_grid.dart';
import '../../core/widgets/mystic_button.dart';
import '../../core/widgets/mystic_reveal.dart';
import '../../core/widgets/section_header.dart';
import 'fortune_coffee_providers.dart';
import 'widgets/fortune_topic_card.dart';
import 'widgets/photo_picker.dart';

// Kahve falı için fotoğraf ve fal konusu seçilen mistik ekran.
class FortuneCoffeeView extends ConsumerWidget {
  const FortuneCoffeeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final state = ref.watch(fortuneCoffeeViewModelProvider);
    final notifier = ref.read(fortuneCoffeeViewModelProvider.notifier);
    final tokens = MysticTokens.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kahve Falı')),
      body: currentUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(child: Text('Kullanıcı yok'));
          }
          // Üstten gelen hafif halo atmosferi + içerik.
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 280,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1,
                      colors: [tokens.halo, Colors.transparent],
                      stops: const [0, 0.7],
                    ),
                  ),
                ),
              ),
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  MysticSpace.x5,
                  MysticSpace.x4,
                  MysticSpace.x5,
                  MysticSpace.x6,
                ),
                children: [
                  const MysticReveal(child: _HeroIntro()),
                  const SizedBox(height: MysticSpace.x6),
                  const MysticReveal(
                    delay: Duration(milliseconds: 60),
                    child: SectionHeader('Fotoğraflar'),
                  ),
                  const SizedBox(height: MysticSpace.x4),
                  MysticReveal(
                    delay: const Duration(milliseconds: 60),
                    child: _PhotoPickerRow(
                      photos: state.photos,
                      notifier: notifier,
                    ),
                  ),
                  const SizedBox(height: MysticSpace.x6),
                  MysticReveal(
                    delay: const Duration(milliseconds: 120),
                    child: _ProfileSummaryTile(
                      user: currentUser,
                      onEdit: () => ref
                          .read(appNavigatorProvider)
                          .pushToPage(AppRoutes.profileEdit),
                    ),
                  ),
                  const SizedBox(height: MysticSpace.x6),
                  const MysticReveal(
                    delay: Duration(milliseconds: 180),
                    child: SectionHeader('Fal Konusu'),
                  ),
                  const SizedBox(height: MysticSpace.x4),
                  MysticReveal(
                    delay: const Duration(milliseconds: 180),
                    child: _TopicGrid(
                      selected: state.selectedFortuneTopic,
                      notifier: notifier,
                    ),
                  ),
                  const SizedBox(height: MysticSpace.x6),
                  MysticReveal(
                    delay: const Duration(milliseconds: 240),
                    child: MysticButton(
                      text: 'Yorumla',
                      icon: Icons.auto_awesome,
                      cost: kFortuneCost,
                      enabled: state.isValid,
                      onPressed: () => _interpret(context, ref, currentUser),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // Yorumlama akışı: validasyon → loading → GPT/kaydet → başarıda kapat.
  Future<void> _interpret(
    BuildContext context,
    WidgetRef ref,
    UserModel currentUser,
  ) async {
    final notifier = ref.read(fortuneCoffeeViewModelProvider.notifier);
    if (!notifier.handleFortuneCreation()) {
      CustomSnackBar.show(
        'Lütfen tüm fotoğrafları seçin ve bir konu belirleyin.',
      );
      return;
    }
    LoadingDialog.show(context);
    final ok = await notifier.getFortuneAndSaveFirebase(currentUser);
    if (context.mounted) LoadingDialog.hide(context);
    if (ok) ref.read(appNavigatorProvider).pop();
  }
}

// Ekranın üstündeki mistik tanıtım kartı (parlayan fincan + başlık).
class _HeroIntro extends StatelessWidget {
  const _HeroIntro();

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(MysticSpace.x5),
      decoration: BoxDecoration(
        gradient: tokens.heroGradient,
        borderRadius: MysticRadius.lgAll,
        border: Border.all(color: tokens.lineStrong),
      ),
      child: Row(
        children: [
          // Parlayan halkalı fincan.
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: tokens.lineStrong),
              boxShadow: [
                BoxShadow(color: tokens.halo, blurRadius: 24, spreadRadius: -6),
              ],
            ),
            child: Icon(
              Icons.coffee_rounded,
              color: tokens.goldBright,
              size: 30,
            ),
          ),
          const SizedBox(width: MysticSpace.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fincanını oku', style: text.titleLarge),
                const SizedBox(height: 2),
                Text(
                  'Telvenin sırrını ortaya çıkar',
                  style: text.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: tokens.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.auto_awesome, color: scheme.primary, size: 18),
        ],
      ),
    );
  }
}

// 3 slotlu premium fotoğraf seçici satırı.
class _PhotoPickerRow extends StatelessWidget {
  const _PhotoPickerRow({required this.photos, required this.notifier});

  final List<String> photos;
  final FortuneCoffeeViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(photos.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < photos.length - 1 ? MysticSpace.x3 : 0,
            ),
            child: PhotoPicker(
              onPhotoTap: () => notifier.pickPhoto(index),
              onDeleteTap: () => notifier.deletePhoto(index),
              photo: photos[index],
            ),
          ),
        );
      }),
    );
  }
}

// Kullanıcı demografik özeti — dokununca profil düzenlemeye gider.
class _ProfileSummaryTile extends StatelessWidget {
  const _ProfileSummaryTile({required this.user, required this.onEdit});

  final UserModel user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final text = Theme.of(context).textTheme;

    final gender = GenderOption.values
        .where((g) => g.name == user.gender)
        .firstOrNull
        ?.displayName;
    final work = WorkStatus.values
        .where((w) => w.name == user.workState)
        .firstOrNull
        ?.turkishName;
    final relationship = RelationshipStatus.values
        .where((r) => r.name == user.relationshipState)
        .firstOrNull
        ?.turkishName;
    final summary = [
      ?gender,
      '${user.age ?? "?"}',
      ?work,
      ?relationship,
    ].join(' · ');

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: MysticRadius.mdAll,
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.all(MysticSpace.x4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: MysticRadius.mdAll,
            border: Border.all(color: tokens.line),
          ),
          child: Row(
            children: [
              Icon(Icons.person_outline, color: tokens.gold, size: 22),
              const SizedBox(width: MysticSpace.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profil bilgilerin', style: text.labelSmall),
                    Text(
                      summary,
                      style: text.bodyMedium?.copyWith(color: tokens.inkSoft),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit_outlined, color: tokens.inkFaint, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// Fal konusu grid'i.
class _TopicGrid extends StatelessWidget {
  const _TopicGrid({required this.selected, required this.notifier});

  final FortuneTopic? selected;
  final FortuneCoffeeViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return CustomGrid(
      itemCount: FortuneTopic.values.length,
      itemBuilder: (context, index) {
        final topic = FortuneTopic.values[index];
        return GestureDetector(
          onTap: () => notifier.selectFortuneTopic(topic),
          child: FortuneTopicCard(
            selectedFortuneTopic: selected,
            fortuneTopicOption: topic,
          ),
        );
      },
    );
  }
}
