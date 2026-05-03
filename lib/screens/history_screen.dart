import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';

class HistoryScreen extends StatelessWidget {
  final List<Expense> expenses;
  final Function(String) onDeleteExpense;

  const HistoryScreen({
    super.key,
    required this.expenses,
    required this.onDeleteExpense,
  });

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense history',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2933),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your spending across all categories',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: expenses.isEmpty
                  ? const Center(child: Text('No expense history yet'))
                  : ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  return ExpenseTile(
                    expense: expense,
                    onDelete: () => onDeleteExpense(expense.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}