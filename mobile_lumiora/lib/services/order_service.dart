import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'cart_service.dart';

class OrderService {
  // Pointing to your cloud VM Node.js backend
  static const String apiUrl = 'http://35.254.206.12:3000/api/orders';

  static Future<bool> placeOrder(List<CartItem> items, double totalAmount, String notes) async {
    try {
      final auth = AuthService();
      
      // Constructing the customer object. 
      // If the user isn't logged in, we use guest details.
      final customer = {
        'email': auth.username != null ? '${auth.username}@lumiora.com' : 'guest@lumiora.com',
        'phone': auth.phone ?? '000000000',
        'firstName': auth.username ?? 'Guest',
        'lastName': ''
      };

      // Constructing the items array
      final itemsData = items.map((cartItem) {
        // The Django database expects an Integer ID for the menu item.
        // If the ID from the API is "m1", this strips the "m" and returns 1.
        // If it's already "1", it just returns 1.
        final String idString = cartItem.item.id.replaceAll(RegExp(r'[^0-9]'), '');
        final int parsedId = int.tryParse(idString) ?? 1;

        return {
          'menu_item_id': parsedId,
          'qty': cartItem.qty,
          'price': cartItem.item.price,
        };
      }).toList();

      final body = {
        'customer': customer,
        'items': itemsData,
        'totalAmount': totalAmount,
        'notes': notes,
      };

      print('Sending order to $apiUrl: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Order placed successfully!');
        return true;
      } else {
        print('Failed to place order: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }
}
