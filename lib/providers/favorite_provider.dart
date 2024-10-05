import 'package:flutter/material.dart';
import 'package:green/models/plants.dart';

class FavoriteProvider with ChangeNotifier {
  List<Plant> _favoriteItems = [];

  List<Plant> get favoriteItems => _favoriteItems;

  void addToFavorites(Plant plant) {
    if (!_favoriteItems.contains(plant)) {
      _favoriteItems.add(plant);
      notifyListeners();
    }
  }

  void removeFromFavorites(Plant plant) {
    if (_favoriteItems.contains(plant)) {
      _favoriteItems.remove(plant);
      notifyListeners();
    }
  }

  bool isFavorited(Plant plant) {
    return _favoriteItems.any((item) => item.plantId == plant.plantId);
  }
}
