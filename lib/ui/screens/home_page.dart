import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/models/plants.dart';
import 'package:green/ui/screens/detail_page.dart';
import 'package:green/ui/screens/widgets/plant_widget.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Plant> plantList = Plant.plantList;

    //Plants category
    List<String> plantTypes = [
      'Recommended',
      'Indoor',
      'Outdoor',
      'Garden',
      'Supplement',
    ];

    //Filter plants based on the selected category
    List<Plant> getFilteredPlants() {
      if (selectedIndex == 0) {
        // Show all plants for "Recommended"
        return plantList;
      } else {
        // Filter plants based on the selected type
        return plantList
            .where((plant) => plant.category == plantTypes[selectedIndex])
            .toList();
      }
    }

    //Toggle Favorite button
    bool toggleIsFavorated(bool isFavorited) {
      return !isFavorited;
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
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
                      )),
                      Icon(
                        Icons.mic,
                        color: Colors.black54.withOpacity(.6),
                      ),
                    ],
                  ),
                )
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
                itemCount: plantTypes.length,
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
                        plantTypes[index],
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
                }),
          ),
          // Horizontal plant list with hover functionality
          SizedBox(
            height: size.height * .3,
            child: ListView.builder(
                itemCount: getFilteredPlants().length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final filteredPlants = getFilteredPlants();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: DetailPage(
                                plantId: filteredPlants[index].plantId,
                              ),
                              type: PageTransitionType.bottomToTop));
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
                              top: 10,
                              right: 20,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      bool isFavorited = toggleIsFavorated(
                                          filteredPlants[index].isFavorated);
                                      filteredPlants[index].isFavorated =
                                          isFavorited;
                                    });
                                  },
                                  icon: Icon(
                                    filteredPlants[index].isFavorated == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Constants.primaryColor,
                                  ),
                                  iconSize: 30,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 50,
                              right: 50,
                              top: 50,
                              bottom: 50,
                              child: Image.asset(
                                  filteredPlants[index].imageURL),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              bottom: 15,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  r'$' +
                                      filteredPlants[index].price.toString(),
                                  style: TextStyle(
                                      color: Constants.primaryColor,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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
            child: ListView.builder(
                itemCount: getFilteredPlants().length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final filteredPlants = getFilteredPlants();
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: DetailPage(
                                    plantId: filteredPlants[index].plantId),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: PlantWidget(
                              index: index, plantList: filteredPlants)));
                }),
          ),
        ],
      ),
    ));
  }
}
