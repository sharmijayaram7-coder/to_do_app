import 'package:hive/hive.dart';

part 'task_model.g.dart'; 

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String priority;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime? dueDate;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.dueDate,
  });
}
