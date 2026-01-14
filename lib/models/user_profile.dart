class UserProfile {
  final String? id;
  final String name;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String activityLevel;
  final String goal;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final int dailyCalories;

  UserProfile({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    this.dietaryRestrictions = const [],
    this.allergies = const [],
    required this.dailyCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'activityLevel': activityLevel,
      'goal': goal,
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
      'dailyCalories': dailyCalories,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      gender: json['gender'] ?? '',
      activityLevel: json['activityLevel'] ?? '',
      goal: json['goal'] ?? '',
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      dailyCalories: json['dailyCalories'] ?? 0,
    );
  }

  double get bmi => weight / ((height / 100) * (height / 100));
}
