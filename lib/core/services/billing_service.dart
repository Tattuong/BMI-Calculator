import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants/iap_constants.dart';

typedef PurchaseCallback = void Function(String productId, bool success, String? error);

class BillingService {
  static final BillingService instance = BillingService._();
  BillingService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  PurchaseCallback? _onPurchaseComplete;
  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => List.unmodifiable(_products);

  List<ProductDetails> get consumableProducts => _products
      .where((p) => IapConstants.consumableIds.contains(p.id))
      .toList()
    ..sort((a, b) {
      final aCoins = IapConstants.coinAmounts[a.id] ?? 0;
      final bCoins = IapConstants.coinAmounts[b.id] ?? 0;
      return aCoins.compareTo(bCoins);
    });

  ProductDetails? get removeAdsProduct =>
      _products.where((p) => p.id == IapConstants.removeAds).firstOrNull;

  Future<bool> init({required PurchaseCallback onPurchaseComplete}) async {
    _onPurchaseComplete = onPurchaseComplete;
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      debugPrint('Billing not available on this device');
      return false;
    }

    _subscription?.cancel();
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (e) => debugPrint('Purchase stream error: $e'),
    );

    await _loadProducts();
    return true;
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(IapConstants.allProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }
    if (response.error != null) {
      debugPrint('Query products error: ${response.error}');
    }
    _products = response.productDetails;
  }

  Future<void> buyConsumable(ProductDetails product) async {
    if (!_isAvailable) return;
    final param = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
  }

  Future<void> buyNonConsumable(ProductDetails product) async {
    if (!_isAvailable) return;
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) return;
    await _iap.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _onPurchaseComplete?.call(purchase.productID, true, null);
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.error:
          _onPurchaseComplete?.call(
            purchase.productID,
            false,
            purchase.error?.message ?? 'Purchase failed',
          );
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.canceled:
          _onPurchaseComplete?.call(purchase.productID, false, 'canceled');
          break;
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
