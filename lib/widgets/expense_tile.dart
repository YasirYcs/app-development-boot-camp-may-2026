import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  IconData get categoryIcon {
    switch (expense.category) {
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

  @override
  Widget build(BuildContext context) {
    final noteText = expense.note.isEmpty ? expense.category : expense.note;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE0F2F1),
            child: Icon(
              categoryIcon,
              color: const Color(0xFF00897B),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noteText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2933),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '-\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2933),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}