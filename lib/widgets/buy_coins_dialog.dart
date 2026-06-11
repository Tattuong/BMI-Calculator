import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/iap_constants.dart';
import '../providers/iap_provider.dart';

class BuyCoinsDialog extends StatelessWidget {
  const BuyCoinsDialog({super.key});

  static Future<void> show(BuildContext context) async {
    final iap = context.read<IapProvider>();
    if (!iap.isBillingEnabled) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BuyCoinsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iap = context.watch<IapProvider>();
    final products = iap.coinProducts;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.t(context, 'buyCoins'),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        AppStrings.t(context, 'buyCoinsDesc'),
                        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            if (iap.isNetworkIssue) ...[
              const SizedBox(height: 16),
              _WarningBanner(text: AppStrings.t(context, 'iapNetworkWarning')),
            ],
            if (iap.isPurchasing) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ] else if (products.isEmpty) ...[
              const SizedBox(height: 24),
              Text(
                AppStrings.t(context, 'noProducts'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ] else ...[
              const SizedBox(height: 20),
              ...products.map((p) => _CoinPackTile(product: p)),
            ],
            if (iap.lastPurchaseError != null) ...[
              const SizedBox(height: 12),
              Text(
                iap.lastPurchaseError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CoinPackTile extends StatelessWidget {
  final ProductDetails product;

  const _CoinPackTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final iap = context.read<IapProvider>();
    final coins = IapConstants.coinAmounts[product.id] ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: iap.isPurchasing ? null : () => iap.buyCoins(product),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.t(context, 'coinPack', params: {'amount': '$coins'}),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
                FilledButton(
                  onPressed: iap.isPurchasing ? null : () => iap.buyCoins(product),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(product.price),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String text;

  const _WarningBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 18, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
