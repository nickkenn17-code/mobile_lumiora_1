import 'package:flutter/material.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Color pageBg = const Color(0xFFF2EEE6);
  final Color olive = const Color(0xFFA3B04A);
  final Color oliveDark = const Color(0xFF8E9B3A);
  final Color cardBorder = const Color(0xFFD6C9B8);

  @override
  Widget build(BuildContext context) {
    final orders = HistoryService.pastOrders;

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Text(
                        'No past orders found.',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(orders[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cardBorder),
              color: const Color(0xFFF8F4EC),
            ),
            child: const Center(
              child: Text(
                'L',
                style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFB18A49)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Order History',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202020),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderRecord order) {
    // Format the date simply (e.g., 2026-06-02)
    final dateStr = "${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder.withOpacity(0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.orderId}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF262626),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: olive.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: oliveDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dateStr,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          const Divider(height: 24, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.items.length} Items',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rp ${order.total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: oliveDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Identical Bottom Navigation from your Menu Screen
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F3EA),
        border: Border(top: BorderSide(color: Color(0xFFD8CAB6), width: 1)),
      ),
      child: SizedBox(
        height: 74,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, 'Home', false, () => Navigator.popUntil(context, (route) => route.isFirst)),
                _navItem(Icons.coffee_outlined, 'Menu', false, () => Navigator.pop(context)),
                const SizedBox(width: 64),
                _navItem(Icons.receipt_long_outlined, 'History', true, () {}),
                _navItem(Icons.person_outline, 'Profile', false, () {}),
              ],
            ),
            Positioned(
              top: -20,
              child: Column(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: olive,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: olive.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Icon(Icons.qr_code_2, color: Colors.white, size: 22),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'SCAN QR',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Color(0xFF616161)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: active ? oliveDark : const Color(0xFF7C7C7C)),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? oliveDark : const Color(0xFF7C7C7C),
            ),
          ),
        ],
      ),
    );
  }
}