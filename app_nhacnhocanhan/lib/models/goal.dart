class Goal {
  int? id;
  String title;
  int progress; // 0 - 100

  Goal({
    this.id,
    required this.title,
    this.progress = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'progress': progress,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      title: map['title'],
      progress: map['progress'],
    );
  }
}