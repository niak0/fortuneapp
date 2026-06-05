import 'package:flutter/material.dart';

// Çocuğu yumuşakça belirten giriş animasyonu (fade + yukarı kayma).
// `delay` ile sıralı (stagger) açılışlar kurulabilir; ekstra paket gerekmez.
class MysticReveal extends StatefulWidget {
  const MysticReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<MysticReveal> createState() => _MysticRevealState();
}

class _MysticRevealState extends State<MysticReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    // Gecikme sonrası animasyonu başlatır (dispose sonrası güvenli).
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: widget.child,
      ),
    );
  }
}
