import 'package:flutter/material.dart';
import '../models/student_item.dart';
import '../models/enums.dart';

class StudentItemWidget extends StatelessWidget {
  final Student student;

  const StudentItemWidget({Key? key, required this.student}) : super(key: key);

  Color _getBackgroundColorByGender(Gender gender) {
    return gender == Gender.male ? Colors.blue.shade50 : Colors.pink.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getBackgroundColorByGender(student.gender),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Text(
            (student.firstName.isNotEmpty ? student.firstName[0].toUpperCase() : '') +
            (student.lastName.isNotEmpty ? student.lastName[0].toUpperCase() : ''),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        title: Text(
          '${student.firstName} ${student.lastName}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Department: ${student.department.name.toUpperCase()}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              departmentIcons[student.department],
              color: Colors.grey.shade800,
            ),
            const SizedBox(width: 8),
            Text(
              student.grade.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentsScreen extends StatelessWidget {
  StudentsScreen({Key? key}) : super(key: key);

  final List<Student> students = [
    Student(
      firstName: 'Iван',
      lastName: 'Петров',
      department: Department.it,
      grade: 95,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Марiя',
      lastName: 'Iваненко',
      department: Department.finance,
      grade: 88,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Олександр',
      lastName: 'Коваль',
      department: Department.law,
      grade: 76,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Наталя',
      lastName: 'Шевченко',
      department: Department.medical,
      grade: 92,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Андрій',
      lastName: 'Сидоренко',
      department: Department.it,
      grade: 60,
      gender: Gender.male,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) => StudentItemWidget(student: students[index]),
      ),
    );
  }
}
