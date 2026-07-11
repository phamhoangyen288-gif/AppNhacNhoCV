import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/db_helper.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal? goal;

  const GoalDetailScreen({super.key, this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  final titleCtrl = TextEditingController();
  double progress = 0;

  @override
  void initState() {
    super.initState();

    if (widget.goal != null) {
      titleCtrl.text = widget.goal!.title;
      progress = widget.goal!.progress.toDouble();
    }
  }




  void saveGoal() async {
    try {
      print("Saving goal...");

      if (titleCtrl.text.isEmpty) {
        print("Title empty");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter goal name")),
        );
        return;
      }

      final goal = Goal(
        title: titleCtrl.text,
        progress: progress.toInt(),
      );

      print("Goal created");

      if (widget.goal == null) {
        await DBHelper.instance.insertGoal(goal);
        print("Inserted into DB");
      } else {
        goal.id = widget.goal!.id;
        await DBHelper.instance.updateGoal(goal);
        print("Updated DB");
      }

      Navigator.pop(context, true);
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Goal Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Goal Name"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveGoal,
              child: const Text("Save"),
            ),


            Text("Progress: ${progress.toInt()}%"),

            Slider(
              value: progress,
              min: 0,
              max: 100,
              divisions: 100,
              label: progress.toInt().toString(),
              onChanged: (val) {
                setState(() => progress = val);
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveGoal,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}