import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategoryIndex = 1; // Defaulting to 'Latte Series'

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

  // Function to trigger the bottom sheet (Item Properties Modal)
  void _showItemModal(BuildContext context, MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildItemPropertiesSheet(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFE9), // Matching your mockup background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/logo.png'), // Placeholder for your L logo
          ),
        ),
        title: const Text(
          'Menu',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF7B8D3F), // Olive green cart button
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () {}, // Cart logic for your teammates
              ),
            ),
          )
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDEBAR: Category Navigation
          SizedBox(
            width: 90,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        // The active indicator line/dot
                        Container(
                          width: 4,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF7B8D3F) : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.black87 : Colors.black54,
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
          
          // RIGHT AREA: Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionHeader('Latte Series'),
                ...dummyMenu.where((i) => i.category == 'Non-Coffee' || i.category == 'Coffee').map((item) => _buildItemCard(item)),
                const SizedBox(height: 20),
                _buildSectionHeader('Classics Coffee'),
                ...dummyMenu.where((i) => i.category == 'Coffee').map((item) => _buildItemCard(item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildItemCard(MenuItem item) {
    return GestureDetector(
      onTap: () => _showItemModal(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image Placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6D5C3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_cafe, color: Colors.white),
              ),
              const SizedBox(width: 12),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Description', // Placeholder for description
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B8D3F),
                      ),
                    ),
                  ],
                ),
              ),
              // Add Icon
              const Icon(Icons.add, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }

  // THE OVERLAY: Item Properties Modal
  Widget _buildItemPropertiesSheet(MenuItem item) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3EFE9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Huge Image Placeholder
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
          
          _buildPropertySelector('Ice Level', ['Hot', 'Less Ice', 'Normal Ice']),
          const SizedBox(height: 16),
          _buildPropertySelector('Sugar Level', ['No Sugar', 'Less Sugar', 'Normal Sugar']),
          const SizedBox(height: 16),
          _buildPropertySelector('Coffee Strength', ['Normal', 'Strong']),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp ${item.price.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF7B8D3F)),
              ),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
                  const Text('1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Color(0xFF7B8D3F))),
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
                    foregroundColor: const Color(0xFF7B8D3F),
                    side: const BorderSide(color: Color(0xFF7B8D3F)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text('ADD TO CART'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A7B4F), // Brownish accent
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text('CHECK OUT', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPropertySelector(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            bool isSelected = option == options.first; // Defaulting the first option as selected
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              selectedColor: const Color(0xFF7B8D3F),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade400),
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontFamily: 'Montserrat',
              ),
              onSelected: (bool selected) {
                // Logic to update state for selections will go here
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}