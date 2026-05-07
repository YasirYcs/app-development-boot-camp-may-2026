import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/index.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppConstants.getCategoryColor(expense.category).withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Center(
            child: Text(
              expense.category.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          expense.title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          AppFormatters.formatDateRelative(expense.date),
          style: AppTextStyles.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppFormatters.formatCurrency(expense.amount),
              style: AppTextStyles.amount.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            Text(
              expense.category.label,
              style: AppTextStyles.label.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
