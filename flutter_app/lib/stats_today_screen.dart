import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatsTodayScreen extends StatelessWidget {
  const StatsTodayScreen({super.key, this.embed = false});

  final bool embed;
  static const routeToTrends = 'trends';

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Today',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(routeToTrends),
              child: const Text('Trends', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CircularPercentIndicator(
          radius: 100,
          lineWidth: 12,
          percent: 0.5,
          progressColor: Colors.red,
          backgroundColor: Colors.grey[300]!,
          center: const Text(
            '50%',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '120',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text('Cals'),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Fat\n140g',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Protein\n100mg',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Carbs\n90g',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );

    if (embed) {
      return SafeArea(child: SingleChildScrollView(child: content));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        title: const Text('Stats'),
        centerTitle: true,
        actions: const [Icon(Icons.settings), SizedBox(width: 12)],
      ),
      body: SingleChildScrollView(child: content),
    );
  }
}
