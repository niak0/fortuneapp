import 'package:flutter/material.dart';
import 'package:fortuneapp/core/widgets/custom_grid.dart';
import 'package:provider/provider.dart';
import '../../core/navigation/app_navigator_manager.dart';
import '../../core/models/current_user.dart';
import 'home_view_mixin.dart';
import 'home_view_model.dart';
import 'model/home_items.dart';
import 'widgets/build_stream_builder.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeViewMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Padding _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<HomeViewModel>(
            builder: (context, viewModel, _) {
              return BuildStreamBuilder(viewModel: viewModel);
            },
          ),
          Selector<CurrentUser, String?>(
            selector: (context, currentUser) => currentUser.currentUser?.name,
            builder: (context, userName, _) {
              return Text(
                "İyi günler, $userName",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              );
            },
          ),
          const SizedBox(height: 5),
          Expanded(
            child: CustomGrid(
              itemCount: HomeItemModel.homeItems.length,
              itemBuilder: (context, index) {
                final item = HomeItemModel.homeItems[index];
                return InkWell(
                  onTap: () {
                    AppNavigatorManager.instance.pushToPage(item.route);
                  },
                  child: item.tile,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
