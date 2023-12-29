class RecipeInfo{
  final int id;
  final String sourceUrl;
  

  RecipeInfo(
    {
    required this.id,
    required this.sourceUrl
    
  });


  factory RecipeInfo.fromMap(Map<String, dynamic> map){

    // returns the object of one instance of that restaurant...
    return RecipeInfo(
      id: map['id'],
      sourceUrl: map['sourceUrl']
    );
  }

}

// get more information about a recipe through a link