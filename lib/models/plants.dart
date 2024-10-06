import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Plant {
  final int plantId;
  final int price;
  int quantity;
  final String size;
  final double rating;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Plant({
    required this.plantId,
    required this.price,
    this.quantity = 1,
    required this.category,
    required this.plantName,
    required this.size,
    required this.rating,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.isFavorated,
    required this.decription,
    required this.isSelected,
  });

  // List of Plants data
  static List<Plant> plantList = [];

  // Load plants from the JSON file
  static Future<List<Plant>> loadPlants() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Plant.fromJson(json)).toList();
    
  }

  // Create a Plant object from JSON
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: json['plantId'],
      price: json['price'],
      category: json['category'],
      plantName: json['plantName'],
      size: json['size'],
      rating: json['rating'].toDouble(),
      humidity: json['humidity'],
      temperature: json['temperature'],
      imageURL: json['imageURL'],
      isFavorated: json['isFavorated'],
      decription: json['decription'],
      isSelected: json['isSelected'],
    );
  }

  // Get the favorited items
  static List<Plant> getFavoritedPlants() {
    return plantList.where((element) => element.isFavorated).toList();
  }

  // Get the cart items
  static List<Plant> addedToCartPlants() {
    return plantList.where((element) => element.isSelected).toList();
  }
}
