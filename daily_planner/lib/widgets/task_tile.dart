import 'package:flutter/material.dart';
import '../models/Task.dart';

class TaskTile extends StatefulWidget {
  const TaskTile({
    super.key,
    required this.index,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  final int index;
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _completed = false;

  @override
  void didUpdateWidget(covariant TaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.task.isDone && !oldWidget.task.isDone) {
      setState(() => _completed = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _completed = false);
      });
    }
  }

  String _formatTimeRange(TimeOfDay? start, TimeOfDay? end) {
    if (start == null && end == null) return 'No time set';
    if (start != null && end != null) {
      return '${start.format(context)} - ${end.format(context)}';
    } else if (start != null) {
      return 'Starts at ${start.format(context)}';
    } else {
      return 'Ends at ${end!.format(context)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final task = widget.task;
    final isEven = index % 2 == 0;
    final bgColor = isEven
        ? const Color.fromARGB(255, 176, 224, 246)
        : const Color.fromARGB(255, 125, 207, 244);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Dismissible(
        key: ValueKey(task.title + index.toString()),
        direction: DismissDirection.endToStart,
        background: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.redAccent,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (_) => widget.onDelete(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AnimatedOpacity(
            opacity: _completed ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: _completed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Circle with incrementing numbers
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Task title + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.isDone ? 'Completed' : 'Not Done Yet',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          if (task.startTime != null || task.endTime != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatTimeRange(
                                      task.startTime,
                                      task.endTime,
                                    ),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Checkbox
                    Checkbox(value: task.isDone, onChanged: widget.onChanged),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
