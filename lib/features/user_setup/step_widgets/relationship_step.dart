import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../enums/relationship_status.dart';
import '../user_setup_view_model.dart';

class RelationshipStep extends StatelessWidget {
  const RelationshipStep({super.key});


  @override
  Widget build(BuildContext context) {
    final UserSetupViewModel viewModel = context.watch<UserSetupViewModel>();
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "İlişki durumun nedir?",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ...RelationshipStatus.values.map((status) => GestureDetector(
                  onTap: () => viewModel.updateUser(relationShipState: status.name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: viewModel.user.relationShipState == status.name ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        status.turkishName,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
