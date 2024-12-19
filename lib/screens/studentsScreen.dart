import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/studentModel.dart';
import '../models/departmentInfo.dart';
import '../providers/studentsProvider.dart';
import '../widgets/newStudent.dart';
import '../widgets/studentsItem.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    void _showNewStudentModal({Student? student, int? index}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => NewStudent(
          student: student,
          onSubmit: (newStudent) {
            if (index != null) {
              ref.read(studentsProvider.notifier).editStudent(newStudent, index);
            } else {
              ref.read(studentsProvider.notifier).addStudent(newStudent);
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewStudentModal(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) { 
                ref.read(studentsProvider.notifier).removeStudent(index);
                final container = ProviderScope.containerOf(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Student deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        container.read(studentsProvider.notifier).undoDelete();
                      },
                    ),
                  ),
                );
              },
            child: InkWell(
              onTap: () => _showNewStudentModal(student: student, index: index),
              child: StudentsItem(student: student),
            ),
          );
        },
      ),
    );
  }
}
