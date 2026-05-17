import '../models/expense.dart';

abstract class ExpenseState {}
class ExpenseLoading extends ExpenseState {}
class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double totalBalance;
  ExpenseLoaded(this.expenses) : totalBalance = expenses.fold(0, (sum, item) => sum + item.amount);
}
class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}