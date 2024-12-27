import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/studentModel.dart';
import '../providers/studentsProvider.dart';
import '../widgets/newStudent.dart';
import '../widgets/studentsItem.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    void showNewStudentModal({Student? student, int? index}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => NewStudent(
          studentIndex: index
        ),
      );
    }

    final notifier = ref.watch(studentsProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notifier.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              notifier.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        notifier.clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showNewStudentModal(),
          ),
        ],
      ),
      body: () {
        if (notifier.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (students != null) {
          return ListView.builder(
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
                    ).closed.then((value) {
                      if (value != SnackBarClosedReason.action) {
                        ref.read(studentsProvider.notifier).deleteFromFirebase();
                      }
                    });
                  },
                child: InkWell(
                  onTap: () => showNewStudentModal(student: student, index: index),
                  child: StudentsItem(student: student),
                ),
              );
            },
          );
        }
      }(),
    );
  }
}
