import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;
  List<Expense> _cache = [];

  ExpenseBloc(this.repository) : super(ExpenseLoading()) {
    on<LoadExpenses>((event, emit) async {
      emit(ExpenseLoading());
      try {
        _cache = await repository.getExpenses();
        emit(ExpenseLoaded(_cache));
      } catch (e) { emit(ExpenseError("Failed to sync with server")); }
    });

    on<AddExpenseEvent>((event, emit) {
      final newExp = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title, amount: event.amount, category: event.category, date: DateTime.now()
      );
      _cache.insert(0, newExp);
      emit(ExpenseLoaded(List.from(_cache)));
      repository.addExpense(newExp);
    });

    on<EditExpenseEvent>((event, emit) {
      final index = _cache.indexWhere((e) => e.id == event.expense.id);
      if (index != -1) {
        _cache[index] = event.expense;
        emit(ExpenseLoaded(List.from(_cache)));
        repository.updateExpense(event.expense);
      }
    });

    on<RemoveExpenseEvent>((event, emit) {
      _cache.removeWhere((e) => e.id == event.id);
      emit(ExpenseLoaded(List.from(_cache)));
      repository.deleteExpense(event.id);
    });
  }
}