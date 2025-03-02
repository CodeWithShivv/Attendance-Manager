import 'package:attendance_manager_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:attendance_manager_app/features/employee/presentation/pages/employee_page.dart';
import 'package:attendance_manager_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:attendance_manager_app/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Manager")),
      body: BlocBuilder<HomeCubit, int>(
        builder: (context, index) {
          return IndexedStack(
            index: index,
            children: [AttendancePage(), EmployeePage()],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
