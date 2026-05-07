import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'colors.dart';

class AppConstants {
  // Monthly budget goal
  static const double monthlyBudgetGoal = 2000.0;

  // Daily budget
  static const double dailyBudget = monthlyBudgetGoal / 30;

  // Default currency symbol
  static const String currencySymbol = '\$';

  // Currency name
  static const String currencyName = 'USD';

  // Map category to color
  static Color getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return AppColors.foodColor;
      case ExpenseCategory.transport:
        return AppColors.transportColor;
      case ExpenseCategory.shopping:
        return AppColors.shoppingColor;
      case ExpenseCategory.bills:
        return AppColors.billsColor;
      case ExpenseCategory.other:
        return AppColors.otherColor;
    }
  }

  // Map category to label
  static String getCategoryLabel(ExpenseCategory category) {
    return category.label;
  }

  // Get all categories as dropdown items
  static List<DropdownMenuItem<ExpenseCategory>> getCategoryDropdownItems() {
    return ExpenseCategory.values
        .map(
          (category) => DropdownMenuItem(
            value: category,
            child: Row(
              children: [
                Text(category.emoji),
                const SizedBox(width: 8),
                Text(category.label),
              ],
            ),
          ),
        )
        .toList();
  }
}
