import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/models/plants.dart';
import 'package:green/providers/favorite_provider.dart';
import 'package:green/ui/screens/detail_page.dart';
import 'package:green/ui/screens/widgets/plant_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;

  late Future<List<Plant>> plantList;

  @override
  void initState() {
    super.initState();
    plantList = Plant.loadPlants();
  }

  // Toggle Favorite button
  bool toggleIsFavorited(bool isFavorited) {
    return !isFavorited;
  }

  // Filter plants based on the selected category
  Future<List<Plant>> getFilteredPlants() async {
    final plants = await plantList;
    // If the selectedIndex is 0, return all plants
    if (selectedIndex == 0) {
      return plants;
    } else {
      // Filter plants based on the selected type
      List<String> plantTypes = [
        'Recommended',
        'Indoor',
        'Outdoor',
        'Garden',
        'Supplement',
      ];
      return plants
          .where((plant) => plant.category == plantTypes[selectedIndex])
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: size.width * .9,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black54.withOpacity(.6),
                        ),
                        const Expanded(
                          child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                              hintText: 'Search Plant',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.mic,
                          color: Colors.black54.withOpacity(.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Category section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50.0,
              width: size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Fixed number of categories
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Text(
                        ['Recommended', 'Indoor', 'Outdoor', 'Garden', 'Supplement'][index],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.w300,
                          color: selectedIndex == index
                              ? Constants.primaryColor
                              : Constants.blackColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Horizontal plant list with hover functionality
            SizedBox(
              height: size.height * .3,
              child: FutureBuilder<List<Plant>>(
                future: getFilteredPlants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading plants'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No plants available'));
                  } else {
                    final filteredPlants = snapshot.data!;
                    return ListView.builder(
                      itemCount: filteredPlants.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        // Check to prevent index out of bounds
                        if (index < 0 || index >= filteredPlants.length) {
                          return const SizedBox.shrink(); // Return empty widget if index is out of bounds
                        }

                        return GestureDetector(
                          onTap: () {  
                          debugPrint('Navigating to DetailPage with plantId: ${filteredPlants[index].plantId}');
                            Navigator.push(
                              context,
                              PageTransition(
                                child: DetailPage(
                                  filteredPlants: filteredPlants,
                                  plantId: filteredPlants[index].plantId,
                                  price: filteredPlants[index].price.toDouble(),
                                  plantName: filteredPlants[index].plantName,
                                  category: filteredPlants[index].category,
                                  imageURL: filteredPlants[index].imageURL,
                                  isFavorited: filteredPlants[index].isFavorated,
                                  rating: filteredPlants[index].rating,
                                  description: filteredPlants[index].decription,
                                  size: filteredPlants[index].size,
                                  humidity: filteredPlants[index].humidity,
                                  isSelected: filteredPlants[index].isSelected,
                                  temperature: filteredPlants[index].temperature,
                                ),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 50,
                                    right: 50,
                                    top: 20,
                                    bottom: 50,
                                    child: Image.asset(filteredPlants[index].imageURL),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          filteredPlants[index].category,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          filteredPlants[index].plantName,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        r'$' + filteredPlants[index].price.toString(),
                                        style: TextStyle(
                                          color: Constants.primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // "New Plants" section
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'New Plants',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            // Vertical list with hover functionality
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * .5,
              child: FutureBuilder<List<Plant>>(
                future: getFilteredPlants(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading plants'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No plants available'));
                  } else {
                    final filteredPlants = snapshot.data!;
                    return ListView.builder(
                      itemCount: filteredPlants.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // Check to prevent index out of bounds
                        if (index < 0 || index >= filteredPlants.length) {
                          return const SizedBox.shrink(); // Return empty widget if index is out of bounds
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: DetailPage(
                                  filteredPlants: filteredPlants,
                                  plantId: filteredPlants[index].plantId,
                                  price: filteredPlants[index].price.toDouble(),
                                  plantName: filteredPlants[index].plantName,
                                  category: filteredPlants[index].category,
                                  imageURL: filteredPlants[index].imageURL,
                                  isFavorited: filteredPlants[index].isFavorated,
                                  rating: filteredPlants[index].rating,
                                  description: filteredPlants[index].decription,
                                  size: filteredPlants[index].size,
                                  humidity: filteredPlants[index].humidity,
                                  isSelected: filteredPlants[index].isSelected,
                                  temperature: filteredPlants[index].temperature,
                                ),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: PlantWidget(
                                plantList: filteredPlants,
                                plantId: filteredPlants[index].plantId,
                                price: filteredPlants[index].price.toDouble(),
                                plantName: filteredPlants[index].plantName,
                                category: filteredPlants[index].category,
                                imageURL: filteredPlants[index].imageURL,
                                isFavorated: filteredPlants[index].isFavorated,
                                rating: filteredPlants[index].rating,
                                decription: filteredPlants[index].decription,
                                size: filteredPlants[index].size,
                                humidity: filteredPlants[index].humidity,
                                isSelected: filteredPlants[index].isSelected,
                                temperature: filteredPlants[index].temperature,
                                index: index,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
                          