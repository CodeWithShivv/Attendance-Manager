import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  final String? successMessage;

  const EmployeeLoaded(this.employees, {this.successMessage});

  @override
  List<Object?> get props => [employees, successMessage];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeAdding extends EmployeeState {}

class EmployeeRemoving extends EmployeeState {}

class EmployeeStateUpdated extends EmployeeState {
  final List<Employee> employees;

  const EmployeeStateUpdated(this.employees);
  @override
  List<Object?> get props => [];
}
