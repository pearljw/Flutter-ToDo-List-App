class Task {
  String todo;
  DateTime timeStamp;
  bool done;

  Task({
    required this.todo,
    required this.timeStamp,
    required this.done,
  });

  // Convert Task → Map
  Map<String, dynamic> toMap() {
    return {
      'todo': todo,
      'timeStamp': timeStamp.toIso8601String(),
      'done': done,
    };
  }

  // Convert Map → Task
  factory Task.fromMap(Map task) {
    return Task(
      todo: task['todo'],
      timeStamp: DateTime.parse(task['timeStamp']),
      done: task['done'],
    );
  }
}
