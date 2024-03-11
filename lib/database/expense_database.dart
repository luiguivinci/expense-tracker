import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  // S E T  U P
  // {
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }
  // }

  // G E T T E R S
  // {

  List<Expense> get allExpense => _allExpenses;

  // }

  // O P E R A T I O N S
  // {

  // CREATE - add new expense
  Future<void> createNewExpense(Expense newExpense) async {
    // add new expense to db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    // re-read from db
    await readExpenses();
  }

  // READ - add new expense
  Future<void> readExpenses() async {
    // fetch all expenses from db
    List<Expense> fetchExpenses = await isar.expenses.where().findAll();

    // give to local expenses list
    _allExpenses.clear();
    _allExpenses.addAll(fetchExpenses);

    // update ui
    notifyListeners();
  }

  // UPDATE - edit an expense on db
  Future<void> updateExpenses(int id, Expense updatedExpense) async {
    // find expense in db
    updatedExpense.id;

    // update in db
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    // re-read from db
    await readExpenses();
  }

  // DELETE - remove an expense from db
  Future<void> deleteExpense(int id) async {
    // delete from db
    await isar.writeTxn(() => isar.expenses.delete(id));

    // re-read from db
    await readExpenses();
  }

  // }
}
