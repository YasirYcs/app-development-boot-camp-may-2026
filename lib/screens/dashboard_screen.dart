import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/index.dart';
import '../widgets/expense_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final monthlyTotal = provider.getMonthlyTotal();
    final monthlyGoal = provider.budgetGoal;
    final progress = (monthlyGoal <= 0)
        ? 0.0
        : (monthlyTotal / monthlyGoal).clamp(0.0, 1.0);
    final recent = provider.getRecentExpenses(limit: 6);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly total card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('This Month', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Text(
                        AppFormatters.formatCurrency(monthlyTotal),
                        style: AppTextStyles.heading2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppFormatters.formatMonthYear(DateTime.now())}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  // Goal / progress
                  GestureDetector(
                    onTap: () => _showEditBudgetDialog(context, provider),
                    child: SizedBox(
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Goal', style: AppTextStyles.label),
                              const SizedBox(width: 4),
                              const Icon(Icons.edit, size: 12, color: AppColors.textSecondary),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppFormatters.formatCurrency(monthlyGoal),
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            color: progress >= 1.0 ? AppColors.error : AppColors.primary,
                            backgroundColor: AppColors.borderLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Budget alert card
          if (monthlyTotal >= monthlyGoal)
            Card(
              color: AppColors.error.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.error),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'You have reached or exceeded your monthly budget. Consider reviewing expenses.',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.lg),

          // Recent expenses header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Expenses', style: AppTextStyles.heading2),
              TextButton(onPressed: () {}, child: const Text('View all')),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Recent expenses list
          if (recent.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'No expenses yet. Add your first expense!',
                  style: AppTextStyles.bodySmall,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final e = recent[index];
                return ExpenseCard(expense: e);
              },
            ),

          const SizedBox(height: AppSpacing.lg),

          // Quick stats row
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Text('Today', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Text(
                          AppFormatters.formatCurrency(
                            provider.getTodayTotal(),
                          ),
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Avg/day ${AppFormatters.formatCurrency(provider.getAverageDailySpending())}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Text('Highest', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Text(
                          provider.getHighestSpendingCategory()?.label ?? '-',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 6),
                        Text('By category', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context, ExpenseProvider provider) {
    final controller = TextEditingController(text: provider.budgetGoal.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Budget Goal',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = double.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                provider.setBudgetGoal(newGoal);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
