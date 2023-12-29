import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smart_grocery_app/models/recipe_parameters.dart';
import 'package:smart_grocery_app/services/api.dart';
import 'models/random_recipe_plan.dart';
import 'models/random_recipe.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<random_recipe_plan> searchRecipes(recipeParameters) async {
  random_recipe_plan recipePlan = await APIService.instance
      .getRandomPopRecipes(recipeParameters: recipeParameters);
  return recipePlan;
}

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  State<Trending> createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  late Future<random_recipe_plan> recipePlan;

  _buildRecipeCard(Random_Recipe recipe, int index) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          child: CachedNetworkImage(
            imageUrl: recipe.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            recipe.title,
            softWrap: true,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  _buildGridView(random_recipe_plan recipePlan) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.5,
          crossAxisSpacing: 65,
          mainAxisSpacing: 75),
      padding: const EdgeInsets.symmetric(horizontal: 200),
      itemCount: recipePlan.recipes.length,
      itemBuilder: (BuildContext context, int index) {
        Random_Recipe recipe = recipePlan.recipes[index];
        return _buildRecipeCard(recipe, index);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    var recipeParameters = RecipeParameters();
    recipePlan = searchRecipes(recipeParameters);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Grocery',
      home: Scaffold(
        body: Center(
          child: FutureBuilder<random_recipe_plan>(
            future: recipePlan,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildGridView(snapshot.data!);
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
