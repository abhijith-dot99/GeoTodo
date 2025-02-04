
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;
  bool _isOffline = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

  // Fetches todo either from the API or from local cache
  Future<void> fetchTodos(int userId) async {
    log("Fetching todos for user: $userId");
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await ApiService.fetchTodos(userId);
      await saveTodosLocally(userId);
      _isOffline = false;
    } catch (e) {
      log("Error fetching todos: $e");
      await loadTodosFromCache(userId);
      _isOffline = true;
    }

    _isLoading = false;
    notifyListeners();
  }

 // Saves the list of todo locally in SharedPreferences
  Future<void> saveTodosLocally(int userId) async {
    log("Saving todos locally for user: $userId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoList = _todos
        .map((todo) => jsonEncode({
              'id': todo.id,
              'userId': todo.userId,
              'title': todo.title,
              'completed': todo.completed,
            }))
        .toList();
    prefs.setStringList('todos_$userId', todoList);
  }

  // Loads todo from local cache if offline or if API fetch fails
  Future<void> loadTodosFromCache(int userId) async {
    log("Loading todos from cache for user: $userId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoList = prefs.getStringList('todos_$userId');

    if (todoList != null) {
      _todos = todoList.map((todo) {
        var jsonData = jsonDecode(todo);
        return Todo(
          id: jsonData['id'],
          userId: jsonData['userId'],
          title: jsonData['title'],
          completed: jsonData['completed'],
        );
      }).toList();
    }
  }
}
