import 'package:flutter/material.dart';
import 'package:fortuneapp/enums/gpt_content_type.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/loading_dialog.dart';
import '../../core/models/fortune_model.dart';
import 'my_fortunes_view_model.dart';
import '../../core/navigation/app_navigator_manager.dart';
import '../../core/navigation/app_navigator.dart';

class MyFortunesView extends StatelessWidget {
  const MyFortunesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyFortunesViewModel>(
      create: (context) => MyFortunesViewModel(),
      child: Scaffold(
        body: Builder(
          builder: (context) {
            final viewModel = Provider.of<MyFortunesViewModel>(context, listen: false);

            return StreamBuilder<List<ContentModel>>(
              stream: viewModel.fortunesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingDialog());
                }
                final fortunes = snapshot.data ?? [];

                if (fortunes.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz oluşturulmuş bir fal yok.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  );
                }

                return ListView.builder(
                  key: ValueKey(fortunes.length),
                  itemCount: fortunes.length,
                  itemBuilder: (context, index) {
                    final fortune = fortunes[index];
                    final isRead = fortune.isRead ?? false;
                    final isAccessible = fortune.isAccessible ?? false;
                    final type = fortune.fortuneType ?? 'unknown';

                    IconData getIconForType(String type) {
                      switch (type) {
                        case "coffee":
                          return ContentType.coffee.icon;
                        case "hand":
                          return ContentType.hand.icon;
                        case "tarot":
                          return ContentType.tarot.icon;
                        case "dream":
                          return ContentType.dream.icon;
                        case "astrology":
                          return Icons.stars;
                        default:
                          return Icons.help;
                      }
                    }

                    final icon = getIconForType(type);

                    return Card(
                      color: isRead ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                      child: ListTile(
                        leading: Icon(icon),
                        trailing: isAccessible ? const Icon(Icons.chevron_right_outlined) : const Icon(Icons.timelapse_outlined),
                        title: Row(
                          children: [
                            Text("${fortune.fortuneType} "),
                            if (fortune.fortuneTopic != null)
                              Chip(
                                padding: EdgeInsets.zero,
                                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                                label: Text(
                                  fortune.fortuneTopic!,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(isAccessible ? fortune.formattedDate : "${fortune.formattedDate} Yorumlanıyor..."),
                        onTap: isAccessible
                            ? () async {
                                if (!isRead) {
                                  await viewModel.markAsRead(fortune.id!);
                                }
                                AppNavigatorManager.instance.pushToPage(
                                  AppRoutes.readFortune,
                                  arguments: {
                                    'currentContent': fortune,
                                  },
                                );
                              }
                            : null,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
