import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/todo_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
   // Base URL fetched from the .env file, or defaults to the provided placeholder URL
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com'; 

  // Method to fetch a list of users from the API
  static Future<List<User>> fetchUsers() async {
    log("inside fetch user in api");
    // Sending GET request to the API to fetch users
    final response = await http.get(Uri.parse('$baseUrl/users'));
        // If the response is successful (status code 200)
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      print(data);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Method to fetch todos for a specific user by their userId
  static Future<List<Todo>> fetchTodos(int userId) async {
    log("fetch todo");
    // Sending GET request to the API to fetch todos
    final response = await http.get(Uri.parse('$baseUrl/todos?userId=$userId'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
