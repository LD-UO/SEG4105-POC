import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final meals = List.generate(3, (index) => 'Meal ${index + 1}');

    final content = ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(meals[index]),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {},
          child: const MealCard(),
        );
      },
    );

    if (embed) {
      return content;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('History'),
        centerTitle: true,
        leading: const Icon(Icons.person),
        actions: const [Icon(Icons.settings), SizedBox(width: 12)],
      ),
      body: content,
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Meal Name - 12:00:00',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Ingredients:\nthing 1, thing 2, thing 3'),
                  SizedBox(height: 4),
                  Text('Calories 500'),
                  Text('Fat 10g'),
                  Text('Carbs 55g'),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, size: 30),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
