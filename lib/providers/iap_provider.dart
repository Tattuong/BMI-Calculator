import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../core/constants/iap_constants.dart';
import '../core/services/billing_service.dart';
import '../core/services/iap_config_service.dart';
import '../models/iap_config.dart';

enum IapLoadState { idle, loading, ready, error }

class IapProvider extends ChangeNotifier {
  IapConfig? _config;
  IapConfigStatus _configStatus = IapConfigStatus.loading;
  IapLoadState _loadState = IapLoadState.idle;
  bool _billingReady = false;
  bool _isPurchasing = false;
  String? _lastPurchaseError;

  IapConfig? get config => _config;
  IapConfigStatus get configStatus => _configStatus;
  IapLoadState get loadState => _loadState;
  bool get isPurchasing => _isPurchasing;
  String? get lastPurchaseError => _lastPurchaseError;

  /// disable=1 → tắt Google Billing popup, disable=0 → cho mua qua Google Play
  bool get isBillingEnabled => _config?.isBillingEnabled ?? false;

  bool get isNetworkIssue =>
      _configStatus == IapConfigStatus.networkError ||
      _configStatus == IapConfigStatus.timeout;

  List<ProductDetails> get coinProducts => BillingService.instance.consumableProducts;
  ProductDetails? get removeAdsProduct => BillingService.instance.removeAdsProduct;

  Future<void> initialize() async {
    if (_loadState == IapLoadState.loading) return;
    _loadState = IapLoadState.loading;
    notifyListeners();

    final result = await IapConfigService.instance.fetchConfig();
    _config = result.config;
    _configStatus = result.status;

    if (isBillingEnabled) {
      _billingReady = await BillingService.instance.init(
        onPurchaseComplete: _handlePurchaseComplete,
      );
    }

    _loadState = IapLoadState.ready;
    notifyListeners();
  }

  Future<void> refreshConfig() => initialize();

  Future<void> buyCoins(ProductDetails product) async {
    if (!isBillingEnabled || !_billingReady) return;
    _isPurchasing = true;
    _lastPurchaseError = null;
    notifyListeners();
    await BillingService.instance.buyConsumable(product);
  }

  Future<void> buyRemoveAds() async {
    final product = removeAdsProduct;
    if (!isBillingEnabled || !_billingReady || product == null) return;
    _isPurchasing = true;
    _lastPurchaseError = null;
    notifyListeners();
    await BillingService.instance.buyNonConsumable(product);
  }

  Future<void> restorePurchases() async {
    if (!isBillingEnabled || !_billingReady) return;
    _isPurchasing = true;
    notifyListeners();
    await BillingService.instance.restorePurchases();
  }

  void _handlePurchaseComplete(String productId, bool success, String? error) {
    _isPurchasing = false;
    if (!success) {
      if (error != 'canceled') _lastPurchaseError = error;
      notifyListeners();
      return;
    }
    _lastPurchaseError = null;
    notifyListeners();

    // Notify PointsProvider via callback set externally
    onPurchaseSuccess?.call(productId);
  }

  /// Set by main.dart to bridge purchase → points
  void Function(String productId)? onPurchaseSuccess;

  int coinsForProduct(String productId) =>
      IapConstants.coinAmounts[productId] ?? 0;

  @override
  void dispose() {
    BillingService.instance.dispose();
    super.dispose();
  }
}
