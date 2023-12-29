import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_grocery_app/models/restaurants.dart';
import 'package:smart_grocery_app/services/api.dart';
import 'package:smart_grocery_app/services/location.dart';
import 'models/restaurant.dart';

Future<Restaurants> getRestaurants(user_lat, user_lng) async {
  var position = await determinePosition();

  user_lat = position.latitude;
  user_lng = position.longitude;

  Restaurants restaurants =
      await APIService.instance.getRestaurants(user_lat, user_lng);
  return restaurants;
}

class SearchRestaurant extends StatefulWidget {
  const SearchRestaurant({super.key});

  @override
  State<SearchRestaurant> createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  late Future<Restaurants> restaurants;

  double user_lat = 0.0;
  double user_lng = 0.0;

  // to be later converted to lat and lng
  final zipcodeController = TextEditingController();

  _buildRestaurantCard(Restaurant restaurant, Size deviceData) {
    return Column(
      children: [
        SizedBox(
          width: deviceData.width * 0.40,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text(
                    (restaurant.weighted_rating_value.toString() ==
                            'No rating...')
                        ? 'No rating...'
                        : restaurant.weighted_rating_value.toStringAsFixed(1),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  trailing: Text(
                    "Price:${restaurant.dollar_signs}",
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),

                Text(
                  restaurant.description,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),

                const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(
                //       "Price:${restaurant.dollar_signs}",
                //       style: TextStyle(color: Colors.black.withOpacity(0.6)),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildListView(Restaurants restaurants, Size deviceData) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 25),
      itemCount: (restaurants.restaurants.length > 10)
          ? 10
          : restaurants.restaurants.length,
      itemBuilder: (BuildContext context, int index) {
        Restaurant restaurant = restaurants.restaurants[index];
        return _buildRestaurantCard(restaurant, deviceData);
      },
    );
  }

  // construct the new class by default
  @override
  void initState() {
    super.initState();
    restaurants = getRestaurants(user_lat, user_lng);
  }

  @override
  Widget build(BuildContext context) {
    final deviceData = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'Smart Grocery',
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Restaurants>(
            future: restaurants,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildListView(snapshot.data!, deviceData);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

// please run with this command: flutter run -d chrome --web-renderer html because flutter run -d chrome won't work...
