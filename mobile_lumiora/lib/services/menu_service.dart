import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';

class MenuService {
  // Remember: 10.0.2.2 is for Android Emulator. Use localhost for iOS/Web.
  static const String apiUrl = 'http://localhost:3000/api/menu';

  static Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the live JSON from your Node.js API
        List<dynamic> jsonResponse = json.decode(response.body);
        
        // Map it into our Dart objects
        return jsonResponse.map((data) => MenuItem.fromJson(data)).toList();
      } else {
        // If the server connects but throws an error (like a 404 or 500)
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // If the app cannot reach the server at all, throw an error to the UI
      throw Exception('Failed to connect to the database API: $e');
    }
  }
}