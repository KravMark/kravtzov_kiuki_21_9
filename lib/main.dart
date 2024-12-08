import 'package:flutter/material.dart';
import 'widgets/students.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentsScreen(),
    );
  }
}
