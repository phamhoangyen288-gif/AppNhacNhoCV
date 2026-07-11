import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Task Overview"),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(sections: [
                  PieChartSectionData(value: 40, title: "Done"),
                  PieChartSectionData(value: 30, title: "Doing"),
                  PieChartSectionData(value: 30, title: "Todo"),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Weekly Productivity"),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}