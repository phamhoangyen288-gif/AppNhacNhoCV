import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/db_helper.dart';
import '../screens/goal_detail_screen.dart';
import '../models/task.dart';
import 'package:fl_chart/fl_chart.dart';

class GoalsScreen extends StatefulWidget {
  final VoidCallback? onBackHome;

  const GoalsScreen({
    super.key,
    this.onBackHome,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}


class _GoalsScreenState extends State<GoalsScreen> {
  List<Task> tasks = [];

  int todayCount = 0;
  int incompleteCount = 0;
  int inProgressCount = 0;
  int completedCount = 0;


  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    loadGoals();
    loadStatistics();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadGoals();
    loadStatistics();
  }

  Future loadGoals() async {
    goals = await DBHelper.instance.getGoals();
    setState(() {});
  }


  Future loadStatistics() async {
    tasks = await DBHelper.instance.getTasks();

    final now = DateTime.now();

    todayCount = 0;
    incompleteCount = 0;
    inProgressCount = 0;
    completedCount = 0;

    for (var t in tasks) {
      final start =
          DateTime.tryParse(t.startDate) ?? now;

      final end =
          DateTime.tryParse(t.endDate) ?? now;

      if (t.status == "done") {
        completedCount++;
      }

      /*if (t.status == "progress") {
        inProgressCount++;
      }*/
      if (
      t.status != "done" &&
          now.isAfter(start) &&
          now.isBefore(end)
      ) {
        inProgressCount++;
      }

      if (start.year == now.year &&
          start.month == now.month &&
          start.day == now.day) {
        todayCount++;
      }

      if (t.status != "done" &&
          end.isBefore(now)) {
        incompleteCount++;
      }
    }

    setState(() {});
  }



  void openDetail(Goal? goal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GoalDetailScreen(goal: goal),
      ),
    );

    if (result == true) loadGoals();
  }

  void deleteGoal(Goal goal) async {
    await DBHelper.instance.deleteGoal(goal.id!);
    loadGoals();
  }

  Widget buildGoal(Goal g) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(g.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: g.progress / 100),
            const SizedBox(height: 4),
            Text("${g.progress}% completed"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => deleteGoal(g),
        ),
        onTap: () => openDetail(g),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goals"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onBackHome?.call();
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Text(
              "Task Statistics",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            buildPieChart(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  buildLegend(
                    Colors.blue,
                    "Today's Tasks ($todayCount)",
                  ),

                  buildLegend(
                    Colors.red,
                    "Incomplete ($incompleteCount)",
                  ),

                  buildLegend(
                    Colors.cyan,
                    "In Progress ($inProgressCount)",
                  ),

                  buildLegend(
                    Colors.green,
                    "Completed ($completedCount)",
                  ),
                ],
              ),
            ),

            const Divider(height: 30),

            ...goals.map(buildGoal).toList(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openDetail(null),
        child: const Icon(Icons.add),
      ),
    );
  }


  Widget buildPieChart() {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(
              value: todayCount.toDouble(),
              color: Colors.blue,
              title: "$todayCount",
              radius: 60,
            ),

            PieChartSectionData(
              value: incompleteCount.toDouble(),
              color: Colors.red,
              title: "$incompleteCount",
              radius: 60,
            ),

            PieChartSectionData(
              value: inProgressCount.toDouble(),
              color: Colors.cyan,
              title: "$inProgressCount",
              radius: 60,
            ),

            PieChartSectionData(
              value: completedCount.toDouble(),
              color: Colors.green,
              title: "$completedCount",
              radius: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLegend(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}





