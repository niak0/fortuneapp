import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/core/network/mock_firebase_service.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import '../../core/models/fortune_model.dart';
import 'font_size_slider.dart';

class ReadFortuneView extends StatefulWidget {
  const ReadFortuneView({super.key, required this.currentContent});

  final ContentModel currentContent;

  @override
  State<ReadFortuneView> createState() => _ReadFortuneViewState();
}

class _ReadFortuneViewState extends State<ReadFortuneView> {
  double _fontSize = 18.0; // Varsayılan yazı boyutu

  void _showFontSizeSlider() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FontSizeSlider(
          fontSize: _fontSize,
          onFontSizeChanged: (newSize) {
            setState(() {
              _fontSize = newSize;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: _appBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.currentContent.fortuneType!} - ${widget.currentContent.fortuneTopic ?? ""}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(widget.currentContent.formattedDate, style: const TextStyle(fontSize: 20.0, color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.currentContent.fortune != null
                          ? SelectableText(
                              widget.currentContent.fortune!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: _fontSize),
                              textAlign: TextAlign.left,
                            )
                          : const Text(
                              'Falınız yüklenemedi.',
                              style: TextStyle(fontSize: 16.0, color: Colors.red),
                            ),
                      Container(
                        width: MediaQuery.of(context).size.width * 10,
                        height: 150,
                        color: Colors.brown,
                        child: const Center(child: Text("REKLAM")),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () async {
              _showFontSizeSlider();
            },
            icon: const Icon(Icons.format_size_outlined)),
        IconButton(
          onPressed: () async {
            _showDeleteDialog(context, () async {
              AppNavigatorManager.instance.pop();
              await MockFirebaseService().deleteFortune(widget.currentContent.id!);
              if (context.mounted) LoadingDialog.hide(context);
              AppNavigatorManager.instance.pop();
            });
          },
          icon: const Icon(Icons.delete_forever_outlined),
        ),
      ],
    );
  }
}

void _showDeleteDialog(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sil"),
        content: const Text("Silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () {
              AppNavigatorManager.instance.pop();
            },
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              onDelete();
            },
            child: const Text("Sil"),
          ),
        ],
      );
    },
  );
}
