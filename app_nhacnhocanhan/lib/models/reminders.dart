
class Reminder {
  int? id;
  String title;
  String time; // "08:00"
  String repeat; // Daily / Once
  int isOn;
  int? taskId;
  bool enableNotifications = true;

  Reminder({
    this.id,
    required this.title,
    required this.time,
    required this.repeat,
    this.isOn = 1,
    this.taskId,
  });

  // 🔥 convert "08:00" → DateTime hôm nay
  DateTime getDateTime(DateTime baseDate) {
    final parts = time.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour,
      minute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'repeat': repeat,
      'isOn': isOn,
      'taskId': taskId,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      time: map['time'],
      repeat: map['repeat'],
      isOn: map['isOn'],
      taskId: map['taskId'],
    );
  }
}



/*class Reminder {
  int? id;
  String title;
  String time; // "08:00"
  String repeat; // Daily / Once
  int isOn; // 1 = bật, 0 = tắt
  int? taskId;

  Reminder({
    this.id,
    required this.title,
    required this.time,
    required this.repeat,
    this.isOn = 1,
    this.taskId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'repeat': repeat,
      'isOn': isOn,
      'taskId': taskId,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      time: map['time'],
      repeat: map['repeat'],
      isOn: map['isOn'],
      taskId: map['taskId'],
    );
  }
}*/