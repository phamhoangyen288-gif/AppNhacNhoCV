import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';
import 'screens/task_list_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart'; // Đảm bảo đã import màn hình chính của bạn
import 'package:timezone/data/latest.dart' as tz;
import '../services/notification_service.dart';

// Import các file xác thực
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/forgot_password_screen.dart';
import 'auth/welcome_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.init();

  runApp(const MyApp());
}

final RouteObserver<ModalRoute> routeObserver =
RouteObserver<ModalRoute>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      navigatorObservers: [routeObserver],

      debugShowCheckedModeBanner: false,
      title: 'Quản lý công việc',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      // 🚀 Bắt đầu từ màn hình Đăng nhập
      initialRoute: '/login',

      routes: {
        // Các route xác thực
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),

        '/welcome': (context) => const WelcomeScreen(),

        // Route chính sau khi đăng nhập
        '/home': (context) => BottomNav(
          onThemeChanged: toggleTheme,
          isDark: isDark,
        ),

        // Các route khác
        "/tasks": (context) => const TaskListScreen(),
        "/calendar": (context) => const CalendarScreen(),
      },
    );
  }
}






/*
import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';
import 'screens/task_list_screen.dart';
import 'screens/calendar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  // 🔥 Hàm đổi theme
  void toggleTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý công việc',

      // 🌞 Light Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      // 🌙 Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      // 🔁 Switch theme
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      routes: {
        "/tasks": (context) => const TaskListScreen(),
        "/calendar": (context) => const CalendarScreen(),
      },

      // 🚀 Home chính là BottomNav
      home: BottomNav(
        onThemeChanged: toggleTheme,
        isDark: isDark,
      ),
    );
  }
}
*/



/*
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý công việc',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      initialRoute: "/",

      routes: {
        "/": (context) => const HomeScreen(),
        "/tasks": (context) => const TaskListScreen(),
        "/add": (context) => const AddTaskScreen(),
        "/calendar": (context) => const CalendarScreen(),
        "/goals": (context) => const GoalsScreen(),
        "/reminders": (context) => const RemindersScreen(),
        "/statistics": (context) => const StatisticsScreen(),
        "/settings": (context) => SettingsScreen(
          onThemeChanged: toggleTheme,
          isDark: isDark,
        ),
      },
    );
  }
}*/