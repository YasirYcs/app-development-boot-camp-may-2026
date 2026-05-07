import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/hive_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final HiveService _hiveService;
  List<Expense> _expenses = [];
  double _budgetGoal = 2000.0;

  ExpenseProvider(this._hiveService);

  // Getters
  List<Expense> get expenses => _expenses;
  double get budgetGoal => _budgetGoal;

  // Initialize provider - load expenses and budget from database
  Future<void> initializeExpenses() async {
    _expenses = _hiveService.getAllExpenses();
    _budgetGoal = _hiveService.getBudgetGoal();
    notifyListeners();
  }

  // Update budget goal
  Future<void> setBudgetGoal(double goal) async {
    await _hiveService.setBudgetGoal(goal);
    _budgetGoal = goal;
    notifyListeners();
  }

  // Add new expense
  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
  }) async {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
    );

    await _hiveService.addExpense(expense);
    _expenses.add(expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    await _hiveService.deleteExpense(id);
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  // Update expense
  Future<void> updateExpense(Expense updatedExpense) async {
    await _hiveService.updateExpense(updatedExpense);
    final index = _expenses.indexWhere((e) => e.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  // Clear all expenses
  Future<void> clearAllExpenses() async {
    await _hiveService.clearAllExpenses();
    _expenses.clear();
    notifyListeners();
  }

  // Calculate total expenses
  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get this month's total expenses
  double getMonthlyTotal() {
    final now = DateTime.now();
    final currentMonth = _expenses.where(
      (e) => e.date.year == now.year && e.date.month == now.month,
    );
    return currentMonth.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get total spending by category
  double getTotalByCategory(ExpenseCategory category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get highest spending category
  ExpenseCategory? getHighestSpendingCategory() {
    if (_expenses.isEmpty) return null;

    double maxAmount = 0;
    ExpenseCategory? maxCategory;

    for (var category in ExpenseCategory.values) {
      final total = getTotalByCategory(category);
      if (total > maxAmount) {
        maxAmount = total;
        maxCategory = category;
      }
    }
    return maxCategory;
  }

  // Get recent expenses (last 5)
  List<Expense> getRecentExpenses({int limit = 5}) {
    return _expenses.take(limit).toList();
  }

  // Get today's total expenses
  double getTodayTotal() {
    final today = DateTime.now();
    final todayExpenses = _expenses.where(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );
    return todayExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get average daily spending this month
  double getAverageDailySpending() {
    final monthlyTotal = getMonthlyTotal();
    final now = DateTime.now();
    final daysInMonth = now.day;
    return daysInMonth > 0 ? monthlyTotal / daysInMonth : 0;
  }
}
