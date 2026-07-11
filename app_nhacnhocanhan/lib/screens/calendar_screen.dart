import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../services/db_helper.dart';
import 'add_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<Task> allTasks = [];
  List<Task> selectedTasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future loadTasks() async {
    allTasks = await DBHelper.instance.getTasks();
    filterTasks();
  }

  void filterTasks() {

    selectedTasks = allTasks.where((t) {

      final start =
      DateTime.tryParse(t.startDate);

      final end =
      DateTime.tryParse(t.endDate);

      if (start == null || end == null) {
        return false;
      }

      final current = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );

      final startOnly = DateTime(
        start.year,
        start.month,
        start.day,
      );

      final endOnly = DateTime(
        end.year,
        end.month,
        end.day,
      );

      return !current.isBefore(startOnly) &&
          !current.isAfter(endOnly);

    }).toList();

    setState(() {});
  }

  void openEdit(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(task: task),
      ),
    );

    if (result == true) {
      loadTasks();
    }
  }

  Widget buildTask(Task task) {
    return ListTile(
      leading: Checkbox(
        value: task.status == "done",
        onChanged: (_) async {
          task.status = task.status == "done" ? "todo" : "done";
          await DBHelper.instance.updateTask(task);
          loadTasks();
        },
      ),
      title: Text(task.title),
      subtitle: Text(task.description),
      onTap: () => openEdit(task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// 🔥 HEADER giống Home + nút BACK
      appBar: AppBar(
        title: const Text("Calendar"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          /// 📅 CALENDAR
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(day, selectedDay),

            onDaySelected: (selected, focused) {
              selectedDay = selected;
              focusedDay = focused;
              filterTasks();
            },

            calendarStyle: const CalendarStyle(
              todayDecoration:
              BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration:
              BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 TODAY'S SCHEDULE
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "Today's Schedule",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          /// 🔥 TASK LIST
          Expanded(
            child: selectedTasks.isEmpty
                ? const Center(child: Text("No tasks"))
                : ListView.builder(
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                return buildTask(selectedTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: today,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(day, today),
            onDaySelected: (selectedDay, _) {
              setState(() => today = selectedDay);
            },
          ),
          const SizedBox(height: 10),
          const Text("Today's Schedule"),
          ListTile(
            leading: const Icon(Icons.circle, size: 10),
            title: const Text("Team Meeting"),
            subtitle: const Text("9:00 AM"),
          ),
        ],
      ),
    );
  }
} */