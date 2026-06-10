import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/app_divider.dart';
import '../privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = info.version);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          Text(AppStrings.t(context, 'settings'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          _Section(
            title: AppStrings.t(context, 'theme'),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(value: ThemeMode.light, label: Text(AppStrings.t(context, 'light'))),
                ButtonSegment(value: ThemeMode.dark, label: Text(AppStrings.t(context, 'dark'))),
              ],
              selected: {themeProvider.themeMode},
              onSelectionChanged: (s) => themeProvider.setThemeMode(s.first),
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            title: AppStrings.t(context, 'language'),
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'vi', label: Text(AppStrings.t(context, 'vietnamese'))),
                ButtonSegment(value: 'en', label: Text(AppStrings.t(context, 'english'))),
              ],
              selected: {localeProvider.locale.languageCode},
              onSelectionChanged: (s) => localeProvider.setLocale(Locale(s.first)),
            ),
          ),
          const SizedBox(height: 16),
          _Section(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              ),
              title: Text(AppStrings.t(context, 'privacyPolicy')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
            ),
          ),
          const AppDivider(),
          _Section(
            title: AppStrings.t(context, 'about'),
            child: Text(
              AppStrings.t(context, 'aboutDesc'),
              style: const TextStyle(color: AppColors.onSurfaceVariant, height: 1.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.t(context, 'version')}: $_version',
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              AppStrings.t(context, 'copyright'),
              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final Widget child;

  const _Section({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}
