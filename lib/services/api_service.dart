import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/todo_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com'; // Fetch base URL from .env file else use another

  static Future<List<User>> fetchUsers() async {
    log("inside fetch user in api");
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print(data);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<Todo>> fetchTodos(int userId) async {
    log("fetch todo");
    final response = await http.get(Uri.parse('$baseUrl/todos?userId=$userId'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
