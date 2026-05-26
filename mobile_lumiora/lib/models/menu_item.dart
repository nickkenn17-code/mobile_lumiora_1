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
    name: 'Caramel Macchiato',
    description: 'Freshly roasted espresso with vanilla syrup and caramel drizzle.',
    price: 45000,
    category: 'Coffee',
    imagePlaceholder: 'assets/images/placeholder_1.png',
  ),
  MenuItem(
    id: 'm2',
    name: 'Matcha Latte',
    description: 'Premium Uji matcha blended with creamy steamed milk.',
    price: 40000,
    category: 'Non-Coffee',
    imagePlaceholder: 'assets/images/placeholder_2.png',
  ),
  MenuItem(
    id: 'm3',
    name: 'Almond Croissant',
    description: 'Flaky, buttery pastry filled with sweet almond frangipane.',
    price: 35000,
    category: 'Pastry',
    imagePlaceholder: 'assets/images/placeholder_3.png',
  ),
];