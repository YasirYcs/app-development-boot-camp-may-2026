import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/colors.dart';
import '../utils/spacing.dart';
import '../utils/text_styles.dart';
import '../utils/formatters.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expenseToEdit;
  const AddExpenseScreen({super.key, this.expenseToEdit});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late ExpenseCategory _selectedCategory;
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expenseToEdit?.title ?? '');
    _amountController = TextEditingController(
      text: widget.expenseToEdit != null ? widget.expenseToEdit!.amount.toString() : '',
    );
    _selectedCategory = widget.expenseToEdit?.category ?? ExpenseCategory.food;
    _selectedDate = widget.expenseToEdit?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Validate and save expense
  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      try {
        if (isEditing) {
          final updatedExpense = widget.expenseToEdit!.copyWith(
            title: title,
            amount: amount,
            category: _selectedCategory,
            date: _selectedDate,
          );
          await context.read<ExpenseProvider>().updateExpense(updatedExpense);
        } else {
          await context.read<ExpenseProvider>().addExpense(
            title: title,
            amount: amount,
            category: _selectedCategory,
            date: _selectedDate,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? 'Expense updated!' : 'Expense added!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );

          // Clear form if not editing (just in case)
          if (!isEditing) {
            _titleController.clear();
            _amountController.clear();
            setState(() {
              _selectedCategory = ExpenseCategory.food;
              _selectedDate = DateTime.now();
            });
          }

          // Navigate back after delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Error saving expense'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  // Open date picker
  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title input
              _buildInputLabel('Expense Title'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Lunch, Gas, Shopping',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.trim().length < 2) {
                    return 'Title must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Amount input
              _buildInputLabel('Amount'),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Category dropdown
              _buildInputLabel('Category'),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: DropdownButton<ExpenseCategory>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ExpenseCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Text(
                                category.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(category.label, style: AppTextStyles.body),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Date picker
              _buildInputLabel('Date'),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        AppFormatters.formatDateLong(_selectedDate),
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveExpense,
                  icon: Icon(isEditing ? Icons.save : Icons.check),
                  label: Text(isEditing ? 'Update Expense' : 'Add Expense'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),

              // Cancel button
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for input labels
  Widget _buildInputLabel(String label) {
    return Text(label, style: AppTextStyles.heading3);
  }
}
