class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; 
  final String imagePlaceholder;
  final bool isAvailable;
  final int categoryId;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePlaceholder,
    this.isAvailable = true,
    this.categoryId = 0,
  });

  // Map category_id to category name
  static String _mapCategoryIdToName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'Latte Series';
      case 2:
        return 'Classics Coffee';
      case 3:
        return 'Non-Coffee';
      case 4:
        return 'Pastry & Bakery';
      case 5:
        return 'Skewers';
      default:
        return 'Special Bundle';
    }
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final int categoryId = int.tryParse(json['category_id']?.toString() ?? '0') ?? 0;
    
    return MenuItem(
      id: json['id']?.toString() ?? '', 
      name: json['name'] ?? 'Unknown Item', 
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: _mapCategoryIdToName(categoryId),
      imagePlaceholder: json['imagePlaceholder'] ?? 'assets/images/placeholder_1.png',
      isAvailable: json['is_available'] ?? true,
      categoryId: categoryId,
    );
  }
}
