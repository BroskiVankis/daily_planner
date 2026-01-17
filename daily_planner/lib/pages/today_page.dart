import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../widgets/add_task_dialog.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final List<Task> _tasks = [];

  void _addTask() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (result == null) return;
    final title = result.trim();
    if (title.isEmpty) return;

    setState(() {
      _tasks.add(Task(title: title));
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateText =
        '${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}';

    return Scaffold(
      appBar: AppBar(title: Text(dateText), centerTitle: false),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks for today. Tap + to add one!'))
          : ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  value: _tasks[index].isDone,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _tasks[index].isDone = newValue ?? false;
                    });
                  },
                  title: Text(
                    _tasks[index].title,
                    style: TextStyle(
                      decoration: _tasks[index].isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _weekday(int weekday) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[weekday - 1];
}

String _month(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[month - 1];
}
