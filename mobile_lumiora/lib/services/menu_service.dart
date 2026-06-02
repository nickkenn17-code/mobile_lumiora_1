import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';

class MenuService {
  // If using Android Emulator, use 10.0.2.2. 
  // If using iOS Simulator or Web, use localhost.
  static const String apiUrl = 'http://10.0.2.2:3000/api/menu'; 

  static Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the live JSON from your Node.js API
        List<dynamic> jsonResponse = json.decode(response.body);
        
        // Map it into our Dart objects
        return jsonResponse.map((data) => MenuItem.fromJson(data)).toList();
      } else {
        throw Exception('Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      // If it fails, fallback to the dummy data so the UI doesn't break
      return dummyMenu; 
    }
  }
}