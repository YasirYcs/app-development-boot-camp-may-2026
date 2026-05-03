import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double totalExpense;
  final double dailyAverage;
  final double budgetLeft;

  const SummaryCard({
    super.key,
    required this.totalExpense,
    required this.dailyAverage,
    required this.budgetLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF57C6B8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Monthly Expense',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${totalExpense.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF21413D),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SmallSummary(
                    title: 'Daily Average',
                    value: '\$${dailyAverage.toStringAsFixed(2)}',
                  ),
                ),
                Expanded(
                  child: _SmallSummary(
                    title: 'Budget Left',
                    value: '\$${budgetLeft.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallSummary extends StatelessWidget {
  final String title;
  final String value;

  const _SmallSummary({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF21413D),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}