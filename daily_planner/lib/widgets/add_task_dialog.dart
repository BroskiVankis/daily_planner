import 'package:daily_planner/models/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime() async {
    TimeOfDay selectedTime = _startTime ?? TimeOfDay.now();
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: DateTime(
                    2000,
                    1,
                    1,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _startTime = TimeOfDay(
                        hour: newDateTime.hour,
                        minute: newDateTime.minute,
                      );
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickEndTime() async {
    TimeOfDay selectedTime = _endTime ?? TimeOfDay.now();
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: DateTime(
                    2000,
                    1,
                    1,
                    selectedTime.hour,
                    selectedTime.minute,
                  ),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      _endTime = TimeOfDay(
                        hour: newDateTime.hour,
                        minute: newDateTime.minute,
                      );
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'e.g, Gym, Study, Pay Bills...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _pickStartTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    _startTime == null
                        ? 'Start Time'
                        : _startTime!.format(context),
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickEndTime,
                  icon: const Icon(Icons.access_time_outlined),
                  label: Text(
                    _endTime == null ? 'End Time' : _endTime!.format(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _controller.text.trim();
            if (title.isEmpty) return;
            final task = Task(
              title: title,
              startTime: _startTime,
              endTime: _endTime,
            );
            Navigator.of(context).pop(task);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
