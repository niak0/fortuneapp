import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const Shimmer({super.key, required this.isLoading, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final shimmerPosition = _controller.value * bounds.width;
            return LinearGradient(
              colors: [Colors.grey.shade100, Colors.grey.shade500, Colors.grey.shade100],
              stops: const [0.2, 0.5, 0.8],
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
            ).createShader(
              Rect.fromLTWH(shimmerPosition - bounds.width, 0, bounds.width * 1.5, bounds.height),
            );
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}