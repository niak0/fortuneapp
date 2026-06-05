import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/mystic_dimens.dart';
import '../../../core/theme/mystic_tokens.dart';

// Tek bir fincan fotoğrafı için premium (altın hairline) seçici slot.
class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
    required this.onPhotoTap,
    required this.onDeleteTap,
    required this.photo,
  });

  final String photo;
  final VoidCallback onPhotoTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final isEmpty = photo.isEmpty;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: MysticRadius.mdAll,
                onTap: isEmpty ? onPhotoTap : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: MysticRadius.mdAll,
                    border: Border.all(
                      color: isEmpty ? tokens.line : tokens.lineStrong,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: isEmpty
                      ? _EmptySlot(tokens: tokens)
                      : Image.file(File(photo), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          if (!isEmpty)
            Positioned(
              right: 6,
              top: 6,
              child: _DeleteBadge(onTap: onDeleteTap),
            ),
        ],
      ),
    );
  }
}

// Boş slot içeriği: altın ekleme ikonu + "Ekle" etiketi.
class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.tokens});

  final MysticTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 26, color: tokens.gold),
        const SizedBox(height: MysticSpace.x1),
        Text(
          'Ekle',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: tokens.inkFaint),
        ),
      ],
    );
  }
}

// Dolu slotun sağ-üstündeki sil rozeti.
class _DeleteBadge extends StatelessWidget {
  const _DeleteBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = MysticTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLowest.withValues(alpha: 0.7),
      shape: CircleBorder(side: BorderSide(color: tokens.lineStrong)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(Icons.close, size: 16, color: tokens.ink),
        ),
      ),
    );
  }
}
