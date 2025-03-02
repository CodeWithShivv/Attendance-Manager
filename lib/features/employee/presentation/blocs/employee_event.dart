import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final String employeeName;
  AddEmployee(this.employeeName);

  @override
  List<Object> get props => [employeeName];
}

class RemoveEmployee extends EmployeeEvent {
  final String employeeName;
  RemoveEmployee(this.employeeName);

  @override
  List<Object> get props => [employeeName];
}

class FetchEmployees extends EmployeeEvent {}

class EmployeeUpdated extends EmployeeEvent {
  final List<Employee> employees;
  EmployeeUpdated(this.employees);
  @override
  List<Object> get props => [employees];
}
