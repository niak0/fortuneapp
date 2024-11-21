import 'package:flutter/material.dart';
import 'package:fortuneapp/features/numerology/helpers/numerology_items.dart';

class NumerologyDetailView extends StatefulWidget {
  final NumerologyItem? selectedItem;
  final Map<NumerologyItem, int> values;

  const NumerologyDetailView({super.key, this.selectedItem, required this.values});

  @override
  NumerologyDetailViewState createState() => NumerologyDetailViewState();
}

class NumerologyDetailViewState extends State<NumerologyDetailView> {
  late NumerologyItem _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.selectedItem ?? widget.values.keys.first;
  }

  void _onSegmentSelected(NumerologyItem item) {
    setState(() {
      _currentItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentItem.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SegmentedButton<NumerologyItem>(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                side: WidgetStateProperty.all(BorderSide(color: Theme.of(context).colorScheme.primary, width: 0)),
                alignment: Alignment.centerLeft,
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return widget.selectedItem?.color ?? widget.values.keys.first.color;
                    }
                    return Colors.transparent; // Diğer segmentlerin arka plan rengi
                  },
                ),
                foregroundColor: WidgetStateProperty.all(Colors.black),
              ),
              showSelectedIcon: false,
              segments: widget.values.keys.map((item) {
                return ButtonSegment(
                  value: item,
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(item.displayName, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
                      Divider(color: Theme.of(context).colorScheme.tertiary, thickness: 0.5),
                      Chip(
                        label: Text("${widget.values[item]}",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              selected: {_currentItem},
              onSelectionChanged: (selected) {
                _onSegmentSelected(selected.first);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildDetailContent(_currentItem, widget.values[_currentItem]!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent(NumerologyItem item, int value) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.transparent,
            child: ExpansionTile(
              title: const Text("Bu sayı ne anlama geliyor?"),
              children: [
                Text(item.description),
              ],
            ),
          ),
          Card(
            color: Colors.transparent,
            child: ExpansionTile(
              title: const Text("Nasıl hesaplanır?"),
              children: [
                Text(item.description),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                shape: const CircleBorder(),
                backgroundColor: item.color,
                label: Icon(item.icon),
              ),
              Chip(
                backgroundColor: item.color,
                label: Text(
                  "Açıklama",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
            ],
          ),
          Text(item.description),
          const SizedBox(height: 16),
          Text(
            'Değer: $value',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
