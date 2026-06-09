import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';

class MenuService {
  // Pointing to the deployed cloud backend
  //  static const String apiUrl = 'http://43.133.144.212:1234/api/menu'; this is the old one thatc onnects to mr ones api
<<<<<<< HEAD
  static const String apiUrl = 'http://localhost:3000/api/menu';
=======
  static const String apiUrl = 'http://35.231.52.200:3000/api/menu';
>>>>>>> b6bad7f5cb3e13185474a83bb55ce06c97ee279c

  static Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // The API returns a direct JSON array, so decode it
        final dynamic decodedResponse = json.decode(response.body);
        
        List<dynamic> jsonList;

        // Handle both array and object responses
        if (decodedResponse is List) {
          // If it's already a list, use it directly
          jsonList = decodedResponse;
        } else if (decodedResponse is Map<String, dynamic>) {
          // If it's an object, try to extract the array from common keys
          jsonList = decodedResponse['data'] ?? 
                     decodedResponse['items'] ?? 
                     decodedResponse['menu'] ?? 
                     [];
        } else {
          throw Exception('Unexpected JSON format');
        }

        // Map the extracted list into MenuItem objects
        return jsonList.map((data) => MenuItem.fromJson(data)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the database API: $e');
    }
  }
}