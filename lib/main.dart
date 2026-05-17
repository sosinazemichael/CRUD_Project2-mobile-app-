import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/expense_repository.dart';
import 'bloc/expense_bloc.dart';
import 'bloc/expense_event.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // Provides the Dio-based repository to the entire app
      create: (context) => ExpenseRepository(),
      child: BlocProvider(
        // Initializes the Bloc and immediately triggers the LoadExpenses event
        create: (context) => ExpenseBloc(
          context.read<ExpenseRepository>(),
        )..add(LoadExpenses()),
        child: MaterialApp(
          // Removes the red 'DEBUG' banner from the top-right corner
          debugShowCheckedModeBanner: false,
          
          title: 'Expense Tracker',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            useMaterial3: true,
          ),
          // Removed 'const' to prevent Hot Reload errors with dynamic content
          home: HomeScreen(), 
        ),
      ),
    );
  }
}