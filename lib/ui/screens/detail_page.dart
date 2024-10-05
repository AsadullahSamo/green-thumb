import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/models/plants.dart';
import 'package:green/providers/cart_provider.dart';
import 'package:green/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final bool isFavorited;
  final bool isSelected;
  final List<Plant> filteredPlants;
  final int plantId;
  final String plantName;
  final double price;
  final double rating;
  final String description; // Fixed typo here
  final String imageURL;
  final String size;
  final int humidity;
  final String category;
  final String temperature;

  DetailPage({
    Key? key,
    required this.filteredPlants,
    required this.plantId,
    required this.plantName,
    required this.price,
    required this.rating,
    required this.description, // Fixed typo here
    required this.imageURL,
    required this.size,
    required this.humidity,
    required this.category,
    required this.temperature,
    required this.isFavorited,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
                Consumer<FavoriteProvider>(
  builder: (context, favoriteProvider, child) {
    final isFavorited = favoriteProvider.isFavorited(widget.filteredPlants[widget.plantId]);

    return GestureDetector(
      onTap: () {
        debugPrint('favorite');
        setState(() {
          if (isFavorited) {
            favoriteProvider.removeFromFavorites(widget.filteredPlants[widget.plantId]);
          } else {
            favoriteProvider.addToFavorites(widget.filteredPlants[widget.plantId]);
          }
        });
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Constants.primaryColor.withOpacity(.15),
        ),
        child: Icon(
          isFavorited ? Icons.favorite : Icons.favorite_border,
          color: Constants.primaryColor,
        ),
      ),
    );
  },
),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    child: SizedBox(
                      height: 350,
                      child: Image.asset(widget.imageURL),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PlantFeature(
                            title: 'Size',
                            plantFeature: widget.size,
                          ),
                          PlantFeature(
                            title: 'Humidity',
                            plantFeature: widget.humidity.toString(),
                          ),
                          PlantFeature(
                            title: 'Temperature',
                            plantFeature: widget.temperature,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
              height: size.height * .5,
              width: size.width,
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(.4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.plantName,
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              r'$' + widget.price.toString(),
                              style: TextStyle(
                                color: Constants.blackColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.rating.toString(),
                            style: TextStyle(
                              fontSize: 30.0,
                              color: Constants.primaryColor,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            size: 30.0,
                            color: Constants.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 17.0),
                  Expanded(
                    child: Text(
                      widget.description, // Fixed typo here
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 18,
                        color: Constants.blackColor.withOpacity(.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: size.width * .9,
        height: 50,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Provider.of<CartProvider>(context).isInCart(widget.filteredPlants[widget.plantId])
                    ? Constants.primaryColor.withOpacity(.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                    color: Constants.primaryColor.withOpacity(.3),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  if (Provider.of<CartProvider>(context, listen: false)
                      .isInCart(widget.filteredPlants[widget.plantId])) {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeFromCart(widget.plantId);
                  } else {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(widget.filteredPlants[widget.plantId]);
                  }
                  setState(() {}); // Refresh state after adding/removing from cart
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Provider.of<CartProvider>(context).isInCart(widget.filteredPlants[widget.plantId])
                      ? Colors.white
                      : Constants.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Add your buy now functionality here
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        color: Constants.primaryColor.withOpacity(.3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'BUY NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantFeature extends StatelessWidget {
  final String plantFeature;
  final String title;
  
  const PlantFeature({
    Key? key,
    required this.plantFeature,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Constants.blackColor.withOpacity(.5),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          plantFeature,
          style: TextStyle(
            fontSize: 16,
            color: Constants.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
