import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/features/profile_edit/profile_edit_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/loading_dialog.dart';
import '../../core/widgets/snackbar.dart';
import '../../enums/gender_options.dart';
import '../../enums/relationship_status.dart';
import '../../enums/work_status.dart';
import '../../enums/zodiac_sign.dart';
import '../../core/models/current_user.dart';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<CurrentUser>();

    return ChangeNotifierProvider(
      create: (context) => ProfileEditViewModel(currentUser),
      child: Scaffold(
        appBar: AppBar(title: const Text("Profili Düzenle")),
        body: Consumer<ProfileEditViewModel>(
          builder: (context, viewModel, child) {
            final nameController = TextEditingController(text: viewModel.user.name);
            final genderController = TextEditingController(text: viewModel.user.gender);
            final birthDateController = TextEditingController(text: DateFormat('dd.MM.yyyy').format(viewModel.user.birthDate));
            final birthTimeController = TextEditingController(text: DateFormat('HH:mm').format(viewModel.user.birthDate));
            // final locationController = TextEditingController(text: viewModel.user.location);
            final zodiacController = TextEditingController(
              text: ZodiacSign.values
                  .firstWhere(
                    (z) => z.name == viewModel.user.zodiacSign,
                    orElse: () => ZodiacSign.aries,
                  )
                  .turkishName,
            );
            final workStateController = TextEditingController(
              text: WorkStatus.values
                  .firstWhere(
                    (w) => w.name == viewModel.user.workState,
                    orElse: () => WorkStatus.student,
                  )
                  .turkishName,
            );
            final relationShipStateController = TextEditingController(
              text: RelationshipStatus.values
                  .firstWhere(
                    (r) => r.name == viewModel.user.relationShipState,
                    orElse: () => RelationshipStatus.single,
                  )
                  .turkishName,
            );

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Ad'),
                      onChanged: (value) {
                        viewModel.updateUser(name: value);
                      },
                    ),
                    TextField(
                      controller: genderController,
                      decoration: const InputDecoration(labelText: 'Cinsiyet', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                      readOnly: true,
                      onTap: () {
                        _showBottomPicker<GenderOption>(context,
                            values: GenderOption.values,
                            displayText: (gender) => gender.displayName,
                            onSelected: (value) {
                              viewModel.updateUser(gender: value.displayName);
                            });
                      },
                    ),
                    TextField(
                      controller: birthDateController,
                      decoration: const InputDecoration(labelText: 'Doğum Tarihi', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          viewModel.updateUser(birthDate: pickedDate);
                        }
                      },
                    ),
                    TextField(
                      controller: birthTimeController,
                      decoration: const InputDecoration(labelText: 'Doğum Saati', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          DateTime finalDateTime = DateTime(
                            viewModel.user.birthDate.year,
                            viewModel.user.birthDate.month,
                            viewModel.user.birthDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          viewModel.updateUser(birthDate: finalDateTime);
                        }
                      },
                    ),
                    // TextField(
                    //   controller: locationController,
                    //   decoration: const InputDecoration(labelText: 'Doğum Yeri', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                    //   readOnly: true,
                    //   onTap: () {},
                    // ),
                    TextField(
                      controller: zodiacController,
                      decoration: const InputDecoration(labelText: 'Burcun', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                      readOnly: true,
                      onTap: () {
                        _showBottomPicker<ZodiacSign>(context,
                            values: ZodiacSign.values,
                            displayText: (zodiac) => zodiac.turkishName,
                            onSelected: (value) {
                              viewModel.updateUser(zodiacSign: value.name);
                            });
                      },
                    ),
                    TextField(
                      controller: workStateController,
                      decoration: const InputDecoration(labelText: 'Meslek', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                      readOnly: true,
                      onTap: () {
                        _showBottomPicker<WorkStatus>(context,
                            values: WorkStatus.values,
                            displayText: (status) => status.turkishName,
                            onSelected: (value) {
                              viewModel.updateUser(workState: value.name);
                            });
                      },
                    ),
                    TextField(
                      controller: relationShipStateController,
                      decoration: const InputDecoration(labelText: 'İlişki Durumu', suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
                      readOnly: true,
                      onTap: () {
                        _showBottomPicker<RelationshipStatus>(context,
                            values: RelationshipStatus.values,
                            displayText: (status) => status.turkishName,
                            onSelected: (value) {
                              viewModel.updateUser(relationShipState: value.name);
                            });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        LoadingDialog.show(context);
                        await viewModel.saveUserChanges();
                        if (context.mounted) {
                          LoadingDialog.hide(context);
                        }
                        CustomSnackBar.show("Profil Güncellendi");
                        AppNavigatorManager.instance.pop();
                      },
                      child: const Text('Güncelle'),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBottomPicker<T>(
    BuildContext context, {
    required List<T> values,
    required String Function(T) displayText,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: ListView(
            children: values.map((value) {
              return ListTile(
                title: Center(child: Text(displayText(value))),
                onTap: () {
                  onSelected(value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
