import 'package:flutter/material.dart';
import '../models/reminders.dart';
import '../services/db_helper.dart';
import '../services/notification_service.dart';
import 'add_reminder_screen.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    list = await DBHelper.instance.getReminders();
    setState(() {});
  }

  void open(Reminder? r) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddReminderScreen(reminder: r),
      ),
    );

    if (res == true) loadData();
  }

  void toggle(Reminder r) async {
    r.isOn = r.isOn == 1 ? 0 : 1;
    await DBHelper.instance.updateReminder(r);

    if (r.isOn == 1) {
      NotificationService.show(r.id!, r.title);
    }

    loadData();
  }

  void delete(Reminder r) async {
    await DBHelper.instance.deleteReminder(r.id!);
    loadData();
  }

  Widget item(Reminder r) {
    return ListTile(
      leading: Checkbox(
        value: r.isOn == 1,
        onChanged: (_) => toggle(r),
      ),
      title: Text(r.title),
      subtitle: Text("${r.time} • ${r.repeat}"),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => delete(r),
      ),
      onTap: () => open(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminders"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: list.isEmpty
          ? const Center(child: Text("No reminders"))
          : ListView(children: list.map(item).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => open(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}







/*
import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<String> reminders = ["Drink Water", "Project Deadline"];

  void addReminder() {
    setState(() {
      reminders.add("New Reminder ${reminders.length + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminders")),
      body: ListView(
        children: reminders
            .map((r) => CheckboxListTile(
          value: true,
          onChanged: (_) {},
          title: Text(r),
        ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
} */