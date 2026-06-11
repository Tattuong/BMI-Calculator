import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_strings.dart';
import '../../core/themes/shop_theme_extension.dart';
import '../../core/utils/bmi_utils.dart';
import '../../models/bmi_entry.dart';

class BmiResultCard extends StatelessWidget {
  final BmiEntry entry;

  const BmiResultCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    final category = BmiCategory.values.byName(entry.category);
    final color = BmiUtils.categoryColor(category);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.15), c.surface],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.t(context, 'yourBmi'),
            style: TextStyle(color: c.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            entry.bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppStrings.t(context, BmiUtils.categoryKey(category)),
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.t(context, BmiUtils.categoryAdviceKey(category)),
            textAlign: TextAlign.center,
            style: TextStyle(color: c.onSurfaceVariant, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatChip(
                label: AppStrings.t(context, 'weight'),
                value: '${entry.weight.toStringAsFixed(1)} ${entry.unitSystem == 'metric' ? 'kg' : 'lbs'}',
              ),
              const SizedBox(width: 12),
              _StatChip(
                label: AppStrings.t(context, 'height'),
                value: '${entry.height.toStringAsFixed(1)} ${entry.unitSystem == 'metric' ? 'cm' : 'in'}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BmiHistoryTile extends StatelessWidget {
  final BmiEntry entry;
  final VoidCallback onDelete;

  const BmiHistoryTile({super.key, required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    final category = BmiCategory.values.byName(entry.category);
    final color = BmiUtils.categoryColor(category);
    final date = DateFormat.yMMMd(Localizations.localeOf(context).languageCode).add_jm().format(entry.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.surfaceVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              entry.bmi.toStringAsFixed(1),
              style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.t(context, BmiUtils.categoryKey(category)),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.weight.toStringAsFixed(1)} ${entry.unitSystem == 'metric' ? 'kg' : 'lbs'} · '
                  '${entry.height.toStringAsFixed(1)} ${entry.unitSystem == 'metric' ? 'cm' : 'in'}',
                  style: TextStyle(color: c.onSurfaceVariant, fontSize: 13),
                ),
                Text(date, style: TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: c.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: c.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
