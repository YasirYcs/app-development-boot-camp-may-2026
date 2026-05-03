class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });
}