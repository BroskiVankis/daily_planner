import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_tile.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();

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

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${_weekday(_selectedDate.weekday)}, ${_month(_selectedDate.month)} ${_selectedDate.day}';

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _pickDate,
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                '${_weekday(_selectedDate.weekday)}, ${_month(_selectedDate.month)} ${_selectedDate.day}',
              ),
            ],
          ),
        ),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks for today. Tap + to add one!'))
          : ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskTile(
                  index: index,
                  task: task,
                  onChanged: (value) {
                    setState(() {
                      task.isDone = value!;
                    });
                  },
                  onDelete: () {
                    setState(() {
                      _tasks.removeAt(index);
                    });
                  },
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
