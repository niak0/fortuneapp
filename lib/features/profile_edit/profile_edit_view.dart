import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:fortuneapp/features/profile_edit/profile_edit_providers.dart';
import 'package:intl/intl.dart';

import '../../core/models/user_model.dart';
import '../../core/widgets/loading_dialog.dart';
import '../../core/widgets/snackbar.dart';
import '../../enums/gender_options.dart';
import '../../enums/relationship_status.dart';
import '../../enums/work_status.dart';
import '../../enums/zodiac_sign.dart';

// Kullanıcının profil bilgilerini düzenleyip kaydettiği ekran.
class ProfileEditView extends ConsumerStatefulWidget {
  const ProfileEditView({super.key});

  @override
  ConsumerState<ProfileEditView> createState() => _ProfileEditViewState();
}

// Controller ömrünü yöneten ve geçici state'i picker'larla güncelleyen state.
class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthTimeController = TextEditingController();
  final _zodiacController = TextEditingController();
  final _workStateController = TextEditingController();
  final _relationShipController = TextEditingController();

  // Controller'lar bir kez kullanıcıyla dolduruldu mu.
  bool _seeded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _genderController.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    _zodiacController.dispose();
    _workStateController.dispose();
    _relationShipController.dispose();
    super.dispose();
  }

  // Kullanıcı ilk geldiğinde tüm alanları (ad dahil) doldurur.
  void _seed(UserModel user) {
    _nameController.text = user.name;
    _locationController.text = user.location;
    _syncReadOnly(user);
    _seeded = true;
  }

  // Picker ile değişen salt-okunur alanları güncel state'e eşitler (ad hariç).
  void _syncReadOnly(UserModel user) {
    // Saklanan '.name' değerini Türkçe etikete çevirerek gösterir.
    _genderController.text =
        GenderOption.values
            .where((g) => g.name == user.gender)
            .firstOrNull
            ?.displayName ??
        user.gender;
    _birthDateController.text = DateFormat('dd.MM.yyyy').format(user.birthDate);
    _birthTimeController.text = DateFormat('HH:mm').format(user.birthDate);
    _zodiacController.text = ZodiacSign.values
        .firstWhere(
          (z) => z.name == user.zodiacSign,
          orElse: () => ZodiacSign.aries,
        )
        .turkishName;
    _workStateController.text = WorkStatus.values
        .firstWhere(
          (w) => w.name == user.workState,
          orElse: () => WorkStatus.student,
        )
        .turkishName;
    _relationShipController.text = RelationshipStatus.values
        .firstWhere(
          (r) => r.name == user.relationshipState,
          orElse: () => RelationshipStatus.single,
        )
        .turkishName;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileEditViewModelProvider);
    final notifier = ref.read(profileEditViewModelProvider.notifier);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // İlk kullanıcıda her şeyi doldur, sonrasında sadece readOnly alanları eşitle.
    if (!_seeded) {
      _seed(user);
    } else {
      _syncReadOnly(user);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profili Düzenle')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
                onChanged: (value) => notifier.updateUser(name: value),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Şehir'),
                onChanged: (value) => notifier.updateUser(location: value),
              ),
              _PickerField(
                controller: _genderController,
                label: 'Cinsiyet',
                onTap: () => _showBottomPicker<GenderOption>(
                  context,
                  values: GenderOption.values,
                  displayText: (g) => g.displayName,
                  onSelected: (v) => notifier.updateUser(gender: v.name),
                ),
              ),
              _PickerField(
                controller: _birthDateController,
                label: 'Doğum Tarihi',
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: user.birthDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    final merged = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      user.birthDate.hour,
                      user.birthDate.minute,
                    );
                    notifier.updateUser(birthDate: merged);
                  }
                },
              ),
              _PickerField(
                controller: _birthTimeController,
                label: 'Doğum Saati',
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(user.birthDate),
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
              _PickerField(
                controller: _zodiacController,
                label: 'Burcun',
                onTap: () => _showBottomPicker<ZodiacSign>(
                  context,
                  values: ZodiacSign.values,
                  displayText: (z) => z.turkishName,
                  onSelected: (v) => notifier.updateUser(zodiacSign: v.name),
                ),
              ),
              _PickerField(
                controller: _workStateController,
                label: 'Meslek',
                onTap: () => _showBottomPicker<WorkStatus>(
                  context,
                  values: WorkStatus.values,
                  displayText: (s) => s.turkishName,
                  onSelected: (v) => notifier.updateUser(workState: v.name),
                ),
              ),
              _PickerField(
                controller: _relationShipController,
                label: 'İlişki Durumu',
                onTap: () => _showBottomPicker<RelationshipStatus>(
                  context,
                  values: RelationshipStatus.values,
                  displayText: (s) => s.turkishName,
                  onSelected: (v) =>
                      notifier.updateUser(relationshipState: v.name),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  LoadingDialog.show(context);
                  await notifier.saveUserChanges();
                  if (context.mounted) LoadingDialog.hide(context);
                  CustomSnackBar.show('Profil Güncellendi');
                  if (context.mounted) {
                    ref.read(appNavigatorProvider).pop();
                  }
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

// Dokununca picker açan salt-okunur metin alanı.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.controller,
    required this.label,
    required this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
      ),
      onTap: onTap,
    );
  }
}
