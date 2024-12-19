import 'package:flutter/material.dart';
import '../models/departmentInfo.dart';
import '../models/studentModel.dart';

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
  int _grade = 1;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.student?.lastName ?? '');
    _selectedDepartment = widget.student?.department ?? Department.it;
    _selectedGender = widget.student?.gender ?? Gender.male;
    _grade = widget.student?.grade ?? 1;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Department>(
            value: _selectedDepartment,
            decoration: const InputDecoration(labelText: 'Department'),
            items: Department.values.map((dept) {
              return DropdownMenuItem(
                value: dept,
                child: Text(departmentNames[dept]!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedDepartment = value);
              }
            },
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Gender>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender == Gender.male ? 'Male' : 'Female'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedGender = value);
              }
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Grade:', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Slider(
                  value: _grade.toDouble(),
                  min: 1,
                  max: 100,
                  divisions: 100,
                  label: _grade.toString(),
                  onChanged: (value) => setState(() => _grade = value.toInt()),
                ),
              ),
              Text(_grade.toString(), style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleSave,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
