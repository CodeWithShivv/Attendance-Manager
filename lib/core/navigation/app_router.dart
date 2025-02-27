import 'package:attendance_manager_app/core/dl/dependency_locator.dart';
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:attendance_manager_app/features/home/presentation/pages/home_page.dart';
import 'package:attendance_manager_app/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_manager_app/features/attendance/presentation/pages/attendance_page.dart';
import 'package:attendance_manager_app/features/employee/presentation/pages/employee_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final employees = state.extra as List<Employee>? ?? [];
        return BlocProvider(
          create:
              (context) => HomeBloc(
                attendanceRepository: getIt<AttendanceRepository>(),
                employees: employees,
              )..add(LoadHomeData(DateTime.now())), 
          child: HomePage(employeeNames: employees),
        );
      },
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendancePage(),
    ),
    GoRoute(path: '/employees', builder: (context, state) => EmployeePage()),
  ],
);
