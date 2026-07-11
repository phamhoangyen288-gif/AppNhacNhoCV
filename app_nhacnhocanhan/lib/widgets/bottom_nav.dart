import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/task_list_screen.dart';
import '../screens/add_task_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/settings_screen.dart';


class BottomNav extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDark;

  const BottomNav({
    super.key,
    required this.onThemeChanged,
    required this.isDark,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;



  final GlobalKey<TaskListScreenState> taskListKey =
  GlobalKey<TaskListScreenState>();

  final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  Future<void> logoutDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onMenuPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      TaskListScreen(key: taskListKey),
      const AddTaskScreen(),
      GoalsScreen(
        onBackHome: () {
          setState(() {
            index = 0;
          });
        },
      ),
      SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        isDark: widget.isDark,
      ),
    ];

    return Scaffold(
      key: scaffoldKey,

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bạn",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "minh@gmail.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const ListTile(
              title: Text(
                "QUẢN LÝ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("My Profile"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Categories / Folders"),
              onTap: () {},
            ),

            /*ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Completed Tasks"),
              onTap: () {},
            ),*/

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Completed Tasks"),
              onTap: () {
                setState(() {
                  index = 1; // chuyển sang TaskListScreen
                });

                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 150), () {
                  taskListKey.currentState?.showCompletedTasks();
                });
              },
            ),


            const Divider(),

            const ListTile(
              title: Text(
                "CÀI ĐẶT & HỖ TRỢ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                setState(() {
                  index = 4;
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.cloud_sync),
              title: const Text("Sync & Backup"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Help & Support"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {},
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text(
                      "Do you want to log out?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false),
                        child: const Text("No"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, true),
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: index,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        /*onTap: (i) async {

          if (i == 1) {
            await taskListKey.currentState?.refreshTasks();
          }

          setState(() {
            index = i;
          });
        },*/
        onTap: (i) async {
          setState(() {
            index = i;
          });

          if (i == 1) {
            taskListKey.currentState?.refreshTasks();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.flag), label: "Goals"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/task_list_screen.dart';
import '../screens/add_task_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/settings_screen.dart';

class BottomNav extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDark;

  const BottomNav({
    super.key,
    required this.onThemeChanged,
    required this.isDark,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    // 🔥 IMPORTANT: tạo screens trong build để update theme
    final screens = [
      const HomeScreen(),
      const TaskListScreen(),
      const AddTaskScreen(),
      const GoalsScreen(),
      SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        isDark: widget.isDark,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() => index = i);
        },
        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.blue, // 🔥 nền xanh

        selectedItemColor: Colors.white, // icon chọn
        unselectedItemColor: Colors.white70, // icon chưa chọn

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Goals"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
*/

