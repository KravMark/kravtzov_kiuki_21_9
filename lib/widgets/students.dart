import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _students = [
    Student(firstName: 'Іван', lastName: 'Петров', department: Department.it, grade: 95, gender: Gender.male),
    Student(firstName: 'Марія', lastName: 'Іваненко', department: Department.finance, grade: 88, gender: Gender.female),
    Student(firstName: 'Олександр', lastName: 'Коваль', department: Department.law, grade: 76, gender: Gender.male),
    Student(firstName: 'Наталя', lastName: 'Шевченко', department: Department.medical, grade: 92, gender: Gender.female),
    Student(firstName: 'Андрій', lastName: 'Сидоренко', department: Department.it, grade: 60, gender: Gender.male),
  ];

  Student? _lastDeletedStudent;
  int? _lastDeletedIndex;

  void _showNewStudentModal({Student? editingStudent, int? editingIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewStudent(
          student: editingStudent,
          onSubmit: (newStudent) {
            setState(() {
              if (editingIndex != null) {
                _students[editingIndex] = newStudent;
              } else {
                _students.add(newStudent);
              }
            });
          },
        );
      },
    );
  }

  void _deleteStudent(int index) {
    setState(() {
      _lastDeletedStudent = _students[index];
      _lastDeletedIndex = index;
      _students.removeAt(index);
    });
    _showUndoSnackbar();
  }

  void _showUndoSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Student deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: _undoDelete,
        ),
      ),
    );
  }

  void _undoDelete() {
    if (_lastDeletedStudent != null && _lastDeletedIndex != null) {
      setState(() {
        _students.insert(_lastDeletedIndex!, _lastDeletedStudent!);
      });
    }
    _lastDeletedStudent = null;
    _lastDeletedIndex = null;
  }

  Color _getBackgroundColorByGender(Gender gender) {
    return gender == Gender.male ? Colors.blue.shade50 : Colors.pink.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showNewStudentModal()),
        ],
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (ctx, index) {
          final student = _students[index];
          return Dismissible(
            key: ValueKey(student),
            background: Container(color: Colors.red, child: const Align(alignment: Alignment.centerLeft, child: Padding(padding: EdgeInsets.only(left: 16.0), child: Icon(Icons.delete, color: Colors.white)))),
            secondaryBackground: Container(color: Colors.red, child: const Align(alignment: Alignment.centerRight, child: Padding(padding: EdgeInsets.only(right: 16.0), child: Icon(Icons.delete, color: Colors.white)))),
            onDismissed: (direction) {
              _deleteStudent(index);
            },
            child: InkWell(
              onTap: () {
                _showNewStudentModal(editingStudent: student, editingIndex: index);
              },
              child: Container(
                color: _getBackgroundColorByGender(student.gender),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      (student.firstName.isNotEmpty ? student.firstName[0].toUpperCase() : '') +
                      (student.lastName.isNotEmpty ? student.lastName[0].toUpperCase() : ''),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                    ),
                  ),
                  title: Text('${student.firstName} ${student.lastName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  subtitle: Text('Department: ${student.department.name.toUpperCase()}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(departmentIcons[student.department], color: Colors.grey.shade800),
                      const SizedBox(width: 8),
                      Text(student.grade.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
