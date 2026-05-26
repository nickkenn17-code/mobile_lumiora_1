import '../models/coffee.dart';

class CartItem {
  Coffee coffee;
  int qty;

  CartItem({required this.coffee, this.qty = 1});
}

class CartService {
  static List<CartItem> cart = [];

  static void addToCart(Coffee coffee) {
    // cek kalau sudah ada → tambah qty
    for (var item in cart) {
      if (item.coffee.name == coffee.name) {
        item.qty++;
        return;
      }
    }

    // kalau belum ada → tambah baru
    cart.add(CartItem(coffee: coffee));
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
      (total, item) => total + (item.coffee.price * item.qty),
    );
  }

  static int getCount() {
    return cart.fold(0, (total, item) => total + item.qty);
  }
}