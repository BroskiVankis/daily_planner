import 'package:flutter/material.dart';
import '../models/Task.dart';

class DayView extends StatelessWidget {
  const DayView({
    super.key,
    required this.tasks,
    required this.pixelsPerMinute,
  });

  final List<Task> tasks;
  final double pixelsPerMinute;

  @override
  Widget build(BuildContext context) {
    const startHour = 6;
    const endHour = 22;

    final timeTasks = tasks
        .where((t) => t.startTime != null && t.endTime != null)
        .toList();

    final totalMinutes = (endHour - startHour) * 60;
    final totalHeight = totalMinutes * pixelsPerMinute;

    return SingleChildScrollView(
      child: SizedBox(
        height: totalHeight + 100,
        child: Stack(
          children: [
            // Hour lines and labels
            Column(
              children: List.generate(endHour - startHour + 1, (index) {
                final hour = startHour + index;
                return SizedBox(
                  height: 60 * pixelsPerMinute,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          '${hour.toString().padLeft(2, '0')}:00',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.grey)),
                    ],
                  ),
                );
              }),
            ),
            // Task blocks
            ...timeTasks.map((task) {
              final start = task.startTime!;
              final end = task.endTime!;
              final startMinutes = start.hour * 60 + start.minute;
              final endMinutes = end.hour * 60 + end.minute;

              // Clamp task time to bounds
              final clampedStart = startMinutes.clamp(
                startHour * 60,
                endHour * 60,
              );
              final clampedEnd = endMinutes.clamp(startHour * 60, endHour * 60);

              // OFFSET FIX HERE
              final topOffset =
                  (clampedStart - startHour * 60) * pixelsPerMinute -
                  0.5 * pixelsPerMinute;

              final taskHeight = (clampedEnd - clampedStart) * pixelsPerMinute;

              return Positioned(
                top: topOffset,
                left: 70,
                right: 20,
                child: Container(
                  height: taskHeight > 0 ? taskHeight : 1, // Prevent 0 height
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${start.format(context)} - ${end.format(context)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
