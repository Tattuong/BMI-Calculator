import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/services/storage_service.dart';
import 'core/themes/app_theme.dart';
import 'providers/bmi_provider.dart';
import 'providers/iap_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/points_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BmiCalculatorApp());
}

class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => BmiProvider()),
        ChangeNotifierProvider(create: (_) => PointsProvider()),
        ChangeNotifierProvider(create: (_) => IapProvider()),
      ],
      child: Consumer3<ThemeProvider, LocaleProvider, PointsProvider>(
        builder: (context, themeProvider, localeProvider, pointsProvider, _) {
          return MaterialApp(
            title: 'BMI Calculator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightThemeFor(pointsProvider.activeTheme),
            darkTheme: AppTheme.darkThemeFor(pointsProvider.activeTheme),
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('vi'), Locale('en')],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
