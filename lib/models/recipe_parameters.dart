class RecipeParameters {
  static final RecipeParameters _recipeParameters =
      RecipeParameters._internal();

  List<String> cuisine = <String>[];
  List<String> diet = <String>[];
  List<String> intolerances = <String>[];
  String query = '';
  
  factory RecipeParameters() {
    return _recipeParameters;
  }

  RecipeParameters._internal();
}
