import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/services/storage_service.dart';
import '../widgets/app_logo.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    await StorageService.instance.saveBool('onboarding_done', true);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.speed, AppStrings.t(context, 'onboardingFeature1')),
      (Icons.analytics_outlined, AppStrings.t(context, 'onboardingFeature2')),
      (Icons.lock_outline, AppStrings.t(context, 'onboardingFeature3')),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const AppLogo(size: 100),
                      const SizedBox(height: 28),
                      Text(
                        AppStrings.t(context, 'onboardingTitle'),
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppStrings.t(context, 'onboardingSubtitle'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 28),
                      ...features.map(
                        (f) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceVariant),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(f.$1, color: AppColors.primary),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(f.$2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _finish(context),
                        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: Text(AppStrings.t(context, 'start')),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _finish(context),
                      child: Text(AppStrings.t(context, 'skip'), style: const TextStyle(color: AppColors.onSurfaceVariant)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
