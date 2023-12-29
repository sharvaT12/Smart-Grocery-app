import 'package:smart_grocery_app/models/recipe.dart';

class RecipePlan {
  final List<Recipe> recipes;

  RecipePlan({
    required this.recipes,
  });

  factory RecipePlan.fromMap(Map<String, dynamic> map) {
    List<Recipe> recipes = [];
    map['results'].forEach((recipe) => recipes.add(Recipe.fromMap(recipe)));
    return RecipePlan(
      recipes: recipes,
    );
  }
}
