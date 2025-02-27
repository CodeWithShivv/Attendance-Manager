// main.dart
import 'package:attendance_manager_app/core/navigation/app_router.dart';
import 'package:attendance_manager_app/core/dl/dependency_locator.dart';
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_bloc.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_event.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print('Error loading .env file: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeBloc(getIt<EmployeeRepository>()),
        ),
        
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Attendance Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: appRouter,
      ),
    );
  }
}
