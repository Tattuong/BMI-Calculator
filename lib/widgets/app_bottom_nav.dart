import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/themes/shop_theme_extension.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    final items = [
      _NavItem(Icons.calculate_outlined, Icons.calculate, 'calculator'),
      _NavItem(Icons.history_outlined, Icons.history, 'history'),
      _NavItem(Icons.settings_outlined, Icons.settings, 'settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final active = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          active ? item.activeIcon : item.icon,
                          color: active ? c.primary : c.onSurfaceVariant,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.t(context, item.labelKey),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            color: active ? c.primary : c.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;

  _NavItem(this.icon, this.activeIcon, this.labelKey);
}
