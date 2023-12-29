class Recipe {
  final int id;
  final String title;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      imageUrl: map['image'],
    );
  }
}
