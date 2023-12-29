import 'package:smart_grocery_app/models/random_recipe.dart';

class random_recipe_plan {
  final List<Random_Recipe> recipes;

  random_recipe_plan({
    required this.recipes,
  });

  factory random_recipe_plan.fromMap(Map<String, dynamic> map) {
    List<Random_Recipe> recipes = [];
    if(map != null){
    map['recipes'].forEach((recipe) => recipes.add(Random_Recipe.fromMap(recipe)));
    }
    recipes.sort((a,b) => a.likes.compareTo(b.likes));
    for (int i=0 ; i<20 ; i++) {
      recipes.remove(recipes[i]);
    }
    return random_recipe_plan(
      recipes: recipes
    );
  }
}
