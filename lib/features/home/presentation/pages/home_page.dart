import 'package:attendance_manager_app/core/navigation/app_router.dart';
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/attendance/presentation/widgets/attendance_widget.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_bloc.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:attendance_manager_app/features/employee/presentation/pages/employee_page.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_state.dart';
import 'package:attendance_manager_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:attendance_manager_app/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(RefreshHomeData());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, int>(
        builder: (context, index) {
          return IndexedStack(
            index: index,
            children: [AttendanceWidget(), EmployeePage()],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
