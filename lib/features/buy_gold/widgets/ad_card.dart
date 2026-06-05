import 'package:flutter/material.dart';

class AdCard extends StatelessWidget {
  const AdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Reklam mı izlicen?"),
                content: const Text("Yok ki neyi izlicen"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ok"),
                  ),
                ],
              );
            },
          );
        },
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          "Reklam İzle Kredi Kazan",
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Icon(Icons.video_library, color: scheme.primary),
        trailing: ElevatedButton.icon(
          onPressed: null,
          icon: Icon(Icons.money_off_csred_outlined, color: scheme.onPrimary),
          label: Text("+1", style: TextStyle(color: scheme.onPrimary)),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: scheme.primary,
          ),
        ),
      ),
    );
  }
}
