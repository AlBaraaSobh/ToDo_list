import 'package:flutter/material.dart';
import 'package:todo_list/model/Task.dart';
import 'package:todo_list/util/DatabaseHelper.dart';

class TaskProvider extends ChangeNotifier {
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDetailsController = TextEditingController();
  GlobalKey<FormState> addNewKey = GlobalKey<FormState>();
  List<Task> allTask = <Task>[];
  List<Task> allCompletedTask = <Task>[];
  int? totalTaskNum;
  int? totalCompleteTask;
  late String buttonText;

  TaskProvider() {
    getTasks();
  }
  getTotalCompleteTask(){
    if(totalCompleteTask == null){
      int temp = 0;
      return temp;
    }
    return totalCompleteTask;
  }
  getTotalTaskNum(){
    if(totalTaskNum == null){
      int temp = 0;
      return temp;
    }
    return totalTaskNum;
  }

  createTask(context) async {
    if (addNewKey.currentState!.validate()) {
      Task task = Task(
          title: taskTitleController.text, Details: taskDetailsController.text);
      insetTaskToDB(task);
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context, true);
    }
  }

  insetTaskToDB(Task task) async {
    await DbHelper.dbHelper.insertTask(task);
    getTasks();
    notifyListeners();
  }

  updateTask(Task task, context) async {
    if (addNewKey.currentState!.validate()) {
      task.title = taskTitleController.text;
      task.Details = taskDetailsController.text;
      await DbHelper.dbHelper.updateTask(task);
      getTasks();
      notifyListeners();
      Navigator.pop(context, true);
    }
  }

  updateTaskStauts(Task task) async {
    await DbHelper.dbHelper.updateTask(task);
    getTasks();
    notifyListeners();
  }

  getTasks() async {
    List<Map<String, Object?>> tasks = await DbHelper.dbHelper.getAllTask();
    allTask = tasks.map((e) {
      return Task.fromJson(e);
    }).toList();
    this.allCompletedTask =
        this.allTask.where((element) => element.status == 1).toList();
    totalTaskNum = allTask.length;
    totalCompleteTask = allCompletedTask.length;
    notifyListeners();
  }

  deleteTask(Task task) async {
    await DbHelper.dbHelper.deleteTask(task.id!);
    allTask.remove(task);
    getTasks();
    notifyListeners();
  }

  getProgressPercentage() {
    double percentage = 0.0;
    if (totalCompleteTask == null) {
      return percentage;
    }
    percentage = (totalCompleteTask! / totalTaskNum!) * 100;
    return percentage;
  }

  checkTask({task}) {
    if (task == null) {
      taskTitleController.text = "";
      taskDetailsController.text = "";
      buttonText = "Save";
    } else {
      taskTitleController.text = task!.title;
      taskDetailsController.text = task!.Details;
      buttonText = "Update";
    }
  }
}
