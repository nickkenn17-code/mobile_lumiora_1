import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/cart_service.dart';
import '../services/menu_service.dart';
import '../services/auth_service.dart';
import '../widgets/login_modal.dart';
import 'checkout_screen.dart';
import 'history_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategoryIndex = 1; // Defaulting to 'Latte Series'
  
  // STEP 4: State variables to hold the live data and track loading
  List<MenuItem> menuItems = []; 
  bool isLoading = true; 

  final ScrollController menuScrollController = ScrollController();
  final Color pageBg = const Color(0xFFF2EEE6);
  final Color olive = const Color(0xFFA3B04A);
  final Color oliveDark = const Color(0xFF8E9B3A);
  final Color cardBorder = const Color(0xFFD6C9B8);

  final Map<String, GlobalKey> sectionKeys = {
    'Special Bundle': GlobalKey(),
    'Latte Series': GlobalKey(),
    'Classics Coffee': GlobalKey(),
    'Non-Coffee': GlobalKey(),
    'Bundling Duo': GlobalKey(),
    'Bundling Trio': GlobalKey(),
    'Pastry & Bakery': GlobalKey(),
    'Skewers': GlobalKey(),
  };

  final List<String> categories = [
    'Special\nBundle',
    'Latte\nSeries',
    'Classics\nCoffee',
    'Non -\nCoffee',
    'Bundling\nDuo',
    'Bundling\nTrio',
    'Pastry &\nBakery',
    'Skewers'
  ];

  final List<String> categoryTargets = [
    'Special Bundle',
    'Latte Series',
    'Classics Coffee',
    'Non-Coffee',
    'Bundling Duo',
    'Bundling Trio',
    'Pastry & Bakery',
    'Skewers',
  ];

  @override
  void initState() {
    super.initState();
    _loadMenuData(); // Trigger the fetch when screen opens
  }

  // Function to actually fetch the data from our new service
  Future<void> _loadMenuData() async {
    try {
      final items = await MenuService.fetchMenuItems();
      if (mounted) {
        setState(() {
          menuItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // Show an error message on the screen if the DB fails
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Database Error: $e')),
        );
      }
    }
  }

  // Function to trigger the bottom sheet (Item Properties Modal)
  void _showItemModal(BuildContext context, MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildItemPropertiesSheet(context, item),
    );
  }

  void _checkAuthAndAddItem(MenuItem item) {
    final authService = AuthService();
    if (!authService.isLoggedIn) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => LoginModal(
          onLoginSuccess: () {
            _showItemModal(context, item);
          },
        ),
      );
    } else {
      _showItemModal(context, item);
    }
  }

  @override
  void dispose() {
    menuScrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(String category) {
    final key = sectionKeys[category];

    setState(() {
      selectedCategoryIndex = categoryTargets.indexOf(category);
      if (selectedCategoryIndex < 0) {
        selectedCategoryIndex = 0;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.05,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        return;
      }

      if (!menuScrollController.hasClients) {
        return;
      }

      final targetOffset = _estimateCategoryOffset(category);
      final maxOffset = menuScrollController.position.maxScrollExtent;
      final clampedOffset = targetOffset.clamp(0.0, maxOffset);
      menuScrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  double _estimateCategoryOffset(String category) {
    const sectionHeaderHeight = 28.0;
    const sectionGap = 10.0;
    const cardHeight = 84.0;
    const topPadding = 8.0;

    double offset = topPadding;

    for (final target in categoryTargets) {
      if (target == category) {
        return offset;
      }

      // Replaced dummyMenu with our live menuItems
      final itemCount = menuItems.where((item) => item.category == target).length;
      if (itemCount == 0) {
        continue;
      }

      offset += sectionHeaderHeight + (itemCount * cardHeight) + sectionGap;
    }

    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
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
                  const Expanded(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202020),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cart'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: olive,
                        boxShadow: [
                          BoxShadow(color: olive.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 74,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedCategoryIndex == index;
                        return InkWell(
                          onTap: () => _scrollToCategory(categoryTargets[index]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: isSelected ? oliveDark : Colors.transparent,
                                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    categories[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 11,
                                      height: 1.15,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? const Color(0xFF111111) : const Color(0xFF5E5E5E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    // Show a loading spinner while fetching data from the API
                    child: isLoading 
                      ? Center(child: CircularProgressIndicator(color: oliveDark))
                      : ListView(
                          controller: menuScrollController,
                          padding: const EdgeInsets.fromLTRB(6, 8, 16, 16),
                          children: [
                            ..._buildSection('Special Bundle', 'Special Bundle'),
                            const SizedBox(height: 10),
                            ..._buildSection('Latte Series', 'Latte Series'),
                            const SizedBox(height: 10),
                            ..._buildSection('Classics Coffee', 'Classics Coffee'),
                            const SizedBox(height: 10),
                            ..._buildSection('Non-Coffee', 'Non-Coffee'),
                            const SizedBox(height: 10),
                            ..._buildSection('Bundling Duo', 'Bundling Duo'),
                            const SizedBox(height: 10),
                            ..._buildSection('Bundling Trio', 'Bundling Trio'),
                            const SizedBox(height: 10),
                            ..._buildSection('Pastry & Bakery', 'Pastry & Bakery'),
                            const SizedBox(height: 10),
                            ..._buildSection('Skewers', 'Skewers'),
                            const SizedBox(height: 96),
                          ],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  List<Widget> _buildSection(String categoryKey, String displayTitle) {
    // Search using the API key
    final items = menuItems.where((item) => item.category == categoryKey).toList();
    if (items.isEmpty) {
      return [const SizedBox.shrink()];
    }

    return [
      Container(
        key: sectionKeys[categoryKey],
        padding: const EdgeInsets.only(left: 8, bottom: 10),
        child: Text(
          displayTitle, // Show the pretty UI title
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF202020),
          ),
        ),
      ),
      ...items.map(_buildItemCard),
    ];
  }

  Widget _buildItemCard(MenuItem item) {
    return GestureDetector(
      onTap: () => _checkAuthAndAddItem(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0, left: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cardBorder.withOpacity(0.9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFFE7D4B8),
                  child: Image.asset(
                    item.imagePlaceholder,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_cafe, color: Colors.white);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF262626),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 7.5,
                                  color: Colors.grey[700],
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${item.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: oliveDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            final authService = AuthService();
                            if (!authService.isLoggedIn) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) => LoginModal(
                                  onLoginSuccess: () {
                                    CartService.addToCart(item);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item.name} added to cart')),
                                    );
                                  },
                                ),
                              );
                            } else {
                              CartService.addToCart(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${item.name} added to cart')),
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.add, size: 16, color: Color(0xFF202020)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
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
                _navItem(Icons.home_outlined, 'Home', false, () {
                  // Go back to the very first screen (Splash/Home)
                  Navigator.popUntil(context, (route) => route.isFirst);
                }),
                _navItem(Icons.coffee_outlined, 'Menu', true, () {
                  // We are already on the Menu screen, so do nothing
                }),
                const SizedBox(width: 64),
                _navItem(Icons.receipt_long_outlined, 'History', false, () {
                  // Navigate to the History screen!
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                }),
                _navItem(Icons.person_outline, 'Profile', false, () {
                  // Navigate to the Profile screen!
                  Navigator.pushNamed(context, '/profile');
                }),
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
      onTap: onTap, // <--- This registers the user's click
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

  Widget _buildItemPropertiesSheet(BuildContext context, MenuItem item) {
    String selectedIce = 'Hot';
    String selectedSugar = 'No Sugar';
    String selectedStrength = 'Normal';
    int quantity = 1;

    return StatefulBuilder(
      builder: (context, setModalState) {
        Widget buildSection(String title, List<String> options, String selectedValue, ValueChanged<String> onChanged) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((option) {
                  final isSelected = option == selectedValue;
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    selectedColor: const Color(0xFF8E9B3A),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade400),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                    onSelected: (_) {
                      setModalState(() {
                        onChanged(option);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.75,
          maxChildSize: 0.98,
          builder: (context, scrollController) {
            final totalPrice = item.price * quantity;

            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF3EFE9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(item.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                    Text('Item Description Detail', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontFamily: 'Montserrat')),
                    const SizedBox(height: 20),
                    buildSection('Ice Level', ['Hot', 'Less Ice', 'Normal Ice'], selectedIce, (value) => selectedIce = value),
                    const SizedBox(height: 16),
                    buildSection('Sugar Level', ['No Sugar', 'Less Sugar', 'Normal Sugar'], selectedSugar, (value) => selectedSugar = value),
                    const SizedBox(height: 16),
                    buildSection('Coffee Strength', ['Normal', 'Strong'], selectedStrength, (value) => selectedStrength = value),
                    const SizedBox(height: 24),
                    Text(
                      'Total: Rp ${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8E9B3A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(  
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1
                                  ? () {
                                      setModalState(() {
                                        quantity -= 1;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  quantity += 1;
                                });
                              },
                              icon: const Icon(Icons.add, color: Color(0xFF8E9B3A)),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8E9B3A),
                              side: const BorderSide(color: Color(0xFF8E9B3A)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              CartService.addToCart(
                                item,
                                qty: quantity,
                                iceLevel: selectedIce,
                                sugarLevel: selectedSugar,
                                coffeeStrength: selectedStrength,
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${item.name} added to cart')),
                              );
                            },
                            child: const Text('ADD TO CART'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9A7B4F),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                // 1. Add the customized item to the cart
                                CartService.addToCart(
                                  item,
                                  qty: quantity,
                                  iceLevel: selectedIce,
                                  sugarLevel: selectedSugar,
                                  coffeeStrength: selectedStrength,
                                );

                                // 2. Grab the item we just added
                                final itemToCheckOut = CartService.cart.last;

                                // 3. Close the bottom modal sheet
                                Navigator.pop(context);

                                // 4. Navigate directly to the Checkout screen with this item
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      selectedItems: [itemToCheckOut],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('CHECK OUT', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}