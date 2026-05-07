// Define expense categories
enum ExpenseCategory {
  food('Food', '🍕'),
  transport('Transport', '🚗'),
  shopping('Shopping', '🛒'),
  bills('Bills', '📄'),
  other('Other', '📌');

  final String label;
  final String emoji;

  const ExpenseCategory(this.label, this.emoji);
}

// Main Expense model
class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Convert Expense to Map (for Hive storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
    };
  }

  // Create Expense from Map (when loading from Hive)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: ExpenseCategory.values.firstWhere(
        (cat) => cat.name == map['category'],
      ),
      date: DateTime.parse(map['date']),
    );
  }

  // Create a copy with some fields changed (useful for updates)
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}
