import 'package:flutter/material.dart';
import 'package:fortuneapp/core/widgets/custom_button.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';

import '../../core/navigation/app_navigator_manager.dart';
import '../../core/widgets/snackbar.dart';
import '../../generated/assets.dart';

class FortuneDreamView extends StatelessWidget {
  const FortuneDreamView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rüya Tabiri"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: 300,
                child: Image.asset(
                  Assets.iconImageDream,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 20),
              Text("Gördüğün rüyanın sana ne anlatmak istediğini merak ediyor musun?",
                  style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                autofocus: false,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "Gördüğünüz rüyayı tüm ayrıntılarıyla birlikte gördüklerinizi, hissettiklerinizi ve gördüklerinizin fiziksel "
                      "özelliklerini açıklayınız",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "Rüyayı Yorumla",
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      String message = "Türkçe olarak bu rüyayı yorumla : ${controller.text}";
                      LoadingDialog.show(context);

                      if (context.mounted) {
                        LoadingDialog.hide(context);
                      }
                      AppNavigatorManager.instance.pop();
                    } else {
                      if (context.mounted) {
                        CustomSnackBar.show("Lütfen tüm görüntüleri ve açıklamaları giriniz");
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
