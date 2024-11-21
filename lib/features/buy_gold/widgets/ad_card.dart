import 'package:flutter/material.dart';

class AdCard extends StatelessWidget {
  const AdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown[700],
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
                  )
                ],
              );
            },
          );
        },
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: const Text(
          "Reklam İzle Kredi Kazan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: const Icon(Icons.video_library, color: Colors.orange),
        trailing: ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.money_off_csred_outlined, color: Colors.white),
          label: const Text("+1", style: TextStyle(color: Colors.white)),
          style:
          ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), disabledBackgroundColor: Colors.orange),
        ),
      ),
    );
  }
}