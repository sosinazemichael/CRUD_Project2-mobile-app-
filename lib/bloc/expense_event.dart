import '../models/expense.dart';

abstract class ExpenseEvent {}
class LoadExpenses extends ExpenseEvent {}
class AddExpenseEvent extends ExpenseEvent {
  final String title; final double amount; final String category;
  AddExpenseEvent(this.title, this.amount, this.category);
}
class EditExpenseEvent extends ExpenseEvent {
  final Expense expense;
  EditExpenseEvent(this.expense);
}
class RemoveExpenseEvent extends ExpenseEvent {
  final String id;
  RemoveExpenseEvent(this.id);
}