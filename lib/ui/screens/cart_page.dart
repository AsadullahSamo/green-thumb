import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/models/plants.dart';
import 'package:green/ui/screens/widgets/plant_widget.dart';
import 'package:provider/provider.dart';
import 'package:green/providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  final List<Plant> addedToCartPlants;
  const CartPage({Key? key, required this.addedToCartPlants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the CartProvider to get the list of added to cart plants
    final cartProvider = Provider.of<CartProvider>(context);
    final addedToCartPlants = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: addedToCartPlants.isEmpty
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Image.asset('assets/images/add-cart.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your Cart is Empty',
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: addedToCartPlants.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: PlantWidget(
                                      index: index,
                                      plantList: addedToCartPlants,
                                      plantId: addedToCartPlants[index].plantId,
                                      price: addedToCartPlants[index].price.toDouble(),
                                      plantName: addedToCartPlants[index].plantName,
                                      category: addedToCartPlants[index].category,
                                      imageURL: addedToCartPlants[index].imageURL,
                                      isFavorated: addedToCartPlants[index].isFavorated,
                                      rating: addedToCartPlants[index].rating,
                                      decription: addedToCartPlants[index].decription,
                                      size: addedToCartPlants[index].size,
                                      humidity: addedToCartPlants[index].humidity,
                                      isSelected: addedToCartPlants[index].isSelected,
                                      temperature: addedToCartPlants[index].temperature,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                                            onPressed: () => _decreaseQuantity(context, index),
                                          ),
                                          Text(
                                            '${addedToCartPlants[index].quantity}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle, color: Colors.green),
                                            onPressed: () => _increaseQuantity(context, index),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '\$${(addedToCartPlants[index].price * addedToCartPlants[index].quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(thickness: 1.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${_calculateTotal(addedToCartPlants).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Add spacing at the bottom
                  ],
                ),
              ),
      ),
    );
  }

  void _increaseQuantity(BuildContext context, int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.increaseQuantity(index);
  }

  void _decreaseQuantity(BuildContext context, int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.decreaseQuantity(index);
  }

  double _calculateTotal(List<Plant> addedToCartPlants) {
    return addedToCartPlants.fold(0, (total, plant) => total + (plant.price * plant.quantity));
  }
}
