
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/Pages/home_screen.dart';

import 'package:todo_list/util/DatabaseHelper.dart';

import 'Provider/AddTaskProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.dbHelper.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Todo List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xFFF5F7FA),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
















// Your existing files remain the same:
// model/Task.dart (unchanged)
// provider/TaskProvider.dart (unchanged)
// util/DatabaseHelper.dart (unchanged)
//
// Add these dependencies to pubspec.yaml:
/*
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  sqflite: ^2.2.8
  path_provider: ^2.0.14
*/

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:todo_list/ui/Pages/home_screen.dart';
// import 'package:todo_list/util/DatabaseHelper.dart';
// import 'Provider/AddTaskProvider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DbHelper.dbHelper.initDatabase();
//   runApp(ChangeNotifierProvider<TaskProvider>(
//     create: (context) => TaskProvider(),
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//       builder: (context, widget) => ResponsiveBreakpoints.builder(
//         child: BouncingScrollWrapper.builder(context, widget!),
//         breakpoints: [
//           const Breakpoint(start: 0, end: 450, name: MOBILE),
//           const Breakpoint(start: 451, end: 800, name: TABLET),
//           const Breakpoint(start: 801, end: 1920, name: DESKTOP),
//           const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//         ],
//       ),
//     ),
//   ));
// }