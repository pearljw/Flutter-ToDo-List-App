import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/models/task.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  double? _deviceHeight, _deviceWidth;
  String? content;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: const Text(
          "Daily Planner",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _tasksWidget(),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        onPressed: displayTaskPop,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _todoList() {
    List tasks = _box!.values.toList();

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks yet.\nTap + to add a new task!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            leading: Icon(
              task.done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.done ? Colors.green : Colors.grey,
              size: 28,
            ),

            title: Text(
              task.todo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration:
                task.done ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),

            subtitle: Text(
              task.timeStamp.toString(),
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),

            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _box!.deleteAt(index);
                setState(() {});
              },
            ),

            onTap: () {
              task.done = !task.done;
              _box!.putAt(index, task.toMap());
              setState(() {});
            },
          ),
        );
      },
    );
  }

  Widget _tasksWidget() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _todoList();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void displayTaskPop() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add a new ToDo"),
          content: TextField(
            onSubmitted: (value) {
              if (content != null) {
                var task = Task(
                  todo: content!,
                  timeStamp: DateTime.now(),
                  done: false,
                );
                _box!.add(task.toMap());
              }
              setState(() {});
              Navigator.pop(context);
            },

            onChanged: (value) {
              content = value;
            },
            decoration: const InputDecoration(
              hintText: "Enter task",
            ),
          ),
        );
      },
    );
  }
}
