import 'dart:developer';

import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_event.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeInitial()) {
    on<LoadEmployees>(_onFetchEmployees);
    on<FetchEmployees>(_onFetchEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<RemoveEmployee>(_onRemoveEmployee);
    on<EmployeeUpdated>(_onEmployeeUpdated);
  }

  Future<void> _onFetchEmployees(
    EmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final employees = await repository.fetchEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to fetch employees: $e'));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeAdding());
    try {
      await repository.addEmployee(event.employeeName);
      final updatedEmployees = await repository.fetchEmployees();
      emit(EmployeeStateUpdated(updatedEmployees));
      emit(
        EmployeeLoaded(
          updatedEmployees,
          successMessage: 'Employee "${event.employeeName}" added successfully',
        ),
      );
    } catch (e) {
      emit(EmployeeError('Failed to add employee: $e'));
    }
  }

  Future<void> _onRemoveEmployee(
    RemoveEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeRemoving());
    try {
      await repository.removeEmployee(event.employeeName);
      final updatedEmployees = await repository.fetchEmployees();
      emit(EmployeeStateUpdated(updatedEmployees));
      emit(
        EmployeeLoaded(
          updatedEmployees,
          successMessage:
              'Employee "${event.employeeName}" removed successfully',
        ),
      );
    } catch (e) {
      emit(EmployeeError('Failed to remove employee: $e'));
    }
  }

  Future<void> _onEmployeeUpdated(
    EmployeeUpdated event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeLoaded(event.employees));
    } catch (e) {
      emit(EmployeeError('Failed to update employees: $e'));
    }
  }
}
