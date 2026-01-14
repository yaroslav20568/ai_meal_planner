class Meal {
  final String name;
  final String description;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final List<String> ingredients;
  final String mealType;
  final String? recipe;

  Meal({
    required this.name,
    required this.description,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.ingredients,
    required this.mealType,
    this.recipe,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'ingredients': ingredients,
      'mealType': mealType,
      'recipe': recipe,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      proteins: (json['proteins'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      mealType: json['mealType'] ?? '',
      recipe: json['recipe'],
    );
  }
}
