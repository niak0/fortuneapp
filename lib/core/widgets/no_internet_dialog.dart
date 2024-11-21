import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      backgroundColor: Colors.transparent,
      child: AlertDialog(
        title: Text("Bağlantı Yok"),
        content: Text("Lütfen internet bağlantınızı kontrol ediniz"),
      ),
    );
  }
}