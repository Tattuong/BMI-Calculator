import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/themes/shop_theme_extension.dart';
import '../../models/shop_item.dart';
import '../../providers/iap_provider.dart';
import '../../providers/points_provider.dart';
import '../../widgets/buy_coins_dialog.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iap = context.watch<IapProvider>();
    final points = context.watch<PointsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t(context, 'shop'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _PointsHeader(
            points: points.points,
            showBuyMore: iap.isBillingEnabled,
            onBuyMore: () => BuyCoinsDialog.show(context),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.t(context, 'shopGrindHint'),
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.t(context, 'shopItems'),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          const SizedBox(height: 12),
          ...ShopCatalog.items.map((item) => _ShopItemTile(item: item)),
          const SizedBox(height: 16),
          if (iap.isBillingEnabled && iap.removeAdsProduct != null && !points.hasRemoveAds) ...[
            Text(
              AppStrings.t(context, 'shopIapSection'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            const SizedBox(height: 12),
            _RemoveAdsIapTile(product: iap.removeAdsProduct!),
          ],
        ],
      ),
    );
  }
}

class _PointsHeader extends StatelessWidget {
  final int points;
  final bool showBuyMore;
  final VoidCallback onBuyMore;

  const _PointsHeader({
    required this.points,
    required this.showBuyMore,
    required this.onBuyMore,
  });

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: c.cardGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: Colors.amber, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.t(context, 'yourPoints'),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '$points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (showBuyMore)
            FilledButton.tonal(
              onPressed: onBuyMore,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
              ),
              child: Text(AppStrings.t(context, 'buyMore')),
            ),
        ],
      ),
    );
  }
}

class _ShopItemTile extends StatelessWidget {
  final ShopItem item;

  const _ShopItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    final points = context.watch<PointsProvider>();
    final owned = points.isUnlocked(item.id);
    final isActive = _isActive(points, item);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? c.primary : c.surfaceVariant,
          width: isActive ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (item.previewColor ?? c.primary).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(item.icon, color: item.previewColor ?? c.primary),
        ),
        title: Text(
          AppStrings.t(context, item.nameKey),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          AppStrings.t(context, item.descKey),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: owned
            ? _buildOwnedAction(context, points, item, isActive)
            : _BuyButton(price: item.price, onTap: () => _buy(context, item)),
      ),
    );
  }

  bool _isActive(PointsProvider points, ShopItem item) {
    if (item.type == ShopItemType.theme) return points.activeTheme == item.id;
    if (item.type == ShopItemType.background) return points.activeBackground == item.id;
    return false;
  }

  Widget _buildOwnedAction(BuildContext context, PointsProvider points, ShopItem item, bool isActive) {
    if (item.type == ShopItemType.theme || item.type == ShopItemType.background) {
      return TextButton(
        onPressed: () async {
          final wasActive = isActive;
          if (wasActive) {
            if (item.type == ShopItemType.theme) {
              await points.setActiveTheme(null);
            } else {
              await points.setActiveBackground(null);
            }
          } else {
            if (item.type == ShopItemType.theme) {
              await points.setActiveTheme(item.id);
            } else {
              await points.setActiveBackground(item.id);
            }
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  wasActive
                      ? AppStrings.t(context, 'themeDeactivated')
                      : AppStrings.t(context, 'themeActivated'),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Text(isActive ? AppStrings.t(context, 'deactivate') : AppStrings.t(context, 'activate')),
      );
    }
    return Chip(
      label: Text(AppStrings.t(context, 'owned')),
      backgroundColor: AppColors.success.withValues(alpha: 0.12),
      labelStyle: const TextStyle(color: AppColors.success, fontSize: 12),
    );
  }

  Future<void> _buy(BuildContext context, ShopItem item) async {
    final points = context.read<PointsProvider>();
    final iap = context.read<IapProvider>();
    final result = await points.buyWithPoints(item);

    if (!context.mounted) return;

    switch (result) {
      case PurchaseResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.t(context, 'purchaseSuccess'))),
        );
        if (item.type == ShopItemType.theme) {
          await points.setActiveTheme(item.id);
        } else if (item.type == ShopItemType.background) {
          await points.setActiveBackground(item.id);
        }
      case PurchaseResult.insufficientPoints:
        final shouldBuy = iap.isBillingEnabled
            ? await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(AppStrings.t(ctx, 'notEnoughPoints')),
                  content: Text(AppStrings.t(ctx, 'notEnoughPointsDesc')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(AppStrings.t(ctx, 'cancel')),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(AppStrings.t(ctx, 'buyMore')),
                    ),
                  ],
                ),
              )
            : await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(AppStrings.t(ctx, 'notEnoughPoints')),
                  content: Text(AppStrings.t(ctx, 'notEnoughPointsGrind')),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(AppStrings.t(ctx, 'ok')),
                    ),
                  ],
                ),
              );
        if (shouldBuy == true && context.mounted) {
          await BuyCoinsDialog.show(context);
        }
      case PurchaseResult.alreadyOwned:
        break;
    }
  }
}

class _BuyButton extends StatelessWidget {
  final int price;
  final VoidCallback onTap;

  const _BuyButton({required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        minimumSize: Size.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text('$price', style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _RemoveAdsIapTile extends StatelessWidget {
  final ProductDetails product;

  const _RemoveAdsIapTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final iap = context.watch<IapProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.block, color: AppColors.error),
        ),
        title: Text(
          AppStrings.t(context, 'shopRemoveAds'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          AppStrings.t(context, 'shopRemoveAdsIapDesc'),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: FilledButton(
          onPressed: iap.isPurchasing ? null : () => iap.buyRemoveAds(),
          child: Text(product.price),
        ),
      ),
    );
  }
}
