import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAddExpense;

  const AddExpenseScreen({
    super.key,
    required this.onAddExpense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();

  final categories = ['Food', 'Travel', 'Shopping', 'Bills', 'Other'];

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Travel':
        return Icons.flight;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Bills':
        return Icons.receipt_long;
      default:
        return Icons.category_outlined;
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveExpense() {
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final note = noteController.text.trim();

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: note.isEmpty ? selectedCategory : note,
      amount: amount,
      category: selectedCategory,
      note: note,
      date: selectedDate,
    );

    widget.onAddExpense(expense);
    Navigator.pop(context);
  }

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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Expense',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2933),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Keep your finances in balance.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  prefixText: '\$ ',
                  hintText: '0.00',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'CATEGORY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((category) {
                final isSelected = category == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00796B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          getCategoryIcon(category),
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: pickDate,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE0F2F1),
                          child: Icon(Icons.calendar_today, color: Color(0xFF00897B)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Transaction Date\n${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFE0F2F1),
                        child: Icon(Icons.notes, color: Color(0xFF00897B)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: noteController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            hintText: 'What was this for?',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Save Expense',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}