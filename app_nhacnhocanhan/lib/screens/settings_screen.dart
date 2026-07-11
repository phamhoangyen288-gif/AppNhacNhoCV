import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDark;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDark,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


// CÁC CHỨC NĂNG
class _SettingsScreenState extends State<SettingsScreen> {

  bool enableNotifications = true;

  String remindBefore = "15 minutes";

  String repeatOption = "Off";

  bool notifyOverdue = true;
  bool notifyToday = true;

  TimeOfDay quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay quietEnd = const TimeOfDay(hour: 7, minute: 0);

  bool dailySummary = true;

  bool soundOn = true;
  bool vibrateOn = true;

  String language = "English";

  Widget buildItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void changeLanguage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                onTap: () {
                  setState(() => language = "English");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Vietnamese"),
                onTap: () {
                  setState(() => language = "Vietnamese");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showInfo(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text("$title clicked"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

//HÀM MAIN NOTIFICATION
  void openNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Notification Settings"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text("Enable Notifications"),
                      value: enableNotifications,
                      onChanged: (val) async {
                        setModalState(() {
                          enableNotifications = val;
                        });

                        setState(() {});

                        // 🔥 QUAN TRỌNG: tắt toàn bộ notification khi OFF
                        if (!val) {
                          await NotificationService.cancelAll();
                        }
                      },
                    ),
                    /*SwitchListTile(
                      title: const Text("Enable Notifications"),
                      value: enableNotifications,
                      onChanged: (val) {
                        setModalState(() {
                          enableNotifications = val;
                        });
                        setState(() {});
                      },
                    ),*/

                    const Divider(),

                    ListTile(
                      title: const Text("Remind before deadline"),
                      subtitle: Text(remindBefore),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => SimpleDialog(
                            title: const Text("Remind Before"),
                            children: ["5 minutes", "15 minutes", "1 hour", "1 day"]
                                .map((e) {
                              return SimpleDialogOption(
                                child: Text(e),
                                onPressed: () {
                                  setModalState(() {
                                    remindBefore = e;
                                  });
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      title: const Text("Notify overdue tasks"),
                      value: notifyOverdue,
                      onChanged: (v) {
                        setModalState(() {
                          notifyOverdue = v;
                        });
                        setState(() {});
                      },
                    ),

                    SwitchListTile(
                      title: const Text("Notify tasks due today"),
                      value: notifyToday,
                      onChanged: (v) {
                        setModalState(() {
                          notifyToday = v;
                        });
                        setState(() {});
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      title: const Text("Daily Summary"),
                      value: dailySummary,
                      onChanged: (v) {
                        setModalState(() {
                          dailySummary = v;
                        });
                        setState(() {});
                      },
                    ),

                    const Divider(),

                    SwitchListTile(
                      title: const Text("Sound"),
                      value: soundOn,
                      onChanged: (v) {
                        setModalState(() {
                          soundOn = v;
                        });
                        setState(() {});
                      },
                    ),

                    SwitchListTile(
                      title: const Text("Vibration"),
                      value: vibrateOn,
                      onChanged: (v) {
                        setModalState(() {
                          vibrateOn = v;
                        });
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                )
              ],
            );
          },
        );
      },
    );
  }


  /*
  void openNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Notification Settings"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildNotificationGeneral(),
                const Divider(),
                buildDeadlineReminder(),
                const Divider(),
                buildRepeatReminder(),
                const Divider(),
                buildStatusNotification(),
                const Divider(),
                buildQuietHours(),
                const Divider(),
                buildDailySummary(),
                const Divider(),
                buildSoundSettings(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }



  Widget buildNotificationGeneral() {
    return SwitchListTile(
      title: const Text("Enable Notifications"),
      value: enableNotifications,
      onChanged: (val) {
        setState(() => enableNotifications = val);
      },
    );
  }

  Widget buildDeadlineReminder() {
    return ListTile(
      title: const Text("Remind before deadline"),
      subtitle: Text(remindBefore),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => SimpleDialog(
            title: const Text("Remind Before"),
            children: [
              "5 minutes",
              "15 minutes",
              "1 hour",
              "1 day"
            ].map((e) {
              return SimpleDialogOption(
                child: Text(e),
                onPressed: () {
                  setState(() => remindBefore = e);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }


  Widget buildRepeatReminder() {
    return ListTile(
      title: const Text("Repeat reminders"),
      subtitle: Text(repeatOption),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => SimpleDialog(
            title: const Text("Repeat Option"),
            children: [
              "Off",
              "Every 10 minutes",
              "Every 30 minutes",
              "Every 1 hour",
              "Until completed",
            ].map((e) {
              return SimpleDialogOption(
                child: Text(e),
                onPressed: () {
                  setState(() => repeatOption = e);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }


  Widget buildStatusNotification() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Notify overdue tasks"),
          value: notifyOverdue,
          onChanged: (v) => setState(() => notifyOverdue = v),
        ),
        SwitchListTile(
          title: const Text("Notify tasks due today"),
          value: notifyToday,
          onChanged: (v) => setState(() => notifyToday = v),
        ),
      ],
    );
  }


  Widget buildQuietHours() {
    return Column(
      children: [
        ListTile(
          title: const Text("Quiet hours start"),
          trailing: Text(quietStart.format(context)),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: quietStart,
            );
            if (picked != null) {
              setState(() => quietStart = picked);
            }
          },
        ),
        ListTile(
          title: const Text("Quiet hours end"),
          trailing: Text(quietEnd.format(context)),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: quietEnd,
            );
            if (picked != null) {
              setState(() => quietEnd = picked);
            }
          },
        ),
      ],
    );
  }


  Widget buildDailySummary() {
    return SwitchListTile(
      title: const Text("Daily task summary (8:00 AM)"),
      value: dailySummary,
      onChanged: (v) => setState(() => dailySummary = v),
    );
  }


  Widget buildSoundSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Sound"),
          value: soundOn,
          onChanged: (v) => setState(() => soundOn = v),
        ),
        SwitchListTile(
          title: const Text("Vibration"),
          value: vibrateOn,
          onChanged: (v) => setState(() => vibrateOn = v),
        ),
      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          buildItem(
            icon: Icons.person,
            title: "Account Settings",
            onTap: () => showInfo("Account Settings"),
          ),
          buildItem(
            icon: Icons.notifications,
            title: "Notification Settings",
            //onTap: () => showInfo("Notification Settings"),
            onTap: openNotificationSettings,
          ),

          // 🌙 DARK MODE
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: Colors.blue),
            title: const Text("Dark Mode"),
            value: widget.isDark,
            onChanged: (val) {
              widget.onThemeChanged(val);
              /*setState(() {}); // refresh UI*/
            },
          ),

          // 🌐 LANGUAGE
          buildItem(
            icon: Icons.language,
            title: "Language",
            trailing: Text(language),
            onTap: changeLanguage,
          ),

          buildItem(
            icon: Icons.help,
            title: "Help & Support",
            onTap: () => showInfo("Help & Support"),
          ),
        ],
      ),
    );
  }
}