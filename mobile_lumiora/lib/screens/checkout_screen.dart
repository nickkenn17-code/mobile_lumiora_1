import 'package:flutter/material.dart';
import '../services/cart_service.dart';


class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedItems;
  
  const CheckoutScreen({Key? key, required this.selectedItems}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Color pageBg = const Color(0xFFF4EFE5);
  final Color cardBg = const Color(0xFFF8F4EA);
  final Color cardBorder = const Color(0xFFD8CDBA);
  final Color olive = const Color(0xFFA3B04A);
  final Color oliveDark = const Color(0xFF8D9937);

  String selectedTime = '08:00 AM';
  final List<String> pickupTimes = [
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
  ];

  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  late List<CartItem> _itemsToCheckout;

  @override
  void initState() {
    super.initState();
    _itemsToCheckout = List.from(widget.selectedItems);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _removeItem(CartItem item) {
    setState(() {
      _itemsToCheckout.remove(item);
      // Optional: remove from CartService as well
      CartService.cart.remove(item);
    });
  }

  double _getSubtotal() {
    return _itemsToCheckout.fold(0, (total, item) => total + (item.item.price * item.qty));
  }

  int _getEarnedStamps() {
    return (_getSubtotal() ~/ 10000);
  }

  double _getTaxAndService() {
    return _getSubtotal() * 0.1; // 10% tax + service
  }

  double _getTotal() {
    return _getSubtotal() + _getTaxAndService(); // Minus discounts if any
  }

  void _processCheckout() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate backend processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      // Navigate to QR payment screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QRPaymentScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF252525)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF252525),
          ),
        ),
        centerTitle: true,
      ),
      body: _itemsToCheckout.isEmpty
          ? Center(
              child: Text(
                'No items to checkout.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            )
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _buildPickupDetails(),
                    const SizedBox(height: 16),
                    _buildOrderSummary(),
                    const SizedBox(height: 16),
                    _buildCustomerNotes(),
                    const SizedBox(height: 16),
                    _buildLoyaltyStamps(),
                    const SizedBox(height: 16),
                    _buildPaymentMethod(),
                    const SizedBox(height: 16),
                    _buildPaymentBreakdown(),
                    const SizedBox(height: 100), // padding for checkout button
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomCheckoutPanel(),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA3B04A)),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF252525),
        ),
      ),
    );
  }

  Widget _buildPickupDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pickup Details'),
          Row(
            children: [
              Icon(Icons.location_on, color: oliveDark, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'UNIJI Building, Lobby Floor',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, color: oliveDark, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Pickup Time:',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: cardBorder),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedTime,
                    items: pickupTimes.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(
                          time,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTime = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Order Summary'),
        ..._itemsToCheckout.map((item) {
          return Dismissible(
            key: Key('${item.item.id}_${item.qty}_${DateTime.now().millisecondsSinceEpoch}'),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeItem(item);
            },
            background: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 40,
                      height: 40,
                      color: const Color(0xFFE6D2B1),
                      child: Image.asset(
                        item.item.imagePlaceholder,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.local_cafe, color: Colors.white, size: 20);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.item.name,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.qty}x • Rp ${item.item.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Rp ${(item.item.price * item.qty).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: oliveDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCustomerNotes() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Customer Notes'),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'e.g., Less ice, extra espresso...',
              hintStyle: const TextStyle(fontSize: 12, fontFamily: 'Montserrat'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: oliveDark),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyStamps() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber[600], size: 28),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Loyalty & Rewards',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '+${_getEarnedStamps()} Stamps',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: oliveDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Payment Method'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cardBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code_scanner, color: oliveDark),
                const SizedBox(width: 10),
                const Text(
                  'QRIS Payment',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Change',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdown() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Payment Breakdown'),
          _buildBreakdownRow('Subtotal', _getSubtotal()),
          const SizedBox(height: 6),
          _buildBreakdownRow('Discounts Applied', 0),
          const SizedBox(height: 6),
          _buildBreakdownRow('Tax and service fees', _getTaxAndService()),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Color(0xFFD8CDBA), thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Rp ${_getTotal().toStringAsFixed(0)}',
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

  Widget _buildBreakdownRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: Colors.grey[800],
          ),
        ),
        Text(
          'Rp ${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCheckoutPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: pageBg,
        border: Border(top: BorderSide(color: cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Rp ${_getTotal().toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: oliveDark,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _itemsToCheckout.isEmpty ? null : _processCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: olive,
              foregroundColor: Colors.white,
              disabledBackgroundColor: olive.withOpacity(0.45),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'PAY NOW',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRPaymentScreen extends StatelessWidget {
  const QRPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EFE5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4EFE5),
        title: const Text('QR Payment', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/qr.png', width: 200, height: 200),
            const SizedBox(height: 20),
            const Text(
              'Scan this QR to pay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Return to home or something
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Simulate Payment Success'),
            )
          ],
        ),
      ),
    );
  }
}
