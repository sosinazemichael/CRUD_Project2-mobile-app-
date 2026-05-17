import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/expense_bloc.dart';
import '../../bloc/expense_event.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;
  const ExpenseForm({Key? key, this.expense}) : super(key: key);
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final List<String> categories = ["Food", "Education", "Transportation", "Entertainment", "Shopping", "Other"];
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense?.title ?? "");
    _amountController = TextEditingController(text: widget.expense?.amount.toString() ?? "");
    _selectedCategory = widget.expense?.category ?? categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _titleController, decoration: InputDecoration(labelText: "Title")),
          TextField(controller: _amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ),
          ElevatedButton(
            onPressed: () {
              final bloc = context.read<ExpenseBloc>();
              if (widget.expense == null) {
                bloc.add(AddExpenseEvent(_titleController.text, double.parse(_amountController.text), _selectedCategory));
              } else {
                bloc.add(EditExpenseEvent(Expense(id: widget.expense!.id, title: _titleController.text, amount: double.parse(_amountController.text), category: _selectedCategory, date: widget.expense!.date)));
              }
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}