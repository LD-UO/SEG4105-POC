import 'dart:io';
import 'package:flutter/material.dart';
import 'models/ingredient.dart';
import 'widgets/ingredient_list.dart';

class AIPreviewPage extends StatelessWidget {
  final File imageFile;
  // Sample data - replace with actual AI detection results
  final List<Ingredient> sampleIngredients = [
    Ingredient(name: 'Flour', grams: 250.0),
    Ingredient(name: 'Sugar', grams: 100.0),
    Ingredient(name: 'Butter', grams: 125.5),
    Ingredient(name: 'Eggs', grams: 120.0),
  ];

  AIPreviewPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.file(imageFile, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Calories:595 kcal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(onPressed: null, child: Icon(Icons.thumb_down),),
                ElevatedButton(onPressed: null, child: Icon(Icons.thumb_up),),
              ],
            )
            ,
            const SizedBox(height: 16),
            IngredientListWidget(ingredients: sampleIngredients),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Placeholder for AI processing
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI Processing Complete')),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
