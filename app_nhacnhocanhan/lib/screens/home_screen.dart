import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/db_helper.dart';
import 'package:flutter/widgets.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const HomeScreen({
    super.key,
    this.onMenuPressed,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  List<Task> tasks = [];

  int todayCount = 0;
  int incompleteCount = 0;
  int inProgressCount = 0;
  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    loadTasks(); // 🔥 quay lại Home → reload data
  }


  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }


  //HÀM LOGOUT
  Future<void> logoutDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
            (route) => false,
      );
    }
  }



  /*Future loadTasks() async {
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

      if (t.status == "progress") {
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
  }*/


  Future loadTasks() async {
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
      t.status != "done"
          &&
          end.isAfter(now)
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

  void toggleTask(Task task) async {
    task.status = task.status == "done" ? "todo" : "done";
    await DBHelper.instance.updateTask(task);
    loadTasks();
  }

  // 🔥 CARD
  Widget buildCard(String title, int value, Color color, String filter) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/tasks",
          arguments: filter,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 10),
            Text("$value",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 🔥 TASK ITEM
  Widget buildTask(Task task) {
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
      subtitle: Text(
        "${task.startDate} → ${task.endDate}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(


      /// 🔥 APPBAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                widget.onMenuPressed?.call();
              },
            );
          },
        ),

        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 👋 GREETING
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Chào bạn",
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 CARD GRID
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildCard("Today's Tasks", todayCount, Colors.blue, "today"),
                buildCard(
                  "Incomplete",
                  incompleteCount,
                  Colors.red,
                  "incomplete",
                ),
                buildCard(
                    "In Progress", inProgressCount, Colors.cyan, "progress"),
                buildCard("Completed", completedCount, Colors.green, "done"),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔥 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Tasks",
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/calendar");
                  },
                  child: const Text("View Calendar"),
                )
              ],
            ),

            /// 🔥 TASK LIST
            Expanded(
              child: ListView(
                children: tasks
                    .where((t) {
                  final now = DateTime.now();
                  final d =
                      DateTime.tryParse(t.startDate) ?? now;
                  return d.day == now.day &&
                      d.month == now.month &&
                      d.year == now.year;
                })
                    .map(buildTask)
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









