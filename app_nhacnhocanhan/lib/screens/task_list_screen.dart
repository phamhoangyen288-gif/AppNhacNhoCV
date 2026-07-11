import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/db_helper.dart';
import 'add_task_screen.dart';
import '../services/notification_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];

  late TabController _tabController;

  final tabs = ["All", "To Do", "In Progress", "Completed","Incomplete"];

  void showCompletedTasks() {
    _tabController.index = 3; // tab Completed
    filterTasks();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    loadTasks();

    _tabController.addListener(() {
      filterTasks();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔥 nhận filter từ Home
    final filter = ModalRoute.of(context)?.settings.arguments;

    if (filter != null) {
      switch (filter) {
        case "today":
          _tabController.index = 0;
          break;

        case "incomplete":
          _tabController.index = 4;
          break;
        case "progress":
          _tabController.index = 2;
          break;
        case "done":
          _tabController.index = 3;
          break;
      }
    }
    loadTasks();
  }


  Future refreshTasks() async {
    await loadTasks();
  }


  Future loadTasks() async {
    tasks = await DBHelper.instance.getTasks();
    print("RELOAD TASK LIST");

    for (var t in tasks) {
      print("${t.title} - ${t.status}");
    }

    filterTasks();
    setState(() {});
  }


  void filterTasks() {
    switch (_tabController.index) {
      case 0:
        filteredTasks = tasks;
        break;

      case 1:
        filteredTasks = tasks.where((t) => t.status == "todo").toList();
        break;

      case 2:
        final now = DateTime.now();
        filteredTasks = tasks.where((t) {
          final end = DateTime.tryParse(t.endDate);
          if (end == null) return false;
          return t.status != "done" && end.isAfter(now);
        }).toList();
        break;

      case 3:
        filteredTasks = tasks.where((t) => t.status == "done").toList();
        break;

      case 4:
        filteredTasks = tasks.where((t) {
          final end = DateTime.tryParse(t.endDate);
          if (end == null) return false;
          return t.status != "done" && end.isBefore(DateTime.now());
        }).toList();
        break;
    }

    setState(() {});
  }

  /*void filterTasks() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          filteredTasks = tasks;
          break;
        /*case 0:
          final now = DateTime.now();

          filteredTasks = tasks.where((t) {

            final end =
            DateTime.tryParse(t.endDate);

            if (end == null) return false;

            return t.status != "done"
                && end.isBefore(now);

          }).toList();
          break;*/
        case 1:
          filteredTasks =
              tasks.where((t) => t.status == "todo").toList();
          break;
        /*case 2:
          filteredTasks =
              tasks.where((t) => t.status == "progress").toList();
          break;*/
        case 2:

          final now = DateTime.now();

          filteredTasks =
              tasks.where((t) {

                final end =
                DateTime.tryParse(t.endDate);

                if (end == null) return false;

                return
                  t.status != "done"
                      &&
                      end.isAfter(now);

              }).toList();

          break;
        case 3:
          filteredTasks =
              tasks.where((t) => t.status == "done").toList();
          break;
        case 4:
          filteredTasks = tasks.where((t) {

            final end =
            DateTime.tryParse(t.endDate);

            if (end == null) return false;

            return t.status != "done"
                && end.isBefore(DateTime.now());

          }).toList();
          break;
        /*case 4:

          final now = DateTime.now();

          filteredTasks =
              tasks.where((t) {

                final end =
                DateTime.tryParse(t.endDate);

                if (end == null) return false;

                return
                  t.status != "done"
                      &&
                      end.isBefore(now);

              }).toList();

          break;*/
      }
    });
  }*/

  void toggleTask(Task task) async {
    task.status = task.status == "done" ? "progress" : "done";
    await DBHelper.instance.updateTask(task);
    await loadTasks();
  }

  //HÀM XÓA TASK
  void deleteTask(Task task) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {

      // 🔥 1. CANCEL NOTIFICATION TRƯỚC
      await NotificationService.cancel(task.id!);
      await NotificationService.cancel(task.id! + 1000);

      // 🗑 2. DELETE TASK FROM DB
      await DBHelper.instance.deleteTask(task.id!);

      // 🔄 3. RELOAD UI
      loadTasks();
    }
  }


  /*void deleteTask(Task task) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper.instance.deleteTask(task.id!);
      loadTasks();
    }
  }*/



  void openEdit(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(task: task),
      ),
    );

    if (result == true) {
      loadTasks();

      setState(() {});
    }
  }


  Widget buildTaskItem(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: task.status == "done",
          onChanged: (_) => toggleTask(task),
        ),

        title: Text(
          task.title,
          style: TextStyle(
            decoration:
            task.status == "done" ? TextDecoration.lineThrough : null,
          ),
        ),

        subtitle: Text(task.description),

        // 🔥 HIỂN THỊ NGÀY BÊN PHẢI
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 📅 DATE
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Start",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  task.startDate.split(" ").first,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  task.endDate.split(" ").first,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // ✏️ EDIT BUTTON
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => openEdit(task),
            ),

            // 🗑️ DELETE BUTTON
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteTask(task),
            ),
          ],
        ),

        onTap: () => openEdit(task),
      ),
    );
  }
/*
  Widget buildTaskItem(Task task) {
    return ListTile(
      leading: Checkbox(
        value: task.status == "done",
        onChanged: (_) => toggleTask(task),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
          task.status == "done" ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Text(
        task.date.split(" ").first, // lấy ngày
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () => openEdit(task),
    );
  }*/


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// 🔥 HEADER giống Home (không avatar)
      appBar: AppBar(
        title: const Text("Task List"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          /// 🔥 TAB BAR
          TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
          ),

          /// 🔥 TASK LIST
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text("No tasks"))
                : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return buildTaskItem(filteredTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}








