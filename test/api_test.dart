import 'package:smart_grocery_app/models/random_recipe_plan.dart';
import 'package:smart_grocery_app/models/recipe_parameters.dart';
import 'package:smart_grocery_app/models/recipe_plan.dart';
import 'package:smart_grocery_app/models/restaurants.dart';
import 'package:smart_grocery_app/services/api.dart';
import 'package:test/test.dart';

void main() {
  group('Spoonacular API get recipes endpoint', () {
    test('recipes are non empty', () async {
      final RecipePlan recipePlan = await APIService.instance
          .getRecipes(recipeParameters: RecipeParameters());

      expect(recipePlan.recipes.isNotEmpty, true);
    });
  });

  group('Spoonacular API get random recipes endpoint', () {
    test('recipes are non empty', () async {
      final random_recipe_plan randomRecipePlan = await APIService.instance
          .getRandomPopRecipes(recipeParameters: RecipeParameters());

      expect(randomRecipePlan.recipes.isNotEmpty, true);
    });
  });

  group('Spoonacular API get restaurants endpoint', () {
    test('restaurants are non empty', () async {
      // The lat and long are for UIC
      final Restaurants restaurants = await APIService.instance
          .getRestaurants(41.87283273018325, -87.64909562987724);

      expect(restaurants.restaurants.isNotEmpty, true);
    });
  });
}
