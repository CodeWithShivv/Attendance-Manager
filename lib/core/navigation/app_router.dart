import 'package:attendance_manager_app/core/dl/dependency_locator.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:attendance_manager_app/features/home/presentation/pages/home_page.dart';
import 'package:attendance_manager_app/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_manager_app/features/attendance/presentation/pages/attendance_manager.dart';
import 'package:attendance_manager_app/features/employee/presentation/pages/employee_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SplashPage()),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return BlocProvider(
          create:
              (context) => HomeBloc(
                attendanceRepository: getIt(),
                employeeRepository: getIt(),
              )..add(LoadHomeData()),
          child: HomePage(),
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
