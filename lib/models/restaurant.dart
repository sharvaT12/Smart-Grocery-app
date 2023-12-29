class Restaurant {
  final String id;
  final String name;
  final String description;
  final weighted_rating_value;
  final String dollar_signs;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    this.weighted_rating_value = 0.0,
    required this.dollar_signs,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    // returns the object of one instance of that restaurant...
    return Restaurant(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      weighted_rating_value: (map['weighted_rating_value'] == null)
          ? 'No rating...'
          : map['weighted_rating_value'],
      dollar_signs: (map['dollar_signs'] == 1)
          ? "\$"
          : (map['dollar_signs'] == 2)
              ? "\$\$"
              : (map['dollar_signs'] == 3)
                  ? "\$\$\$"
                  : (map['dollar_signs'] == 4)
                      ? "\$\$\$\$"
                      : "\$\$\$\$\$",
    );
  }
}
