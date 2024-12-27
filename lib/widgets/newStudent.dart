import 'package:flutter/material.dart';
import '../models/departmentInfo.dart';
import '../models/studentModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/studentsProvider.dart';


class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  Department _selectedDepartment = Department.it;
  Gender _selectedGender = Gender.male;
  int _grade = 1;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider)![widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _grade = student.grade;
      _selectedGender = student.gender;
      _selectedDepartment = student.department;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (widget.studentIndex != null) {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDepartment,
            _selectedGender,
            _grade,
          );
    }

    if (!context.mounted) return;
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(studentsProvider.notifier);
    Widget myWidget = SingleChildScrollView(
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
    if(notifier.isLoading) {
      myWidget = const Center(
        child: CircularProgressIndicator(),
      );
    }
    return myWidget;
  }
}
