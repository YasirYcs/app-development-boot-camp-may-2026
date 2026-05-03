import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final double monthlyBudget = 3000;

  final List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Grocery Store',
      amount: 64,
      category: 'Shopping',
      note: 'Groceries',
      date: DateTime.now(),
    ),
    Expense(
      id: '2',
      title: 'Coffee House',
      amount: 4.50,
      category: 'Food',
      note: 'Coffee',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: '3',
      title: 'Fuel Station',
      amount: 52.20,
      category: 'Travel',
      note: 'Fuel',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  double get totalExpense {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  double get dailyAverage {
    return totalExpense / 30;
  }

  double get budgetLeft {
    return monthlyBudget - totalExpense;
  }

  void addExpense(Expense expense) {
    setState(() {
      expenses.insert(0, expense);
      selectedIndex = 0;
    });
  }

  void deleteExpense(String id) {
    setState(() {
      expenses.removeWhere((expense) => expense.id == id);
    });
  }

  void openAddExpenseScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(onAddExpense: addExpense),
      ),
    );
  }

  double getCategoryTotal(String category) {
    return expenses
        .where((expense) => expense.category == category)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  Widget categoryCard({
    required IconData icon,
    required String title,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE0F2F1),
            child: Icon(icon, color: const Color(0xFF00897B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$title\n\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(height: 1.4, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHomePage() {
    final recentExpenses = expenses.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        title: const Text(
          'MExpense',
          style: TextStyle(
            color: Color(0xFF00897B),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
          SizedBox(width: 14),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SummaryCard(
            totalExpense: totalExpense,
            dailyAverage: dailyAverage,
            budgetLeft: budgetLeft,
          ),
          const SizedBox(height: 18),
          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.4,
            children: [
              categoryCard(
                icon: Icons.restaurant,
                title: 'Food',
                amount: getCategoryTotal('Food'),
              ),
              categoryCard(
                icon: Icons.flight,
                title: 'Travel',
                amount: getCategoryTotal('Travel'),
              ),
              categoryCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Shopping',
                amount: getCategoryTotal('Shopping'),
              ),
              categoryCard(
                icon: Icons.receipt_long,
                title: 'Bills',
                amount: getCategoryTotal('Bills'),
              ),
              categoryCard(
                icon: Icons.category_outlined,
                title: 'Other',
                amount: getCategoryTotal('Other'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Recent expenses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (recentExpenses.isEmpty)
            const Center(child: Text('No expenses added yet'))
          else
            ...recentExpenses.map(
                  (expense) => ExpenseTile(
                expense: expense,
                onDelete: () => deleteExpense(expense.id),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHomePage(),
      const SizedBox(),
      HistoryScreen(
        expenses: expenses,
        onDeleteExpense: deleteExpense,
      ),
    ];

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            openAddExpenseScreen();
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}