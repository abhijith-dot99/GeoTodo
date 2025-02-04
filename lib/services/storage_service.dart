import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/todo_model.dart';

class StorageService {
  // Keys to store users and todos in SharedPreferences
  static const String usersKey = 'users';
  static const String todosKey = 'todos';

// Method to save users to SharedPreferences
  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(usersKey, jsonEncode(users));
  }

  // Method to retrieve users from SharedPreferences
  Future<List<User>> getUsers() async {
    log("inside getuser offline");
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(usersKey);
    if (data != null) {
      List<dynamic> json = jsonDecode(data);
      return json.map((user) => User.fromJson(user)).toList();
    }
    return [];
  }

 // Method to save todos to SharedPreferences
  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(todosKey, jsonEncode(todos));
  }

  // Method to retrieve todos from SharedPreferences
  Future<List<Todo>> getTodos() async {
    log("inside gettodo offline");
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(todosKey);
    if (data != null) {
      List<dynamic> json = jsonDecode(data);
      return json.map((todo) => Todo.fromJson(todo)).toList();
    }
    return [];
  }
}
