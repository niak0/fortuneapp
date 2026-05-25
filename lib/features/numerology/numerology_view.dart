import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/features/numerology/helpers/numerology_items.dart';
import 'package:fortuneapp/features/numerology/numerology_view_model.dart';

import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';

// Kullanıcının numeroloji değerlerini gösteren ekran.
class NumerologyView extends ConsumerWidget {
  const NumerologyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    return currentUserAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Hata: $e'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Kullanıcı yok')));
        }
        final viewModel = NumerologyViewModel(user.name, DateTime(1999, 01, 11))
          ..calculate();
        return Scaffold(
          appBar: AppBar(title: const Text('Numeroloji')),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                buildInfoListTile(user),
                const SizedBox(height: 20),
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: const ListTile(
                    dense: true,
                    title: Text('Detaylı yorum için bir ögeyi veya kategoriyi seçin.'),
                    trailing: Icon(Icons.info_outlined),
                  ),
                ),
                _buildCategoryCard(context, BirthDateCalculations.values, viewModel),
                const SizedBox(height: 20),
                _buildCategoryCard(context, NameCalculations.values, viewModel),
                const SizedBox(height: 20),
                _buildCategoryCard(context, TimeCycles.values, viewModel),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Kullanıcı bilgi satırı (profil editine yönlendirir).
  ListTile buildInfoListTile(UserModel currentUser) {
    return ListTile(
      onTap: () =>
          AppNavigatorManager.instance.pushToPage(AppRoutes.profileEdit),
      dense: true,
      title: const Text('Lütfen tam adınızı girin'),
      subtitle: Text('${currentUser.name}, ${currentUser.birthDate} '),
      trailing: const Icon(Icons.edit_outlined),
      leading: const Icon(Icons.person),
    );
  }

  // Bir numeroloji kategorisini kart olarak çizer.
  Widget _buildCategoryCard(
    BuildContext context,
    List<NumerologyItem> items,
    NumerologyViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final title = items.first.title;
    final color = items.first.color;
    final icon = items.first.icon;

    final Map<NumerologyItem, int> values = {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: color,
          child: ListTile(
            onTap: () => AppNavigatorManager.instance
                .pushToPage(AppRoutes.numerologyDetail, arguments: {
              'selectedItem': items.first,
              'values': values,
            }),
            dense: true,
            title: Text(title, style: theme.textTheme.titleSmall),
            trailing: const Icon(Icons.chevron_right_outlined),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                ),
                margin: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () => AppNavigatorManager.instance
                      .pushToPage(AppRoutes.numerologyDetail, arguments: {
                    'selectedItem': items.first,
                    'values': values,
                  }),
                  child: Icon(icon, size: 120, color: Colors.white),
                ),
              ),
              Expanded(
                child: Column(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final value = viewModel.getValue(item);
                    values[item] = value;
                    return Card(
                      color: color,
                      child: ListTile(
                        dense: true,
                        title: Text(item.displayName),
                        trailing: Text(value.toString()),
                        onTap: () {
                          if (kDebugMode) {
                            print('${item.displayName} = $value');
                            print('$values');
                          }
                          AppNavigatorManager.instance.pushToPage(
                            AppRoutes.numerologyDetail,
                            arguments: {
                              'selectedItem': item,
                              'categoryItems': items,
                              'value': value,
                              'values': values,
                            },
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
