import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color pageBg = const Color(0xFFF4EFE5);
  final Color cardBg = const Color(0xFFF8F4EA);
  final Color cardBorder = const Color(0xFFD8CDBA);
  final Color olive = const Color(0xFFA3B04A);
  final Color oliveDark = const Color(0xFF8D9937);
  final Set<String> selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    // Select all items by default ONLY when the screen first loads
    for (final item in CartService.cart) {
      selectedItemIds.add(item.item.id);
    }
  }

  double _selectedTotal(List<CartItem> cart) {
    return cart.fold<double>(0, (total, cartItem) {
      if (!selectedItemIds.contains(cartItem.item.id)) {
        return total;
      }
      return total + (cartItem.item.price * cartItem.qty);
    });
  }

  void _navigateToCheckout() {
    final selectedCartItems = CartService.cart
        .where((item) => selectedItemIds.contains(item.item.id))
        .toList();

    if (selectedCartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item to checkout.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(selectedItems: selectedCartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.cart;
    // _syncSelection(cart);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF7F2E7),
                      border: Border.all(color: cardBorder),
                    ),
                    child: const Center(
                      child: Text(
                        'L',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB08A49),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Cart',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252525),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: olive,
                      boxShadow: [
                        BoxShadow(color: olive.withOpacity(0.20), blurRadius: 8, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: cart.isEmpty
                  ? Center(
                      child: Text(
                        'Cart is empty',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                      children: [
                        _buildHeaderStrip(),
                        const SizedBox(height: 12),
                        ...cart.asMap().entries.map((entry) {
                          return _buildCartCard(entry.key, entry.value);
                        }),
                        const SizedBox(height: 16),
                      ],
                    ),
            ),
            _buildBottomPanel(cart),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF1E4C8),
              border: Border.all(color: cardBorder),
            ),
            child: const Center(
              child: Text(
                'L',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFB08A49)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'CART',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF252525),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartCard(int index, CartItem item) {
    final isSelected = selectedItemIds.contains(item.item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            activeColor: oliveDark,
            side: BorderSide(color: cardBorder, width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  selectedItemIds.add(item.item.id);
                } else {
                  selectedItemIds.remove(item.item.id);
                }
              });
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 44,
              height: 44,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF252525),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 8,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ice: ${item.iceLevel} • Sugar: ${item.sugarLevel} • Strength: ${item.coffeeStrength}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 7.5,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      setState(() {
                        CartService.decreaseQty(index);

                      });
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.qty}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                    _qtyButton(Icons.add, () {
                      setState(() {
                        CartService.increaseQty(index);
                      });
                    }),
                    const SizedBox(width: 8),
                    Text(
                      'Rp ${item.item.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: oliveDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Total: Rp ${(item.item.price * item.qty).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: oliveDark,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 17,
            icon: const Icon(Icons.delete_outline, color: Color(0xFF777777)),
            onPressed: () {
              setState(() {
                // 1. Uncheck the item
                selectedItemIds.remove(item.item.id); 
                
                // 2. Remove it from the cart
                CartService.removeItem(index); 
                
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: oliveDark,
        ),
        child: Icon(icon, size: 10, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomPanel(List<CartItem> cart) {
    final total = _selectedTotal(cart);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      decoration: BoxDecoration(
        color: pageBg,
        border: Border(top: BorderSide(color: cardBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF252525),
                ),
              ),
              Text(
                'Rp ${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: oliveDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cardBorder),
                    foregroundColor: const Color(0xFF252525),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'BACK',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: cart.isEmpty ? null : _navigateToCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: olive,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: olive.withOpacity(0.45),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CHECK OUT',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}