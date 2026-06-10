import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../core/services/storage_service.dart';
import '../core/utils/bmi_utils.dart';
import '../models/bmi_entry.dart';

class BmiProvider extends ChangeNotifier {
  static const _storageKey = 'bmi_history';

  UnitSystem _unitSystem = UnitSystem.metric;
  final List<BmiEntry> _history = [];

  UnitSystem get unitSystem => _unitSystem;
  List<BmiEntry> get history => List.unmodifiable(_history);

  BmiProvider() {
    _load();
  }

  Future<void> _load() async {
    final unit = await StorageService.instance.getString('bmi_unit_system');
    if (unit == 'imperial') _unitSystem = UnitSystem.imperial;

    final raw = await StorageService.instance.getString(_storageKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _history
          ..clear()
          ..addAll(list.map((e) => BmiEntry.fromJson(e as Map<String, dynamic>)));
        _history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } catch (e) {
        debugPrint('Error loading BMI history: $e');
      }
    }
    notifyListeners();
  }

  Future<void> setUnitSystem(UnitSystem unitSystem) async {
    if (_unitSystem == unitSystem) return;
    _unitSystem = unitSystem;
    await StorageService.instance.saveString(
      'bmi_unit_system',
      unitSystem == UnitSystem.imperial ? 'imperial' : 'metric',
    );
    notifyListeners();
  }

  Future<BmiEntry?> saveCalculation({
    required double weight,
    required double height,
  }) async {
    final result = BmiUtils.compute(
      weight: weight,
      height: height,
      unitSystem: _unitSystem,
    );
    if (result.bmi <= 0) return null;

    final entry = BmiEntry(
      id: const Uuid().v4(),
      bmi: double.parse(result.bmi.toStringAsFixed(1)),
      weight: weight,
      height: height,
      unitSystem: _unitSystem.name,
      category: result.category.name,
      createdAt: DateTime.now(),
    );

    _history.insert(0, entry);
    await _persist();
    notifyListeners();
    return entry;
  }

  Future<void> deleteEntry(String id) async {
    _history.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(_history.map((e) => e.toJson()).toList());
    await StorageService.instance.saveString(_storageKey, encoded);
  }
}
