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
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // Safely parse the string coming from the database into a double
      price: double.tryParse(json['price'].toString()) ?? 0.0, 
      category: json['category'] ?? '',
      imagePlaceholder: json['imagePlaceholder'] ?? 'assets/images/placeholder_1.png',
    );
  }
}
