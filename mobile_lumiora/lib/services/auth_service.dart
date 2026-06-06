import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  String? _username;
  String? _phone;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get phone => _phone;

  /// Attempt to log in with username, phone, and password
  Future<bool> login(String username, String phone, String password) async {
    try {
      // ==========================================
      // BYPASS LOGIN FOR DEMO
      // ==========================================
      // Automatically allow login for this specific user
      if (username == 'Xeno' && password == '1234') {
        _username = username;
        _phone = phone; // Uses the phone number typed in the form
        _isLoggedIn = true;
        return true;
      }
      // ==========================================

      const String apiHost = '35.254.206.12';
      final uri = Uri.parse('http://$apiHost:3000/api/login');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'phone': phone, 'password': password}),
      );

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        if (body['success'] == true) {
          _username = username;
          _phone = phone;
          _isLoggedIn = true;
          return true;
        }
      }

      return false;
    } catch (e) {
      print('AuthService login error: $e');
      return false;
    }
  }

  /// Log out the user
  void logout() {
    _username = null;
    _phone = null;
    _isLoggedIn = false;
  }
}