import 'package:flutter/material.dart';
import 'package:fortuneapp/core/navigation/app_navigator_manager.dart';
import 'package:fortuneapp/core/navigation/app_navigator.dart';
import 'package:provider/provider.dart';
import 'package:fortuneapp/core/auth/auth_manager.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _askBeforeUsingGold = true;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Türkçe';
  String _selectedTheme = 'Gece Modu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigatorManager.instance.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard([
              _buildDropdownTile('Dil', _selectedLanguage, ['Türkçe', 'İngilizce']),
              _buildDropdownTile('Tema', _selectedTheme, ['Gece Modu', 'Gündüz Modu']),
            ]),
            _buildCard([
              _buildSwitchItem('Altın Kullanırken Sor', _askBeforeUsingGold, context),
              _buildSwitchItem('Bildirimler', _notificationsEnabled, context),
            ]),
            _buildCard([
              _buildListTile('Yardım', () {
                // TODO: Yardım sayfasına yönlendir
              }),
              _buildListTile('Çıkış Yap', () async {
                final authManager = Provider.of<AuthManager>(context, listen: false);
                await authManager.signOut();
                if (context.mounted) {
                  AppNavigatorManager.instance.pushAndRemoveUntil(AppRoutes.login);
                }
              }),
            ]),
            TextButton(
                onPressed: () => _showDeleteAccountDialog(context),
                child: const Text("Hesabımı Sil", style: TextStyle(color: Colors.red, fontSize: 16))),
            const SizedBox(height: 10),
            const Text(
              "Fortune App v1",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      child: Column(
        children: children.map((widget) {
          return Column(
            children: [
              widget,
              if (widget != children.last) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDropdownTile(String title, String selectedValue, List<String> options) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: selectedValue,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              if (title == 'Dil') {
                _selectedLanguage = value;
                // TODO: Dil değiştirme işlemi
              } else if (title == 'Tema') {
                _selectedTheme = value;
                // TODO: Tema değiştirme işlemi
              }
            });
          }
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (bool newValue) {
        setState(() {
          if (title == 'Altın Kullanırken Sor') {
            _askBeforeUsingGold = newValue;
            // TODO: Altın kullanım onayı ayarını kaydet
          } else if (title == 'Bildirimler') {
            _notificationsEnabled = newValue;
            // TODO: Bildirim ayarlarını güncelle
          }
        });
      },
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveThumbColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hesabı Sil'),
          content: const Text('Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final authManager = Provider.of<AuthManager>(context, listen: false);
                await authManager.signOut();
                if (context.mounted) {
                  AppNavigatorManager.instance.pushAndRemoveUntil(AppRoutes.login);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
