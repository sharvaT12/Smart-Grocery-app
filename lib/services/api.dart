import 'dart:convert';
import 'package:smart_grocery_app/models/recipe_info.dart';
import 'package:smart_grocery_app/models/recipe_parameters.dart';
import 'package:smart_grocery_app/models/recipe_plan.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_grocery_app/models/restaurants.dart';

// This file will handle all our API calls to the spoonacular api

import '../models/random_recipe_plan.dart';


class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUri = 'api.spoonacular.com';
  static const String _apiKey = '6116ac42503f442893532bf2663b9015';

  Future<RecipePlan> getRecipes(
      {required RecipeParameters recipeParameters}) async {
    // No precondition checks yet
    // if (recipeParameters.diet == 'None') recipeParameters.diet = '';

    // Build parameter arguments for the uri
    // join method joins all strings together with the ',' as
    // the delimiter between strings
    Map<String, String> parameters = {
      'query': recipeParameters.query,
      'cuisine': recipeParameters.cuisine.join(','),
      'diet': recipeParameters.diet.join(','),
      'intolerances': recipeParameters.intolerances.join(','),
      'number': '24',
      'apiKey': _apiKey,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri uri = Uri.https(
      _baseUri,
      '/recipes/complexSearch',
      parameters,
    );

    try {
      var resp = await http.get(uri, headers: headers);

      Map<String, dynamic> data = json.decode(resp.body);

      RecipePlan recipePlan = RecipePlan.fromMap(data);

      return recipePlan;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<random_recipe_plan> getRandomPopRecipes(
      {required RecipeParameters recipeParameters}) async {
    // No precondition checks yet
    // if (recipeParameters.diet == 'None') recipeParameters.diet = '';

    List<String> temp = <String>[];
    
    if (recipeParameters.cuisine.isNotEmpty)
    {
      temp += recipeParameters.cuisine;
    }

    if (recipeParameters.diet.isNotEmpty)
    {
      temp += recipeParameters.diet;
    }

    if (recipeParameters.intolerances.isNotEmpty)
    {
      temp += recipeParameters.intolerances;
    }
    
    // Build parameter arguments for the uri
    // join method joins all strings together with the ',' as
    // the delimiter between strings
    Map<String, String> parameters = {
      'limitLicense': 'true',
      // 'tags': (temp.isEmpty)? '' : temp.join(','),
      'tags' : '',
      'number': '40',
      'apiKey': _apiKey
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri uri = Uri.https(
      _baseUri,
      '/recipes/random',
      parameters,
    );

    try {
      var resp = await http.get(uri, headers: headers);

      Map<String, dynamic> data = json.decode(resp.body);
    
      random_recipe_plan recipePlan = random_recipe_plan.fromMap(data);

      return recipePlan;
    } catch (err) {
      throw err.toString();
  }}


  // search restaurants
  Future<Restaurants> getRestaurants(double lat, double lng) async {

    // {required double lat, required double lng}
    
    // the parameter passed will be passed in the class
    Map<String, String> parameters = {
      'query': '',
      'distance': '1',
      'lat': lat.toString(),
      'lng': lng.toString(),
      'apiKey': _apiKey,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri uri = Uri.https(
      _baseUri,
      '/food/restaurants/search',
      parameters,
    );
  
    try {
      
      var resp = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(resp.body);
      Restaurants restaurants = Restaurants.fromMap(data);

      // return the restaurants class
      return restaurants; 
      
    } catch (err) {
      throw err.toString();
    }
  }

  // get recipe link
  Future<RecipeInfo> getRecipeInfo(int id, bool includeNutrition) async {

    // the parameter passed will be passed in the class
    Map<String, String> parameters = {
      'id': id.toString(),
      'includeNutrition':includeNutrition.toString(),
      'apiKey': _apiKey,
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    Uri uri = Uri.https(
      _baseUri,
      '/recipes/${id}/information',
      parameters,
    );
  
    try {
 
      var resp = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(resp.body);
      RecipeInfo recipeInfo = RecipeInfo.fromMap(data);
     
      // return the recipeInfo class
      return recipeInfo;
      
    } catch (err) {
      print("error here at api.dart");
      throw err.toString();
    }
  }
}