class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; 
  final String imagePlaceholder; 

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePlaceholder,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      // The API sends an integer (1), so we safely convert it to a string
      id: json['id']?.toString() ?? '', 
      
      // Look for the teacher's specific keys
      name: json['item_name'] ?? 'Unknown Item', 
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      category: json['category_name'] ?? 'Uncategorized', 
      imagePlaceholder: json['image_url'] ?? 'assets/images/placeholder_1.png',
    );
  }
}
