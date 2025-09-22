import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'model/task_model.dart';
import 'task_form_page.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: box.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks yet!",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final task = box.getAt(index)!;

                        // Priority color
                        Color priorityColor;
                        switch (task.priority) {
                          case "High":
                            priorityColor = Colors.redAccent;
                            break;
                          case "Low":
                            priorityColor = Colors.green;
                            break;
                          default:
                            priorityColor = Colors.orange;
                        }

                        return Card(
                          color: Colors.white.withOpacity(
                            0.2,
                          ), // transparent card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: priorityColor,
                              child: const Icon(
                                Icons.assignment,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "${task.priority} • ${task.status}"
                              "${task.dueDate != null ? " • Due: ${DateFormat('MMM dd').format(task.dueDate!)}" : ""}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TaskFormPage(task: task, index: index),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => box.deleteAt(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
