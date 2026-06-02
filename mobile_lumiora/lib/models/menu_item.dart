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

  // STEP 1: The Translator. This converts PostgreSQL JSON into a MenuItem.
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // Safely parse the price whether the database sends an integer or double
      price: (json['price'] ?? 0).toDouble(), 
      category: json['category'] ?? '',
      imagePlaceholder: json['imagePlaceholder'] ?? 'assets/images/placeholder_1.png',
    );
  }
}

// Keep the dummy data temporarily so your app still runs while we build the rest.
final List<MenuItem> dummyMenu = [
  MenuItem(
    id: 'm1',
    name: 'Special Bundle',
    description: 'A set of featured drinks and snacks.',
    price: 90000,
    category: 'Special Bundle',
    imagePlaceholder: 'assets/images/placeholder_1.png',
  ),
  MenuItem(
    id: 'm3',
    name: 'Latte',
    description: 'Smooth espresso with steamed milk.',
    price: 21000,
    category: 'Latte Series',
    imagePlaceholder: 'assets/images/placeholder_3.png',
  ),
  MenuItem(
    id: 'm5',
    name: 'Macchiato',
    description: 'Bold espresso layered over milk.',
    price: 23000,
    category: 'Classics Coffee',
    imagePlaceholder: 'assets/images/placeholder_2.png',
  ),
];