import 'package:flutter/material.dart';
import 'package:green/models/plants.dart';

class CartProvider with ChangeNotifier {
  List<Plant> _cartItems = [];

  List<Plant> get cartItems => _cartItems;

  // Add a plant to the cart
  void addToCart(Plant plant) {
    _cartItems.add(plant);
    notifyListeners();
  }


  // Method to check if a plant is in the cart
  bool isInCart(Plant plant) {
    return _cartItems.any((item) => item.plantId == plant.plantId);
  }

  // Remove a plant from the cart
  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Increase the quantity of a plant in the cart
  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  // Decrease the quantity of a plant in the cart
  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      removeFromCart(index);
    }
    notifyListeners();
  }
}
