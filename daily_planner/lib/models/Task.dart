import 'package:flutter/material.dart';

class Task {
  Task({
    required this.title,
    this.isDone = false,
    this.startTime,
    this.endTime,
  });

  final String title;
  bool isDone;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}
