import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/features/numerology/helpers/numerology_items.dart';
import 'package:fortuneapp/features/numerology/numerology_view_model.dart';
import 'package:provider/provider.dart';

import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';

class NumerologyView extends StatelessWidget {
  const NumerologyView({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<CurrentUser>(context, listen: true).currentUser!;
    return ChangeNotifierProvider<NumerologyViewModel>(
        create: (context) => NumerologyViewModel(currentUser.name, DateTime(1999, 01, 11))..calculate(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Numeroloji"),
          ),
          body: Consumer<NumerologyViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  buildInfoListTile(currentUser),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    child: const ListTile(
                      dense: true,
                      title: Text("Detaylı yorum için bir ögeyi veya kategoriyi seçin."),
                      trailing: Icon(Icons.info_outlined),
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    BirthDateCalculations.values,
                    viewModel,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildCategoryCard(context, NameCalculations.values, viewModel),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildCategoryCard(
                    context,
                    TimeCycles.values,
                    viewModel,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
              );
            },
          ),
        ));
  }

  ListTile buildInfoListTile(UserModel currentUser) {
    return ListTile(
      onTap: () {
        AppNavigatorManager.instance.pushToPage(AppRoutes.profileEdit);
      },
      dense: true,
      title: const Text("Lütfen tam adınızı girin"),
      subtitle: Text(
        "${currentUser.name}, ${currentUser.birthDate} ",
      ),
      trailing: const Icon(Icons.edit_outlined),
      leading: const Icon(Icons.person),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    List<NumerologyItem> items,
    NumerologyViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final title = items.first.title;
    final color = items.first.color;
    final icon = items.first.icon;

    Map<NumerologyItem, int> values = {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: color,
          child: ListTile(
              onTap: () {
                AppNavigatorManager.instance.pushToPage(AppRoutes.numerologyDetail, arguments: {
                  "selectedItem": items.first,
                  "values": values,
                });
              },
              dense: true,
              title: Text(
                title,
                style: theme.textTheme.titleSmall,
              ),
              trailing: const Icon(Icons.chevron_right_outlined)),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
                margin: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    AppNavigatorManager.instance.pushToPage(AppRoutes.numerologyDetail, arguments: {
                      "selectedItem": items.first,
                      "values": values,
                    });
                  },
                  child: Icon(
                    icon,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: List.generate(
                    items.length,
                    (index) {
                      var item = items[index];
                      int value = viewModel.getValue(item);
                      values[item] = value;
                      return Card(
                        color: color,
                        child: ListTile(
                          dense: true,
                          title: Text(item.displayName),
                          trailing: Text(value.toString()),
                          onTap: () {
                            if (kDebugMode) {
                              print("${item.displayName} = $value");
                            }
                            if (kDebugMode) {
                              print("$values");
                            }

                            AppNavigatorManager.instance.pushToPage(AppRoutes.numerologyDetail, arguments: {
                              "selectedItem": item,
                              "categoryItems": items,
                              "value": value,
                              "values": values,
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
