import 'package:flutter/material.dart';

class DepartmentItem extends StatelessWidget {
  final String name;
  final int studentCount;
  final IconData icon;

  const DepartmentItem({
    super.key,
    required this.name,
    required this.studentCount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$studentCount students', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
