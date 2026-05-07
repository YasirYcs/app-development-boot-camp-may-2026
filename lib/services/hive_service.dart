import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class HiveService {
  static const String expenseBoxName = 'expenses';
  static const String settingsBoxName = 'settings';
  static const String budgetKey = 'monthlyBudget';

  late Box<Map> _expenseBox;
  late Box _settingsBox;

  // Initialize Hive
  Future<void> initHive() async {
    await Hive.initFlutter();
    _expenseBox = await Hive.openBox<Map>(expenseBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);
  }

  // Budget Goal Methods
  double getBudgetGoal() {
    return _settingsBox.get(budgetKey, defaultValue: 2000.0);
  }

  Future<void> setBudgetGoal(double goal) async {
    await _settingsBox.put(budgetKey, goal);
  }

  // Save a new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense.toMap());
  }

  // Get all expenses
  List<Expense> getAllExpenses() {
    final List<Expense> expenses = [];
    for (var value in _expenseBox.values) {
      expenses.add(Expense.fromMap(Map<String, dynamic>.from(value)));
    }
    // Sort by date (newest first)
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  // Update an expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense.toMap());
  }

  // Clear all expenses
  Future<void> clearAllExpenses() async {
    await _expenseBox.clear();
  }

  // Get expense by ID
  Expense? getExpenseById(String id) {
    final data = _expenseBox.get(id);
    if (data == null) return null;
    return Expense.fromMap(Map<String, dynamic>.from(data));
  }
}
