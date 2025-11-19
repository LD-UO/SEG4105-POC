import 'ingredient.dart';

class AiResult {
  final double calories;
  final List<Ingredient> ingredients;
  final String? message;
  final String? analysisId;

  AiResult({
    required this.calories,
    required this.ingredients,
    this.message,
    this.analysisId,
  });

  factory AiResult.fromJson(Map<String, dynamic> json) {
    return AiResult(
      calories: (json['calories'] as num).toDouble(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map(
            (e) => Ingredient(
              name: e['name'] as String,
              grams: (e['grams'] as num).toDouble(),
            ),
          )
          .toList(),
      message: json['message'] as String?,
      analysisId: json['analysisId'] as String?,
    );
  }
}
