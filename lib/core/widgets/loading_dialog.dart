import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});
   @override
   Widget build(BuildContext context) {
      return Dialog(
         backgroundColor: Colors.transparent,
         child: Center(
            child: Lottie.asset(
               "assets/animations/coffee.json",
               width: 300,
               height: 300,
            ),
         ),
      );
   }

  static void show(BuildContext context) {
      showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context) {
            return const LoadingDialog();
         },
      );
     }

  static void hide(BuildContext context) {
      Navigator.of(context, rootNavigator: true).pop();
     }
}
