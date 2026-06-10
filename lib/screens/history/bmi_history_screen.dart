import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/bmi_provider.dart';
import '../../widgets/bmi_result_card.dart';

class BmiHistoryScreen extends StatelessWidget {
  const BmiHistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.t(context, 'clearHistory')),
        content: Text(AppStrings.t(context, 'clearHistoryConfirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.t(context, 'cancel'))),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppStrings.t(context, 'delete'))),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<BmiProvider>().clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<BmiProvider>().history;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.t(context, 'history'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.t(context, 'historySubtitle'),
                        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                if (history.isNotEmpty)
                  TextButton(
                    onPressed: () => _confirmClear(context),
                    child: Text(AppStrings.t(context, 'clearAll')),
                  ),
              ],
            ),
          ),
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history, size: 64, color: AppColors.primary.withValues(alpha: 0.35)),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.t(context, 'emptyHistory'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.t(context, 'emptyHistorySub'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      return BmiHistoryTile(
                        entry: entry,
                        onDelete: () => context.read<BmiProvider>().deleteEntry(entry.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
