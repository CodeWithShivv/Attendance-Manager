import 'package:attendance_manager_app/core/data_sources/google_sheets_data_source.dart';
import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final GoogleSheetsApi googleSheetsApi;

  EmployeeRepositoryImpl(this.googleSheetsApi);

@override
  Future<List<Employee>> fetchEmployees() async {
    return await googleSheetsApi.fetchEmployees();
  }

  @override
  Future<void> addEmployee(String employeeName) async {
    await googleSheetsApi.addEmployee(employeeName);
  }

  @override
  Future<void> removeEmployee(String employeeName) async {
    await googleSheetsApi.removeEmployee(employeeName);
  }
}
