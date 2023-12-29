import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smart_grocery_app/grocery.dart';
import 'package:smart_grocery_app/profile.dart';
import 'package:smart_grocery_app/search_restaurants.dart';
import 'package:smart_grocery_app/trending.dart';
import 'recipes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;

  // All the screens that can be shown
  var screens = [
    const RecipeScreen(),
    const SearchRestaurant(),
    const GroceryStore(),
    const Trending(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Grocery',
      home: Scaffold(
        body: Row(children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Recipes'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.restaurant),
                label: Text('Restaurants'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_grocery_store),
                label: Text('Groceries'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search),
                label: Text('Trending'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_circle),
                label: Text('Account'),
              )
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: screens[_selectedIndex]),
        ]),
      ),
    );
  }
}
