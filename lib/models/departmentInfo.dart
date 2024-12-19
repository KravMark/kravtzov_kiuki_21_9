import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }

const departmentNames = {
  Department.finance: 'Finance',
  Department.law: 'Law',
  Department.it: 'IT',
  Department.medical: 'Medical',
};

const departmentIcons = {
  Department.finance: Icons.account_balance_wallet,
  Department.law: Icons.scale,
  Department.it: Icons.developer_mode,
  Department.medical: Icons.health_and_safety,
};

