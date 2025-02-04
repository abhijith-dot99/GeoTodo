import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isOffline = false;
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading; 


 // Fetches users either from the API or from local cache
  Future<void> fetchUsers() async { //
    log("inside eftch users in prvoider");
    try {
      _users = await ApiService.fetchUsers();
      saveUsersLocally();
      _isOffline = false;
    } catch (e) {
      await loadUsersFromCache();
      _isOffline = true;
    }
    notifyListeners();// Notify listeners of the state change
  }


// Saves the list of users locally in SharedPreferences
  Future<void> saveUsersLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userList = _users
        .map((user) => jsonEncode({
              'id': user.id,
              'name': user.name,
              'email': user.email,
              'lat': user.lat,
              'lng': user.lng,
              'phone': user.phone
            }))
        .toList();
    log("userList$userList");
    prefs.setStringList('users', userList);
  }

  // Loads users from local cache if offline or if API fetch fails
  Future<void> loadUsersFromCache() async {
    log("load from cache");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('users');
    if (userList != null) {
      _users = userList.map((user) {
        var jsonData = jsonDecode(user);
        return User(
          id: jsonData['id'],
          name: jsonData['name'],
          email: jsonData['email'],
          lat: jsonData['lat'],
          lng: jsonData['lng'],
          phone: jsonData['phone'],
        );
      }).toList();
    }
  }
}
