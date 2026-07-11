import 'package:flutter/material.dart';
import '../models/reminders.dart';
import '../services/db_helper.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminder;

  const AddReminderScreen({super.key, this.reminder});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final titleCtrl = TextEditingController();
  String time = "08:00";
  DateTime? parseTime(String time) {
    try {
      final parts = time.split(":");
      return DateTime(0, 0, 0,
          int.parse(parts[0]),
          int.parse(parts[1]));
    } catch (e) {
      return null;
    }
  }
  String repeat = "Daily";

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      titleCtrl.text = widget.reminder!.title;
      time = widget.reminder!.time;
      repeat = widget.reminder!.repeat;
    }
  }

  void save() async {
    final r = Reminder(
      title: titleCtrl.text,
      time: time,
      repeat: repeat,
    );

    if (widget.reminder == null) {
      await DBHelper.instance.insertReminder(r);
    } else {
      r.id = widget.reminder!.id;
      await DBHelper.instance.updateReminder(r);
    }

    Navigator.pop(context, r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Reminder")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: time,
              items: ["08:00", "12:00", "18:00"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => time = v!),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: repeat,
              items: ["Daily", "Once"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => repeat = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}