import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/departmentInfo.dart';
import '../providers/studentsProvider.dart';
import '../widgets/departmentItem.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    final departmentStudentCounts = {
      for (var department in Department.values)
        department: students == null 
          ? 0 
          : students.where((s) => s.department == department).length,
    };

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: Department.values.length,
      itemBuilder: (context, index) {
        final department = Department.values[index];
        final count = departmentStudentCounts[department] ?? 0;

        return DepartmentItem(
          name: departmentNames[department]!,
          studentCount: count,
          icon: departmentIcons[department]!,
        );
      },
    );
  }
}
