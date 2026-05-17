import 'package:dio/dio.dart';
import '../models/expense.dart';

class ExpenseRepository {
  // Initialize Dio with the base URL for the public API
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://api.restful-api.dev/objects",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // READ (GET)
  Future<List<Expense>> getExpenses() async {
    try {
      final response = await _dio.get('');
      // Filter out items that don't have the necessary custom data fields
      return (response.data as List)
          .where((item) => item['data'] != null && item['data']['amount'] != null)
          .map((item) => Expense.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch expenses: $e");
    }
  }

  // CREATE (POST)
  Future<void> addExpense(Expense expense) async {
    await _dio.post('', data: expense.toJson());
  }

  // UPDATE (PUT)
  // UPDATE (PUT) - Add this after your addExpense method
  Future<void> updateExpense(Expense expense) async {
    try {
      await _dio.put('/${expense.id}', data: expense.toJson());
    } catch (e) {
      throw Exception("Failed to update expense: $e");
    }
  }

  // DELETE (DELETE) - Add this at the very end of the class
  Future<void> deleteExpense(String id) async {
    try {
      await _dio.delete('/$id');
    } catch (e) {
      throw Exception("Failed to delete expense: $e");
    }
  }
} // End of class