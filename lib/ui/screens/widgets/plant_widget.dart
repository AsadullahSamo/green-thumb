
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/models/plants.dart';
import 'package:green/providers/favorite_provider.dart';
import 'package:green/ui/screens/detail_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlantWidget extends StatelessWidget {
  final int plantId;
  final String plantName;
  final double price;
  final double rating;
  final String decription;
  final String imageURL;
  final String size;
  final int humidity;
  final String category;
  bool isFavorated;
  bool isSelected;
  final String temperature;
  final List<Plant> plantList;

  PlantWidget({
    Key? key, required this.index, required this.plantId, required this.plantName, required this.price, required this.rating, required this.decription, required this.imageURL, required this.size, required this.humidity, required this.category, required this.isFavorated, required this.isSelected, required this.temperature, required this.plantList
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: DetailPage(
                  filteredPlants: plantList,
                  plantId: plantList[index].plantId,
                  price: plantList[index].price.toDouble(),
                  plantName: plantList[index].plantName,
                  category: plantList[index].category,
                  imageURL: plantList[index].imageURL,
                  isFavorited: plantList[index].isFavorated,
                  rating: plantList[index].rating,
                  description: plantList[index].decription,
                  size: plantList[index].size,
                  humidity: plantList[index].humidity,
                  isSelected: plantList[index].isSelected,
                  temperature: plantList[index].temperature,
                ),
                type: PageTransitionType.bottomToTop));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 80.0,
        padding: const EdgeInsets.only(left: 10, top: 10),
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80.0,
                    child:
                    Image.asset(plantList[index].imageURL),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plantList[index].category),
                      Text(
                        plantList[index].plantName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Constants.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                r'$' + plantList[index].price.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Constants.primaryColor,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (favoriteProvider.isFavorited(plantList[index])) {
                  favoriteProvider.removeFromFavorites(plantList[index]);
                } else {
                  favoriteProvider.addToFavorites(plantList[index]);
                }
              },
              icon: Icon(
                favoriteProvider.isFavorited(plantList[index])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Constants.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}