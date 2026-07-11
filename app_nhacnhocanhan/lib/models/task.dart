class Task {
  int? id;
  String title;
  String description;

  String startDate;
  String endDate;

  String status;
  String? priority;
  String? reminder;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.status = "todo",
    this.priority,
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'priority': priority,
      'reminder': reminder,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      status: map['status'] ?? "todo",
      priority: map['priority'],
      reminder: map['reminder'],
    );
  }
}

/*class Task {
  int? id;
  String title;
  String description;
  String date;
  String status;
  String? priority;
  String? reminder;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.status = "todo",
    this.priority,
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'status': status,
      'priority': priority,
      'reminder': reminder,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      status: map['status'] ?? 'todo',
      priority: map['priority'],
      reminder: map['reminder'],
    );
  }
}*/