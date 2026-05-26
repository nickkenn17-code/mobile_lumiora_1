class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // e.g., 'Coffee', 'Non-Coffee', 'Pastry'
  final String imagePlaceholder; // We'll use local assets or URLs later

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePlaceholder,
  });
}

// Temporary mock data to test the UI without needing a backend yet
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
    id: 'm2',
    name: 'Mocha Croissant',
    description: 'Coffee and pastry combo for a light meal.',
    price: 55000,
    category: 'Special Bundle',
    imagePlaceholder: 'assets/images/placeholder_2.png',
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
    id: 'm4',
    name: 'Aren Latte',
    description: 'Latte with sweet palm sugar profile.',
    price: 23000,
    category: 'Latte Series',
    imagePlaceholder: 'assets/images/placeholder_1.png',
  ),
  MenuItem(
    id: 'm5',
    name: 'Macchiato',
    description: 'Bold espresso layered over milk.',
    price: 23000,
    category: 'Classics Coffee',
    imagePlaceholder: 'assets/images/placeholder_2.png',
  ),
  MenuItem(
    id: 'm6',
    name: 'Matcha Latte',
    description: 'Premium matcha blended with milk.',
    price: 40000,
    category: 'Non-Coffee',
    imagePlaceholder: 'assets/images/placeholder_3.png',
  ),
  MenuItem(
    id: 'm7',
    name: 'Bundling Duo',
    description: 'Two items bundled at a better price.',
    price: 65000,
    category: 'Bundling Duo',
    imagePlaceholder: 'assets/images/placeholder_1.png',
  ),
  MenuItem(
    id: 'm8',
    name: 'Bundling Trio',
    description: 'Three-item bundle for sharing.',
    price: 85000,
    category: 'Bundling Trio',
    imagePlaceholder: 'assets/images/placeholder_2.png',
  ),
  MenuItem(
    id: 'm9',
    name: 'Pastry & Bakery',
    description: 'Fresh baked pastry selection.',
    price: 35000,
    category: 'Pastry & Bakery',
    imagePlaceholder: 'assets/images/placeholder_3.png',
  ),
  MenuItem(
    id: 'm10',
    name: 'Skewers',
    description: 'Savory skewers for a quick bite.',
    price: 23000,
    category: 'Skewers',
    imagePlaceholder: 'assets/images/placeholder_1.png',
  ),
];