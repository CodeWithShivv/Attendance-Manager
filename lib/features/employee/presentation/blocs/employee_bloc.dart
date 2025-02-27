import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart'; // Assuming your Employee entity is here
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_event.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeInitial()) {
    // Load employees from repository
    on<LoadEmployees>(_onLoadEmployees);

    // Add a new employee
    on<AddEmployee>(_onAddEmployee);

    // Remove (deactivate) an employee
    on<RemoveEmployee>(_onRemoveEmployee);

    // Fetch employees (alternative to LoadEmployees if needed)
    on<FetchEmployees>(_onFetchEmployees);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final employees = await repository.fetchEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to load employees: $e'));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeLoading()); // Show loading state during operation
      await repository.addEmployee(event.employeeName);
      final updatedEmployees =
          await repository.fetchEmployees(); // Fetch updated list
      emit(EmployeeLoaded(updatedEmployees));
    } catch (e) {
      emit(EmployeeError('Failed to add employee: $e'));
    }
  }

  Future<void> _onRemoveEmployee(
    RemoveEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeLoading()); // Show loading state during operation
      await repository.removeEmployee(event.employeeName);
      final updatedEmployees =
          await repository.fetchEmployees(); // Fetch updated list
      emit(EmployeeLoaded(updatedEmployees));
    } catch (e) {
      emit(EmployeeError('Failed to remove employee: $e'));
    }
  }

  Future<void> _onFetchEmployees(
    FetchEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading()); // Show loading state for consistency
    try {
      final employees = await repository.fetchEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to fetch employees: $e'));
    }
  }
}
