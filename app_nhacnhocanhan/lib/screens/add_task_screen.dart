import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/db_helper.dart';
import '../models/reminders.dart';
import '../screens/add_reminder_screen.dart';
import '../services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});


  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  List<Reminder> reminders = [];

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;
  String priority = "Low";
  String reminder = "None";

  @override
  void initState() {
    super.initState();

    // 🔥 Nếu edit thì load dữ liệu
    if (widget.task != null) {
      titleCtrl.text = widget.task!.title;
      descCtrl.text = widget.task!.description;
      startDate = DateTime.tryParse(widget.task!.startDate ?? "");
      endDate = DateTime.tryParse(widget.task!.endDate ?? "");
    }
  }





  // 🔥 SAVE TASK

  /*void saveTask() async {
    try {
      final task = Task(
        title: titleCtrl.text,
        description: descCtrl.text,
        startDate: startDate?.toIso8601String() ?? "",
        endDate: endDate?.toIso8601String() ?? "",
        status: "progress",
        priority: priority,
        reminder: reminder,
      );

      int taskId = await DBHelper.instance.insertTask(task);

      DateTime end = endDate ?? DateTime.now();
      for (final r in reminders) {
        if (r.isOn == 1) {
          final reminderTime = r.getDateTime(endDate!);
          if (r.repeat == "Once") {
            // 🔔 schedule 1 lần
            await NotificationService.scheduleReminder(
              id: taskId + r.id!,
              title: r.title,
              scheduledTime: reminderTime,
            );

          } else if (r.repeat == "Daily") {
            // 🔁 lặp mỗi ngày (đơn giản hoá)
            for (int i = 0; i < 30; i++) {
              final dailyTime = reminderTime.add(Duration(days: i));

              await NotificationService.scheduleReminder(
                id: taskId + r.id! + i,
                title: r.title,
                scheduledTime: dailyTime,
              );
            }
          }

          await NotificationService.scheduleReminder(
            id: taskId + r.id!,
            title: r.title,
            scheduledTime: reminderTime,
          );
        }
      }

      // ❗ validate
      if (endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select end date")),
        );
        return;
      }

      // 🔔 1. NOTIFICATION KHI TỚI HẠN
      await NotificationService.schedule(
        id: taskId,
        title: "Task Due",
        body: task.title,
        scheduledDate: end,
        //quietStart: quietStart,
        //quietEnd: quietEnd,
      );

      // 🔔 2. REMINDER TRƯỚC DEADLINE
      if (reminder != "None") {
        Duration duration;

        switch (reminder) {
          case "10 min before":
            duration = const Duration(minutes: 10);
            break;
          case "1 hour before":
            duration = const Duration(hours: 1);
            break;
          default:
            duration = const Duration(minutes: 10);
        }

        final remindTime = end.subtract(duration);

        // ❗ tránh schedule trong quá khứ
        if (remindTime.isAfter(DateTime.now())) {
          await NotificationService.schedule(
            id: taskId + 1000,
            title: "Upcoming Task",
            body: task.title,
            scheduledDate: remindTime,
          );
        }
      }

      Navigator.pop(context, true);
    } catch (e) {
      print("ERROR: $e");
    }
  }*/



  void saveTask() async {
    try {
      print("SAVE CLICK");

      final task = Task(
        title: titleCtrl.text,
        description: descCtrl.text,
        startDate: (startDate ?? DateTime.now()).toString(),
        endDate: (endDate ?? DateTime.now()).toString(),
        status: "progress",
        priority: priority,
        reminder: reminder,
      );

      print("BEFORE INSERT TASK");

      int taskId =
      await DBHelper.instance.insertTask(task);

      print("TASK INSERTED: $taskId");

      Navigator.pop(context, true);

    } catch (e) {
      print("ERROR: $e");
    }
  }

  //HÀM CHỌN NGÀY BẮT ĐẦU
  Future pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }


  //HÀM CHỌN NGÀY KẾT THÚC
  Future pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// 🔥 HEADER giống Home
      appBar: AppBar(
        title: const Text("Add Task"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// 🔥 TASK NAME
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Task Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 DESCRIPTION
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                final r = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddReminderScreen(),
                  ),
                );

                if (r != null) {
                  setState(() {
                    reminders.add(r);
                  });
                }
              },
              child: const Text("+ Add Reminder"),
            ),


            Column(
              children: reminders.map((r) {
                return ListTile(
                  title: Text(r.title),
                  subtitle: Text("${r.time} • ${r.repeat}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        reminders.remove(r);
                      });
                    },
                  ),
                );
              }).toList(),
            ),





        //UI NGY BẮT ĐẦU
  GestureDetector(
  onTap: pickStartDate,
  child: Container(
  padding: const EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 16,
  ),
  decoration: BoxDecoration(
  border: Border.all(color: Colors.grey),
  borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
  startDate == null
  ? "Select Start Date"
      : DateFormat(
  'yyyy-MM-dd',
  ).format(startDate!),
  ),
  ),
  ),

            const SizedBox(height: 16),
  // UI NGÀY KẾT THÚC
  GestureDetector(
  onTap: pickEndDate,
  child: Container(
  padding: const EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 16,
  ),
  decoration: BoxDecoration(
  border: Border.all(color: Colors.grey),
  borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
  endDate == null
  ? "Select End Date"
      : DateFormat(
  'yyyy-MM-dd',
  ).format(endDate!),
  ),
  ),
  ),
            const SizedBox(height: 16),
            /// 🔥 PRIORITY
            DropdownButtonFormField(
              value: priority,
              decoration: const InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
              items: ["Low", "Medium", "High"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) {
                setState(() => priority = val.toString());
              },
            ),

            const SizedBox(height: 16),

            /// 🔥 REMINDER
            DropdownButtonFormField(
              value: reminder,
              decoration: const InputDecoration(
                labelText: "Reminder",
                border: OutlineInputBorder(),
              ),
              items: ["None", "10 min before", "1 hour before"]
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) {
                setState(() => reminder = val.toString());
              },
            ),

            const SizedBox(height: 24),

            /// 🔥 SAVE BUTTON
            ElevatedButton(
              onPressed: saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}


