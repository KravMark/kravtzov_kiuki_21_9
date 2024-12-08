import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/student_item.dart';

class NewStudent extends StatefulWidget {
  final Student? student;
  final void Function(Student) onSubmit;

  const NewStudent({
    Key? key,
    this.student,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  Department _selectedDepartment = Department.it;
  Gender _selectedGender = Gender.male;
  int _grade = 0;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.student?.lastName ?? '');
    _selectedDepartment = widget.student?.department ?? Department.it;
    _selectedGender = widget.student?.gender ?? Gender.male;
    _grade = widget.student?.grade ?? 0;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final newStudent = Student(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      department: _selectedDepartment,
      grade: _grade,
      gender: _selectedGender,
    );
    widget.onSubmit(newStudent);
    Navigator.of(context).pop();
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.student == null ? 'Add New Student' : 'Edit Student', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Department>(
              value: _selectedDepartment,
              decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
              items: Department.values.map((dept) {
                return DropdownMenuItem<Department>(
                  value: dept,
                  child: Text(dept.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (newVal) {
                if (newVal != null) {
                  setState(() {
                    _selectedDepartment = newVal;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Gender>(
              value: _selectedGender,
              decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
              items: Gender.values.map((g) {
                return DropdownMenuItem<Gender>(
                  value: g,
                  child: Text(g.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedGender = val;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Grade'),
                Slider(
                  value: _grade.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: _grade.toString(),
                  onChanged: (val) {
                    setState(() {
                      _grade = val.toInt();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: _handleCancel, child: const Text('Cancel', style: TextStyle(color: Colors.red))),
                ElevatedButton(onPressed: _handleSave, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
