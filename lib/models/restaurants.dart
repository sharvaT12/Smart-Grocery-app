
import 'package:smart_grocery_app/models/restaurant.dart';

class Restaurants{

  // you will have a final list of restaurants
  final List<Restaurant> restaurants;

  Restaurants({
    required this.restaurants,
  });

  factory Restaurants.fromMap(Map<String, dynamic> map){

    // returns the list of restaurants
    List<Restaurant> restaurants = [];

    map['restaurants'].forEach( (restaurantMap) => restaurants.add(Restaurant.fromMap(restaurantMap)) );

    // remember that the class is created above
    return Restaurants(
      // constructor must be initialized to the created list of restaurants
      restaurants: restaurants,
    );

  }
  
}