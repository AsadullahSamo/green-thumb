import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/models/plants.dart';
import 'package:green/ui/screens/widgets/plant_widget.dart';
import 'package:provider/provider.dart';
import 'package:green/providers/favorite_provider.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Access the FavoriteProvider to get the list of favorited plants
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoritedPlants = favoriteProvider.favoriteItems;

    return Scaffold(
      body: favoritedPlants.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/favorited.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your favorited Plants',
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
              height: size.height * .5,
              child: ListView.builder(
                itemCount: favoritedPlants.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return PlantWidget(
                    index: index,
                    plantList: favoritedPlants,
                    plantId: favoritedPlants[index].plantId,
                    price: favoritedPlants[index].price.toDouble(),
                    plantName: favoritedPlants[index].plantName,
                    category: favoritedPlants[index].category,
                    imageURL: favoritedPlants[index].imageURL,
                    isFavorated: favoritedPlants[index].isFavorated,
                    rating: favoritedPlants[index].rating,
                    decription: favoritedPlants[index].decription,
                    size: favoritedPlants[index].size,
                    humidity: favoritedPlants[index].humidity,
                    isSelected: favoritedPlants[index].isSelected,
                    temperature: favoritedPlants[index].temperature,
                  );
                },
              ),
            ),
    );
  }
}
