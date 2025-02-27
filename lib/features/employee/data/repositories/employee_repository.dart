import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> fetchEmployees();
  Future<void> addEmployee(String employeeName);
  Future<void> removeEmployee(String employeeName);
}
