import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/AddTaskProvider.dart';
import '../Widget/empty_state.dart';
import '../Widget/progress_card.dart';
import '../Widget/task_card.dart';
import 'add_task_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.3),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً بك',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'قائمة المهام',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Card
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: ProgressCard(
                            totalTasks: taskProvider.getTotalTaskNum(),
                            completedTasks: taskProvider.getTotalCompleteTask(),
                            progress: taskProvider.getProgressPercentage(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              // Tasks List
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      if (taskProvider.allTask.isEmpty) {
                        return EmptyState();
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: taskProvider.allTask.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.allTask[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.only(bottom: 15),
                            child: TaskCard(
                              task: task,
                              onToggle: () {
                                task.status = task.status == 0 ? 1 : 0;
                                taskProvider.updateTaskStauts(task);
                              },
                              onEdit: () async {
                                taskProvider.checkTask(task: task);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTaskScreen(),
                                  ),
                                );
                                if (result != null && result) {
                                  taskProvider.getTasks();
                                }
                              },
                              onDelete: () {
                                _showDeleteDialog(context, task, taskProvider);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF667eea).withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            Provider.of<TaskProvider>(context, listen: false).checkTask();
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
            if (result != null && result) {
              Provider.of<TaskProvider>(context, listen: false).getTasks();
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            'إضافة مهمة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, task, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('حذف المهمة'),
          content: Text('هل أنت متأكد من حذف هذه المهمة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                taskProvider.deleteTask(task);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('حذف', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}