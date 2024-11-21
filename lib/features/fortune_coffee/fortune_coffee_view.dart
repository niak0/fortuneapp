import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/core/widgets/loading_dialog.dart';
import 'package:fortuneapp/core/widgets/snackbar.dart';
import 'package:fortuneapp/enums/relationship_status.dart';
import 'package:fortuneapp/enums/work_status.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/models/current_user.dart';
import 'fortune_coffee_view_mixin.dart';
import 'fortune_coffee_view_model.dart';

class FortuneCoffeeView extends StatefulWidget {
  const FortuneCoffeeView({super.key});

  @override
  State<FortuneCoffeeView> createState() => _FortuneCoffeeViewState();
}

class _FortuneCoffeeViewState extends State<FortuneCoffeeView> with FortuneCoffeeViewMixin {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser>(context, listen: true).currentUser!;

    userInfoController.text = ""
        "${currentUser.gender}, "
        "${currentUser.age}, "
        "${WorkStatus.values.firstWhere((w) => w.name == currentUser.workState).turkishName}, "
        "${RelationshipStatus.values.firstWhere((r) => r.name == currentUser.relationShipState).turkishName}";

    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider(
        create: (context) => FortuneCoffeeViewModel(),
        child: Consumer<FortuneCoffeeViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleMessage(context, chosePhotoText),
                    buildPhotoPicker(),
                    const SizedBox(height: 10),
                    buildUserIntoTextField(() => AppNavigatorManager.instance.pushToPage(AppRoutes.profileEdit)),
                    const SizedBox(height: 10),
                    titleMessage(context, choseFortuneContentText),
                    buildCustomGrid(),
                    CustomButton(
                      text: buttonText,
                      onPressed: () async {
                        if (!viewModel.handleFortuneCreation()) return CustomSnackBar.show(snackbarText);
                        LoadingDialog.show(context);
                        await viewModel.getFortuneAndSaveFirebase(currentUser);
                        if (context.mounted) {
                          LoadingDialog.hide(context);
                        }
                        AppNavigatorManager.instance.pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
