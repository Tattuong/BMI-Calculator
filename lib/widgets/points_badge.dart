import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_strings.dart';
import '../core/themes/shop_theme_extension.dart';
import '../providers/iap_provider.dart';
import '../providers/points_provider.dart';
import '../screens/shop/shop_screen.dart';
import 'buy_coins_dialog.dart';

class PointsBadge extends StatelessWidget {
  const PointsBadge({super.key});

  void _onTap(BuildContext context) {
    final iap = context.read<IapProvider>();
    if (iap.isBillingEnabled) {
      BuyCoinsDialog.show(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final iap = context.watch<IapProvider>();
    final points = context.watch<PointsProvider>().points;
    final c = ShopThemeExtension.of(context);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: c.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars_rounded, size: 18, color: c.primary),
            const SizedBox(width: 4),
            Text(
              '$points',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: c.primary,
              ),
            ),
            if (iap.isBillingEnabled) ...[
              const SizedBox(width: 2),
              Icon(Icons.add_circle_outline, size: 16, color: c.primary.withValues(alpha: 0.7)),
            ],
          ],
        ),
      ),
    );
  }
}

class PointsEarnedSnackBar {
  static void show(BuildContext context, int amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(AppStrings.t(context, 'earnedPoints', params: {'amount': '$amount'})),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
