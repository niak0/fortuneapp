import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FortuneHandView extends StatefulWidget {
  const FortuneHandView({super.key});

  @override
  State<FortuneHandView> createState() => _FortuneHandViewState();
}

class _FortuneHandViewState extends State<FortuneHandView> {
  XFile? _image;
  late ImagePicker picker;

  Future<void> openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    picker = ImagePicker();
    openCamera();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("El Falı"),
      ),
      body: Center(
          child: _image == null ? const SizedBox() : Image.file(File(_image!.path), fit: BoxFit.fill)
      ),
    );
  }
}