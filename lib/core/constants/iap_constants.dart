class IapConstants {
  static const String appPrefix = 'bmc';

  static const String configUrl = 'https://api2.blwsmartware.net/T106.json';
  static const String configCacheKey = 'iap_config_cache';
  static const Duration configTimeout = Duration(seconds: 10);

  static const List<int> packCoinAmounts = [50, 100, 200, 300, 500, 750, 1000, 1500, 2000, 5000];

  static String packId(int n) => '${appPrefix}_pack_$n';

  static String get removeAds => '${appPrefix}_remove_ads';

  static List<String> get packIds =>
      List.generate(packCoinAmounts.length, (i) => packId(i + 1));

  static Set<String> get consumableIds => packIds.toSet();

  static Set<String> get nonConsumableIds => {removeAds};

  static Set<String> get allProductIds => {...consumableIds, ...nonConsumableIds};

  static Map<String, int> get coinAmounts {
    final map = <String, int>{};
    for (var i = 0; i < packCoinAmounts.length; i++) {
      map[packId(i + 1)] = packCoinAmounts[i];
    }
    return map;
  }

  static const int pointsPerCalculation = 5;

  static const String itemRemoveAds = 'remove_ads';
  static const String itemThemeOcean = 'theme_ocean';
  static const String itemThemeSunset = 'theme_sunset';
  static const String itemBgGradient = 'bg_gradient';
  static const String itemPremiumExport = 'premium_export';
}
