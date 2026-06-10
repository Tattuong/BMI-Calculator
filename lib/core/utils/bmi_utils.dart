import 'package:flutter/material.dart';

enum BmiCategory {
  underweight,
  normal,
  overweight,
  obese,
}

enum UnitSystem { metric, imperial }

class BmiResult {
  final double bmi;
  final BmiCategory category;

  const BmiResult({required this.bmi, required this.category});
}

class BmiUtils {
  static double calculateBmi({
    required double weight,
    required double height,
    required UnitSystem unitSystem,
  }) {
    if (weight <= 0 || height <= 0) return 0;

    if (unitSystem == UnitSystem.metric) {
      final heightM = height / 100;
      return weight / (heightM * heightM);
    }

    return 703 * weight / (height * height);
  }

  static BmiCategory categoryFor(double bmi) {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25) return BmiCategory.normal;
    if (bmi < 30) return BmiCategory.overweight;
    return BmiCategory.obese;
  }

  static BmiResult compute({
    required double weight,
    required double height,
    required UnitSystem unitSystem,
  }) {
    final bmi = calculateBmi(weight: weight, height: height, unitSystem: unitSystem);
    return BmiResult(bmi: bmi, category: categoryFor(bmi));
  }

  static Color categoryColor(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return const Color(0xFF3B82F6);
      case BmiCategory.normal:
        return const Color(0xFF22C55E);
      case BmiCategory.overweight:
        return const Color(0xFFF59E0B);
      case BmiCategory.obese:
        return const Color(0xFFEF4444);
    }
  }

  static String categoryKey(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return 'categoryUnderweight';
      case BmiCategory.normal:
        return 'categoryNormal';
      case BmiCategory.overweight:
        return 'categoryOverweight';
      case BmiCategory.obese:
        return 'categoryObese';
    }
  }

  static String categoryAdviceKey(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return 'adviceUnderweight';
      case BmiCategory.normal:
        return 'adviceNormal';
      case BmiCategory.overweight:
        return 'adviceOverweight';
      case BmiCategory.obese:
        return 'adviceObese';
    }
  }
}
