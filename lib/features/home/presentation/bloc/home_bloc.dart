import 'dart:developer';
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AttendanceRepository attendanceRepository;
  final EmployeeRepository employeeRepository;

  HomeBloc({
    required this.attendanceRepository,
    required this.employeeRepository,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_loadHomeData);
    on<UpdateDate>(_updateDate);
    on<UpdateCheckTime>(_updateCheckTime);
    on<SaveAttendance>(_saveAttendance);
    on<RefreshHomeData>(_refreshHomeData);
    on<UpdateEmployees>(_updateEmployees);
  }

  Future<void> _loadAttendance(
    DateTime date,
    Emitter<HomeState> emit,
    List<Employee> employees,
  ) async {
    emit(HomeLoading());
    try {
      final attendanceRecords = await attendanceRepository.fetchAttendance(
        date,
      );

      // Create a map of existing attendance by employee name (case-insensitive)
      final attendanceMap = {
        for (var record in attendanceRecords)
          record.employeeName.toLowerCase(): record,
      };

      // Merge existing attendance with default attendance for all active employees
      final attendanceList =
          employees.where((employee) => employee.isActive).map((employee) {
            final normalizedName = employee.name.toLowerCase();
            return attendanceMap[normalizedName] ??
                Attendance(
                  employeeName: employee.name,
                  checkIn: DateTime(date.year, date.month, date.day, 9, 0),
                  checkOut: DateTime(date.year, date.month, date.day, 18, 0),
                  isPresent: true,
                  overtimeHours: 0.0,
                );
          }).toList();

      emit(HomeLoaded(attendanceList, date, employees));
    } catch (e) {
      emit(HomeError("Failed to load attendance: $e"));
    }
  }

  Future<void> _loadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    final employees = await employeeRepository.fetchEmployees();

    await _loadAttendance(event.date, emit, employees);
  }

  Future<void> _updateDate(UpdateDate event, Emitter<HomeState> emit) async {
    final previousState = state is HomeLoaded ? state as HomeLoaded : null;
    final employees =
        previousState?.employees ?? await employeeRepository.fetchEmployees();
    await _loadAttendance(event.newDate, emit, employees);
    if (state is HomeError && previousState != null) {
      emit(previousState);
    }
  }

  Future<void> _updateCheckTime(
    UpdateCheckTime event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final updatedAttendance =
        currentState.attendanceList.map((attendance) {
          if (attendance != event.attendance) return attendance;
          final updated =
              event.isCheckIn
                  ? attendance.copyWith(checkIn: event.newTime)
                  : attendance.copyWith(checkOut: event.newTime);
          return updated.copyWith(overtimeHours: updated.calculateOvertime());
        }).toList();

    emit(
      HomeLoaded(
        updatedAttendance,
        currentState.selectedDate,
        currentState.employees,
      ),
    );
  }

  Future<void> _saveAttendance(
    SaveAttendance event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    emit(HomeLoading());
    try {
      await attendanceRepository.updateAttendance(
        event.date,
        event.attendanceList,
      );
      final updatedRecords =
          event.attendanceList.map((attendance) {
            return attendance.copyWith(
              overtimeHours: attendance.calculateOvertime(),
            );
          }).toList();
      emit(HomeLoaded(updatedRecords, event.date, currentState.employees));
    } catch (e) {
      emit(HomeError("Failed to save attendance: $e"));
      emit(currentState);
    }
  }

  Future<void> _refreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state is HomeLoaded ? state as HomeLoaded : null;
    final date = currentState?.selectedDate ?? DateTime.now();
    final employees = await employeeRepository.fetchEmployees();
    await _loadAttendance(date, emit, employees);
  }

  void _updateEmployees(UpdateEmployees event, Emitter<HomeState> emit) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    emit(
      HomeLoaded(
        currentState.attendanceList,
        currentState.selectedDate,
        event.employees,
      ),
    );
  }
}
