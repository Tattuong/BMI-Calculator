import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/themes/shop_theme_extension.dart';
import '../../core/utils/bmi_utils.dart';
import '../../models/bmi_entry.dart';
import '../../providers/bmi_provider.dart';
import '../../providers/points_provider.dart';
import '../../widgets/bmi_result_card.dart';
import '../../widgets/points_badge.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  BmiEntry? _lastResult;
  String? _error;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    final height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    final provider = context.read<BmiProvider>();
    final isMetric = provider.unitSystem == UnitSystem.metric;

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      setState(() {
        _error = AppStrings.t(context, 'invalidInput');
        _lastResult = null;
      });
      return;
    }

    if (isMetric && (height < 50 || height > 300)) {
      setState(() {
        _error = AppStrings.t(context, 'invalidHeight');
        _lastResult = null;
      });
      return;
    }

    if (!isMetric && (height < 20 || height > 120)) {
      setState(() {
        _error = AppStrings.t(context, 'invalidHeight');
        _lastResult = null;
      });
      return;
    }

    final entry = await provider.saveCalculation(weight: weight, height: height);
    if (!mounted) return;

    if (entry != null) {
      final earned = await context.read<PointsProvider>().earnFromCalculation();
      if (mounted) PointsEarnedSnackBar.show(context, earned);
    }

    setState(() {
      _error = null;
      _lastResult = entry;
    });
  }

  void _reset() {
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _lastResult = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BmiProvider>();
    final isMetric = provider.unitSystem == UnitSystem.metric;
    final c = ShopThemeExtension.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          Text(
            AppStrings.t(context, 'calculator'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.t(context, 'calculatorSubtitle'),
            style: TextStyle(color: c.onSurfaceVariant, fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 24),
          _UnitToggle(
            isMetric: isMetric,
            onChanged: (metric) => provider.setUnitSystem(metric ? UnitSystem.metric : UnitSystem.imperial),
          ),
          const SizedBox(height: 20),
          _InputCard(
            icon: Icons.monitor_weight_outlined,
            label: AppStrings.t(context, 'weight'),
            hint: isMetric ? AppStrings.t(context, 'weightHintMetric') : AppStrings.t(context, 'weightHintImperial'),
            controller: _weightController,
            suffix: isMetric ? 'kg' : 'lbs',
          ),
          const SizedBox(height: 14),
          _InputCard(
            icon: Icons.height,
            label: AppStrings.t(context, 'height'),
            hint: isMetric ? AppStrings.t(context, 'heightHintMetric') : AppStrings.t(context, 'heightHintImperial'),
            controller: _heightController,
            suffix: isMetric ? 'cm' : 'in',
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _calculate,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(AppStrings.t(context, 'calculate')),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _reset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          if (_lastResult != null) ...[
            const SizedBox(height: 28),
            BmiResultCard(entry: _lastResult!),
            const SizedBox(height: 20),
            _CategoryGuide(),
          ],
        ],
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final bool isMetric;
  final ValueChanged<bool> onChanged;

  const _UnitToggle({required this.isMetric, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleChip(
              label: AppStrings.t(context, 'metric'),
              selected: isMetric,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleChip(
              label: AppStrings.t(context, 'imperial'),
              selected: !isMetric,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? c.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? c.primary : c.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final String suffix;

  const _InputCard({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final c = ShopThemeExtension.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: c.primary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: hint,
              suffixText: suffix,
              suffixStyle: TextStyle(fontWeight: FontWeight.w600, color: c.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('categoryUnderweight', '< 18.5', BmiCategory.underweight),
      ('categoryNormal', '18.5 – 24.9', BmiCategory.normal),
      ('categoryOverweight', '25 – 29.9', BmiCategory.overweight),
      ('categoryObese', '≥ 30', BmiCategory.obese),
    ];

    final c = ShopThemeExtension.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.t(context, 'bmiScale'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: BmiUtils.categoryColor(item.$3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(AppStrings.t(context, item.$1))),
                  Text(item.$2, style: TextStyle(color: c.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
