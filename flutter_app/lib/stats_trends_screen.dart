import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsTrendsScreen extends StatelessWidget {
  const StatsTrendsScreen({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text('Today', style: TextStyle(color: Colors.grey)),
            Text('Trends',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BarChart(
              BarChartData(
                barGroups: [
                  _buildBar(0, 2000),
                  _buildBar(1, 3500),
                  _buildBar(2, 1000),
                  _buildBar(3, 2000),
                  _buildBar(4, 2000),
                  _buildBar(5, 2000),
                  _buildBar(6, 2000),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => const Text('Date'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );

    if (embed) {
      return SafeArea(child: content);
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
      body: content,
    );
  }

  BarChartGroupData _buildBar(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: Colors.grey, width: 20),
    ]);
  }
}
