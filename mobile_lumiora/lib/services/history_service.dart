// localllllllllll
import '../services/cart_service.dart';

class OrderRecord {
  final String orderId;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final String status;

  OrderRecord({
    required this.orderId,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });
}

class HistoryService {
  // Stores all completed orders locally
  static List<OrderRecord> pastOrders = [];

  static void recordOrder(List<CartItem> purchasedItems) {
    // Calculate the exact total of the purchased items
    double orderTotal = purchasedItems.fold(
      0, (sum, item) => sum + (item.item.price * item.qty)
    );

    final newOrder = OrderRecord(
      // Generate a quick random ID for the UI
      orderId: 'LUM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      date: DateTime.now(),
      items: List.from(purchasedItems),
      total: orderTotal,
      status: 'Completed',
    );
    
    // Insert at the top so the newest orders appear first
    pastOrders.insert(0, newOrder);
  }
}