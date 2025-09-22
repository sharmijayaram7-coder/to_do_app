
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/model/task_model.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;
  final int? index;

  const TaskFormPage({super.key, this.task, this.index});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = "Medium";
  String _status = "To-Do";
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _priority = widget.task!.priority;
      _status = widget.task!.status;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? "Add Task" : "Edit Task",
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  style: GoogleFonts.poppins(color: Colors.white),
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: GoogleFonts.poppins(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.title, color: Colors.white),
                  ),
                  validator: (v) => v!.isEmpty ? "Title is required" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: GoogleFonts.poppins(color: Colors.white),

                  controller: _descController,
                  decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(color: Colors.white),
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.description, color: Colors.white),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _priority,
                  style: GoogleFonts.poppins(color: Colors.white),

                  decoration: InputDecoration(
                    labelStyle: GoogleFonts.poppins(color: Colors.white),
                    labelText: "Priority",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ["High", "Medium", "Low"]
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _priority = v!),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  style: GoogleFonts.poppins(color: Colors.white),

                  value: _status,
                  decoration: InputDecoration(
                    labelText: "Status",
                    labelStyle: GoogleFonts.poppins(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ["To-Do", "In Progress", "Done"]
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v!),
                ),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    style: GoogleFonts.poppins(color: Colors.white),
                    _dueDate == null
                        ? "Pick Due Date"
                        : "Due: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}",
                  ),
                  trailing: Icon(Icons.calendar_today, color: Colors.white),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDate: _dueDate ?? DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _dueDate = date);
                    }
                  },
                ),
                SizedBox(height: 20),

              
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newTask = Task(
                        title: _titleController.text,
                        description: _descController.text,
                        priority: _priority,
                        status: _status,
                        dueDate: _dueDate,
                      );

                      if (widget.index != null) {
                        taskBox.putAt(widget.index!, newTask);
                      } else {
                        taskBox.add(newTask);
                      }

                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    "Save Task",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
