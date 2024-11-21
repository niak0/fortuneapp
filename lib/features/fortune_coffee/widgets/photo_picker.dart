import 'dart:io';

import 'package:flutter/material.dart';

class PhotoPicker extends StatelessWidget {
  final String photo;
  final VoidCallback onPhotoTap;
  final VoidCallback onDeleteTap;
  const PhotoPicker({super.key,
    required this.onPhotoTap,
    required this.onDeleteTap,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: photo.isEmpty ? onPhotoTap : null,
            child: Container(
              width: screenWidth * 0.25,
              height: screenHeight * 0.1,
              decoration: BoxDecoration(
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  color: Theme.of(context).colorScheme.secondaryContainer),
              child: photo.isEmpty
                  ? Icon(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                Icons.add_a_photo_outlined,
                size: screenWidth * 0.15,
              )
                  : Image.file(File(photo), fit: BoxFit.fill),
            ),
          ),
        ),
        if (photo.isNotEmpty)
          Positioned(
              right: 5,
              top: 0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size(screenWidth * 0.06, screenWidth * 0.06),
                  ),
                  onPressed: onDeleteTap,
                  child: const Icon(Icons.clear_outlined))),
      ],
    );
  }
}
