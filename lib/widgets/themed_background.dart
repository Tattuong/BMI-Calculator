import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/points_provider.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({super.key, required this.child});

  static const _gradients = {
    'bg_gradient': LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7C3AED), Color(0xFF0D9488), Color(0xFF06B6D4)],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final bgId = context.watch<PointsProvider>().activeBackground;
    final gradient = _gradients[bgId];

    if (gradient == null) return child;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(decoration: BoxDecoration(gradient: gradient)),
        Container(color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.88)),
        child,
      ],
    );
  }
}
