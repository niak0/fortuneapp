import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  const CustomGrid({super.key, required this.itemCount, required this.itemBuilder, this.physics = const NeverScrollableScrollPhysics()});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollPhysics? physics;


  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 3/2,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
