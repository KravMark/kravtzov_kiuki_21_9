import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }
enum Gender { male, female }

final departmentIcons = {
  Department.finance: Icons.attach_money,
  Department.law: Icons.balance,
  Department.it: Icons.computer,
  Department.medical: Icons.local_hospital,
};
