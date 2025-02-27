import 'package:attendance_manager_app/core/data_sources/google_sheets_data_source.dart';
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<GoogleSheetsApi>(() => GoogleSheetsApi());

  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(getIt<GoogleSheetsApi>()),
  );

  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(getIt<GoogleSheetsApi>()),
  );
}
