import 'package:flutter/material.dart';

enum ShopItemType { theme, background, feature, removeAds }

class ShopItem {
  final String id;
  final String nameKey;
  final String descKey;
  final int price;
  final ShopItemType type;
  final IconData icon;
  final Color? previewColor;

  const ShopItem({
    required this.id,
    required this.nameKey,
    required this.descKey,
    required this.price,
    required this.type,
    required this.icon,
    this.previewColor,
  });
}

class ShopCatalog {
  static const items = [
    ShopItem(
      id: 'theme_ocean',
      nameKey: 'shopThemeOcean',
      descKey: 'shopThemeOceanDesc',
      price: 150,
      type: ShopItemType.theme,
      icon: Icons.water,
      previewColor: Color(0xFF0284C7),
    ),
    ShopItem(
      id: 'theme_sunset',
      nameKey: 'shopThemeSunset',
      descKey: 'shopThemeSunsetDesc',
      price: 150,
      type: ShopItemType.theme,
      icon: Icons.wb_sunny_outlined,
      previewColor: Color(0xFFEA580C),
    ),
    ShopItem(
      id: 'bg_gradient',
      nameKey: 'shopBgGradient',
      descKey: 'shopBgGradientDesc',
      price: 100,
      type: ShopItemType.background,
      icon: Icons.gradient,
      previewColor: Color(0xFF7C3AED),
    ),
    ShopItem(
      id: 'premium_export',
      nameKey: 'shopPremiumExport',
      descKey: 'shopPremiumExportDesc',
      price: 200,
      type: ShopItemType.feature,
      icon: Icons.file_download_outlined,
      previewColor: Color(0xFF059669),
    ),
    ShopItem(
      id: 'remove_ads',
      nameKey: 'shopRemoveAds',
      descKey: 'shopRemoveAdsDesc',
      price: 500,
      type: ShopItemType.removeAds,
      icon: Icons.block,
      previewColor: Color(0xFFDC2626),
    ),
  ];

  static ShopItem? findById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}
