import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/index.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final monthlyTotal = provider.getMonthlyTotal();
    final highestCategory = provider.getHighestSpendingCategory();
    final avgDaily = provider.getAverageDailySpending();
    
    // Calculate dynamic daily goal based on the user-set monthly budget
    final dailyGoal = provider.budgetGoal / 30;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistics', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.md),

          // 1. MONTHLY SUMMARY CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: Column(
              children: [
                Text(
                  'This Month Total',
                  style: AppTextStyles.label.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  AppFormatters.formatCurrency(monthlyTotal),
                  style: AppTextStyles.heading1.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 2. DAILY BUDGET INFO
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.analytics_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Average', style: AppTextStyles.label),
                        Text(
                          AppFormatters.formatCurrency(avgDaily),
                          style: AppTextStyles.heading3,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Daily Limit', style: AppTextStyles.label),
                      Text(
                        AppFormatters.formatCurrency(dailyGoal),
                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 3. HIGHEST SPENDING CATEGORY
          if (highestCategory != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.error),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Highest Spending: ',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      '${highestCategory.emoji} ${highestCategory.label}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.getCategoryColor(highestCategory),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.xl),

          // 4. CATEGORY BREAKDOWN
          Text('Category Breakdown', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.md),

          ...ExpenseCategory.values.map((category) {
            final categoryTotal = provider.getTotalByCategory(category);
            final percentage = monthlyTotal > 0 ? categoryTotal / monthlyTotal : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(category.emoji),
                          const SizedBox(width: 8),
                          Text(category.label, style: AppTextStyles.bodySmall),
                        ],
                      ),
                      Text(
                        AppFormatters.formatCurrency(categoryTotal),
                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: AppColors.borderLight,
                      color: AppConstants.getCategoryColor(category),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(percentage * 100).toStringAsFixed(1)}%',
                      style: AppTextStyles.label.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            );
          }),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
