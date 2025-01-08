import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  List<Map<String, dynamic>> cards = [];
  String? _userToken;
  String? _userName;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();
  // Manejo de tarjetas
  void addCard(Map<String, dynamic> card) {
    cards.add(card);
    saveCardsToStorage();
  }

  Future<void> loadCardsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? cardsString = prefs.getString('cards');
    if (cardsString != null) {
      List<dynamic> decodedList = json.decode(cardsString);
      cards = decodedList.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
    }
  }

  Future<void> saveCardsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cards', json.encode(cards));
  }

  void clearCards() {
    cards.clear();
    saveCardsToStorage();
  }


  // Manejo de gastos
  void addExpense(Map<String, dynamic> expense) {
    expenses.add(expense);
    saveExpensesToStorage();
  }

  void addIncome(Map<String, dynamic> income) {
    incomes.add(income);
    saveIncomesToStorage();
  }

  Future<void> loadExpensesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? expensesString = prefs.getString('expenses');
    if (expensesString != null) {
      List<dynamic> decodedList = json.decode(expensesString);
      expenses = decodedList.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
    }
  }

  Future<void> saveExpensesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('expenses', json.encode(expenses));
  }

  void saveExpenses() {
    saveExpensesToStorage(); // Alias para saveExpensesToStorage
  }

  Future<void> loadIncomesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    String? incomesString = prefs.getString('incomes');
    if (incomesString != null) {
      List<dynamic> decodedList = json.decode(incomesString);
      incomes = decodedList.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
    }
  }

  Future<void> saveIncomesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('incomes', json.encode(incomes));
  }

  void clearData() {
    expenses.clear();
    incomes.clear();
    saveExpensesToStorage();
    saveIncomesToStorage();
  }

  Future<void> clearAllData() async {
    expenses.clear();
    incomes.clear();
    await saveExpensesToStorage();
    await saveIncomesToStorage();
  }

  // Manejo del token y nombre de usuario
  Future<void> setUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
    _userToken = token;
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  Future<void> loadUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('userToken');
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
  }

  String? getUserToken() {
    return _userToken;
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }


  Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
  }

  Future<void> clearUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    _userToken = null;
  }
}
