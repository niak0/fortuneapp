import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/data/fortune_repository.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import '../../core/models/fortune_model.dart';
import '../../enums/gpt_content_type.dart';
import 'font_size_slider.dart';

class ReadFortuneView extends ConsumerStatefulWidget {
  const ReadFortuneView({super.key, required this.currentContent});

  final FortuneModel currentContent;

  @override
  ConsumerState<ReadFortuneView> createState() => _ReadFortuneViewState();
}

class _ReadFortuneViewState extends ConsumerState<ReadFortuneView> {
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
                "${widget.currentContent.fortuneType?.displayName ?? ""}"
                "${widget.currentContent.fortuneTopic != null ? " - ${widget.currentContent.fortuneTopic!.displayName}" : ""}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                widget.currentContent.formattedDate,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.currentContent.fortune != null
                          ? SelectableText(
                              widget.currentContent.fortune!,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontSize: _fontSize,
                                  ),
                              textAlign: TextAlign.left,
                            )
                          : Text(
                              'Falınız yüklenemedi.',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "REKLAM",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
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
          icon: const Icon(Icons.format_size_outlined),
        ),
        IconButton(
          onPressed: () async {
            _showDeleteDialog(context, () async {
              Navigator.of(context).pop();
              await ref
                  .read(fortuneRepositoryProvider)
                  .delete(widget.currentContent.id!);
              if (context.mounted) LoadingDialog.hide(context);
              ref.read(appNavigatorProvider).pop();
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
              Navigator.of(context).pop();
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
