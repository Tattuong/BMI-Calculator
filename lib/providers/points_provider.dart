import 'package:flutter/material.dart';

import '../core/constants/iap_constants.dart';
import '../core/services/storage_service.dart';
import '../models/shop_item.dart';

class PointsProvider extends ChangeNotifier {
  static const _pointsKey = 'user_points';
  static const _unlockedKey = 'unlocked_items';
  static const _activeThemeKey = 'active_theme';
  static const _activeBgKey = 'active_background';

  int _points = 0;
  final Set<String> _unlocked = {};
  String? _activeTheme;
  String? _activeBackground;

  int get points => _points;
  Set<String> get unlockedItems => Set.unmodifiable(_unlocked);
  String? get activeTheme => _activeTheme;
  String? get activeBackground => _activeBackground;

  bool get hasRemoveAds => _unlocked.contains(IapConstants.itemRemoveAds);
  bool get hasPremiumExport => _unlocked.contains('premium_export');

  PointsProvider() {
    _load();
  }

  Future<void> _load() async {
    _points = await StorageService.instance.getInt(_pointsKey) ?? 0;
    final unlocked = await StorageService.instance.getStringList(_unlockedKey);
    if (unlocked != null) _unlocked.addAll(unlocked);
    _activeTheme = await StorageService.instance.getString(_activeThemeKey);
    _activeBackground = await StorageService.instance.getString(_activeBgKey);
    notifyListeners();
  }

  bool isUnlocked(String itemId) => _unlocked.contains(itemId);

  Future<void> addPoints(int amount) async {
    if (amount <= 0) return;
    _points += amount;
    await StorageService.instance.saveInt(_pointsKey, _points);
    notifyListeners();
  }

  Future<int> earnFromCalculation() async {
    await addPoints(IapConstants.pointsPerCalculation);
    return IapConstants.pointsPerCalculation;
  }

  Future<PurchaseResult> buyWithPoints(ShopItem item) async {
    if (_unlocked.contains(item.id)) {
      return PurchaseResult.alreadyOwned;
    }
    if (_points < item.price) {
      return PurchaseResult.insufficientPoints;
    }
    _points -= item.price;
    _unlocked.add(item.id);
    await StorageService.instance.saveInt(_pointsKey, _points);
    await StorageService.instance.saveStringList(_unlockedKey, _unlocked.toList());
    notifyListeners();
    return PurchaseResult.success;
  }

  Future<void> unlockItem(String itemId) async {
    if (_unlocked.contains(itemId)) return;
    _unlocked.add(itemId);
    await StorageService.instance.saveStringList(_unlockedKey, _unlocked.toList());
    notifyListeners();
  }

  Future<void> setActiveTheme(String? themeId) async {
    if (themeId != null && !_unlocked.contains(themeId)) return;
    _activeTheme = themeId;
    if (themeId == null) {
      await StorageService.instance.remove(_activeThemeKey);
    } else {
      await StorageService.instance.saveString(_activeThemeKey, themeId);
    }
    notifyListeners();
  }

  Future<void> setActiveBackground(String? bgId) async {
    if (bgId != null && !_unlocked.contains(bgId)) return;
    _activeBackground = bgId;
    if (bgId == null) {
      await StorageService.instance.remove(_activeBgKey);
    } else {
      await StorageService.instance.saveString(_activeBgKey, bgId);
    }
    notifyListeners();
  }
}

enum PurchaseResult { success, insufficientPoints, alreadyOwned }
