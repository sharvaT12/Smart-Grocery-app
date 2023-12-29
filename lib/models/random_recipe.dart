class Random_Recipe {
  final int id;
  final String title;
  final String imageUrl;
  // final bool veryPop;
  final int likes;

  Random_Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    // required this.veryPop,
    required this.likes
  });

  factory Random_Recipe.fromMap(Map<String, dynamic> map) {
    return Random_Recipe(
      id: map['id'],
      title: (map['title'] == null)? 'No Title' : map['title'],
      imageUrl: (map['image'] == null)? 'No Image' : map['image'],
      // veryPop: map['veryPopular'],
      likes: map['aggregateLikes']
    );
  }

}
