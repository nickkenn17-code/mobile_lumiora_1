import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';

class MenuService {
  // Pointing to the deployed cloud backend
  static const String apiUrl = 'http://35.254.206.12:3000/api/menu';

  static Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // 1. Decode the response into a dynamic variable
        final dynamic decodedResponse = json.decode(response.body);
        
        List<dynamic> jsonList;

        // 2. Check the structure: is it a Map (Object) or a List (Array)?
        if (decodedResponse is Map<String, dynamic>) {
          // If it is a Map, extract the array hiding inside the 'data' key
          jsonList = decodedResponse['data'] ?? 
                     decodedResponse['items'] ?? 
                     decodedResponse['menu'] ?? 
                     [];
        } else if (decodedResponse is List) {
          // If it's already a raw list, use it directly
          jsonList = decodedResponse;
        } else {
          throw Exception('Unexpected JSON format');
        }

        // 3. Map the extracted list into your Dart objects
        return jsonList.map((data) => MenuItem.fromJson(data)).toList();
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