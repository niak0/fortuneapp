import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/features/profile_edit/profile_edit_view_model.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/loading_dialog.dart';
import '../../core/widgets/snackbar.dart';
import '../../enums/gender_options.dart';
import '../../enums/relationship_status.dart';
import '../../enums/work_status.dart';
import '../../enums/zodiac_sign.dart';

// Kullanıcının profil bilgilerini düzenleyip kaydettiği ekran.
class ProfileEditView extends ConsumerWidget {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileEditViewModelProvider);
    final notifier = ref.read(profileEditViewModelProvider.notifier);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final nameController = TextEditingController(text: user.name);
    final genderController = TextEditingController(text: user.gender);
    final birthDateController = TextEditingController(
        text: DateFormat('dd.MM.yyyy').format(user.birthDate));
    final birthTimeController = TextEditingController(
        text: DateFormat('HH:mm').format(user.birthDate));
    final zodiacController = TextEditingController(
      text: ZodiacSign.values
          .firstWhere(
            (z) => z.name == user.zodiacSign,
            orElse: () => ZodiacSign.aries,
          )
          .turkishName,
    );
    final workStateController = TextEditingController(
      text: WorkStatus.values
          .firstWhere(
            (w) => w.name == user.workState,
            orElse: () => WorkStatus.student,
          )
          .turkishName,
    );
    final relationShipStateController = TextEditingController(
      text: RelationshipStatus.values
          .firstWhere(
            (r) => r.name == user.relationShipState,
            orElse: () => RelationshipStatus.single,
          )
          .turkishName,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Profili Düzenle')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
                onChanged: (value) => notifier.updateUser(name: value),
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(
                  labelText: 'Cinsiyet',
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                readOnly: true,
                onTap: () => _showBottomPicker<GenderOption>(
                  context,
                  values: GenderOption.values,
                  displayText: (g) => g.displayName,
                  onSelected: (v) => notifier.updateUser(gender: v.displayName),
                ),
              ),
              TextField(
                controller: birthDateController,
                decoration: const InputDecoration(
                  labelText: 'Doğum Tarihi',
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  notifier.updateUser(birthDate: pickedDate);
                },
              ),
              TextField(
                controller: birthTimeController,
                decoration: const InputDecoration(
                  labelText: 'Doğum Saati',
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                readOnly: true,
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final finalDateTime = DateTime(
                      user.birthDate.year,
                      user.birthDate.month,
                      user.birthDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    notifier.updateUser(birthDate: finalDateTime);
                  }
                },
              ),
              TextField(
                controller: zodiacController,
                decoration: const InputDecoration(
                  labelText: 'Burcun',
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                readOnly: true,
                onTap: () => _showBottomPicker<ZodiacSign>(
                  context,
                  values: ZodiacSign.values,
                  displayText: (z) => z.turkishName,
                  onSelected: (v) => notifier.updateUser(zodiacSign: v.name),
                ),
              ),
              TextField(
                controller: workStateController,
                decoration: const InputDecoration(
                  labelText: 'Meslek',
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                readOnly: true,
                onTap: () => _showBottomPicker<WorkStatus>(
                  context,
                  values: WorkStatus.values,
                  displayText: (s) => s.turkishName,
                  onSelected: (v) => notifier.updateUser(workState: v.name),
                ),
              ),
              TextField(
                controller: relationShipStateController,
                decoration: const InputDecoration(
                  labelText: 'İlişki Durumu',
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                ),
                readOnly: true,
                onTap: () => _showBottomPicker<RelationshipStatus>(
                  context,
                  values: RelationshipStatus.values,
                  displayText: (s) => s.turkishName,
                  onSelected: (v) =>
                      notifier.updateUser(relationShipState: v.name),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  LoadingDialog.show(context);
                  await notifier.saveUserChanges();
                  if (context.mounted) LoadingDialog.hide(context);
                  CustomSnackBar.show('Profil Güncellendi');
                  AppNavigatorManager.instance.pop();
                },
                child: const Text('Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Aşağıdan açılan picker menüsü.
  void _showBottomPicker<T>(
    BuildContext context, {
    required List<T> values,
    required String Function(T) displayText,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
