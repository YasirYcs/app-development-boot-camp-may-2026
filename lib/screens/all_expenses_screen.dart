import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/index.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';

class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expenses = provider.expenses;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Expenses'),
        elevation: 0,
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                'No expenses recorded yet',
                style: AppTextStyles.bodySmall,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: expenses.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Dismissible(
                  key: Key(expense.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    provider.deleteExpense(expense.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Expense deleted')),
                    );
                  },
                  child: ExpenseCard(
                    expense: expense,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExpenseScreen(expenseToEdit: expense),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
