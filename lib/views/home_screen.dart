import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';
import '../bloc/expense_event.dart';
import 'widgets/expense_form.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Centers the title text
        centerTitle: true, 
        title: const Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // FlexibleSpace allows us to use a Gradient background
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // These colors create a fancy sophisticated blend
              colors: [Color(0xFF4A2C2C), Color(0xFFA6867B)], 
            ),
          ),
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) return const Center(child: CircularProgressIndicator());
          
          if (state is ExpenseLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "TOTAL BALANCE",
                          style: TextStyle(
                            color: Color(0xFFA6867B),
                            letterSpacing: 2,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${state.totalBalance.toStringAsFixed(2)} Birr",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2C2C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: state.expenses.length,
                    itemBuilder: (context, i) => Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        title: Text(state.expenses[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(state.expenses[i].category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${state.expenses[i].amount} Birr",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue), 
                              onPressed: () => showModalBottomSheet(
                                context: context, 
                                isScrollControlled: true, 
                                builder: (_) => ExpenseForm(expense: state.expenses[i])
                              )
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red), 
                              onPressed: () => context.read<ExpenseBloc>().add(RemoveExpenseEvent(state.expenses[i].id))
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Error loading data"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFA6867B),
        onPressed: () => showModalBottomSheet(
          context: context, 
          isScrollControlled: true, 
          builder: (_) => const ExpenseForm()
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}