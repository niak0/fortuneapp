import 'package:flutter/material.dart';

class FontSizeSlider extends StatefulWidget {
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  const FontSizeSlider({
    super.key,
    required this.fontSize,
    required this.onFontSizeChanged,
  });

  @override
  FontSizeSliderState createState() => FontSizeSliderState();
}

class FontSizeSliderState extends State<FontSizeSlider> {
  late double _localFontSize;

  @override
  void initState() {
    super.initState();
    _localFontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Yazı Boyutunu Ayarla',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(
            min: 14.0,
            max: 26.0,
            value: _localFontSize,
            onChanged: (newSize) {
              setState(() {
                _localFontSize = newSize;
              });
              widget.onFontSizeChanged(newSize);
            },
          ),
          Text('Seçilen Yazı Boyutu: ${_localFontSize.toInt()}'),
        ],
      ),
    );
  }
}

