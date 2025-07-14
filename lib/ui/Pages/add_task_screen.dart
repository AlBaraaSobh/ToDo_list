import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/model/Task.dart';

import '../../Provider/AddTaskProvider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      provider.checkTask(task: widget.task);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.task == null ? 'إضافة مهمة جديدة' : 'تعديل المهمة',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _fade,
                        child: ScaleTransition(
                          scale: _scale,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: provider.addNewKey,
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  TextFormField(
                                    controller: provider.taskTitleController,
                                    decoration: InputDecoration(
                                      labelText: 'عنوان المهمة',
                                      prefixIcon: Icon(Icons.title, color: Color(0xFF764ba2)),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                      filled: true,
                                      fillColor: Color(0xFFF5F7FA),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'يرجى إدخال العنوان' : null,
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: provider.taskDetailsController,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      labelText: 'تفاصيل المهمة',
                                      prefixIcon: Icon(Icons.description, color: Color(0xFF764ba2)),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                      filled: true,
                                      fillColor: Color(0xFFF5F7FA),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'يرجى إدخال التفاصيل' : null,
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (provider.buttonText == "Save") {
                                        provider.createTask(context);
                                      } else {
                                        if (widget.task != null) {
                                          provider.updateTask(widget.task!, context);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(double.infinity, 60),
                                      backgroundColor: Color(0xFF764ba2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      provider.buttonText == "Save" ? 'حفظ المهمة' : 'تحديث المهمة',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
