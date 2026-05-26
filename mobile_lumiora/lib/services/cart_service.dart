import '../models/menu_item.dart';

class CartItem {
  MenuItem item;
  int qty;
  String iceLevel;
  String sugarLevel;
  String coffeeStrength;

  CartItem({
    required this.item,
    this.qty = 1,
    this.iceLevel = 'Hot',
    this.sugarLevel = 'No Sugar',
    this.coffeeStrength = 'Normal',
  });
}

class CartService {
  static List<CartItem> cart = [];

  static void addToCart(
    MenuItem item, {
    int qty = 1,
    String iceLevel = 'Hot',
    String sugarLevel = 'No Sugar',
    String coffeeStrength = 'Normal',
  }) {
    // cek kalau sudah ada → tambah qty
    for (var cartItem in cart) {
      if (cartItem.item.id == item.id &&
          cartItem.iceLevel == iceLevel &&
          cartItem.sugarLevel == sugarLevel &&
          cartItem.coffeeStrength == coffeeStrength) {
        cartItem.qty += qty;
        return;
      }
    }

    // kalau belum ada → tambah baru
    cart.add(
      CartItem(
        item: item,
        qty: qty,
        iceLevel: iceLevel,
        sugarLevel: sugarLevel,
        coffeeStrength: coffeeStrength,
      ),
    );
  }

  static void increaseQty(int index) {
    cart[index].qty++;
  }

  static void decreaseQty(int index) {
    if (cart[index].qty > 1) {
      cart[index].qty--;
    } else {
      cart.removeAt(index);
    }
  }

  static void removeItem(int index) {
    cart.removeAt(index);
  }

  static double getTotal() {
    return cart.fold(
      0,
      (total, cartItem) => total + (cartItem.item.price * cartItem.qty),
    );
  }

  static int getCount() {
    return cart.fold(0, (total, item) => total + item.qty);
  }
}