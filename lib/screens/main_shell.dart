import 'package:flutter/material.dart';

import 'history/bmi_history_screen.dart';
import 'home/bmi_calculator_screen.dart';
import 'settings/settings_screen.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/points_badge.dart';
import '../widgets/themed_background.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    BmiCalculatorScreen(),
    BmiHistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ThemedBackground(
        child: Stack(
          children: [
            IndexedStack(index: _index, children: _pages),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: const PointsBadge(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
