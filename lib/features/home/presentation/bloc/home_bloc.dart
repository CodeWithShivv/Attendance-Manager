// features/home/presentation/bloc/home_bloc.dart
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AttendanceRepository attendanceRepository;
  final List<Employee> employees;

  HomeBloc({required this.attendanceRepository, required this.employees})
    : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<UpdateDate>(_onUpdateDate);
    on<UpdateCheckTime>(_onUpdateCheckTime);
    on<SaveAttendance>(_onSaveAttendance);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final records = await attendanceRepository.fetchAttendance(event.date);
      if (records.isEmpty) {
        final defaultRecords =
            employees.map((employee) {
              final checkIn = DateTime(
                event.date.year,
                event.date.month,
                event.date.day,
                9,
                0,
              );
              final checkOut = DateTime(
                event.date.year,
                event.date.month,
                event.date.day,
                18,
                0,
              );
              return Attendance(
                employeeName: employee.name,
                checkIn: checkIn,
                checkOut: checkOut,
                isPresent: true,
                overtimeHours: 0.0,
              );
            }).toList();
        emit(HomeLoaded(defaultRecords, event.date));
      } else {
        emit(HomeLoaded(records, event.date));
      }
    } catch (e) {
      emit(HomeError("Failed to load attendance: $e"));
    }
  }

  Future<void> _onUpdateDate(UpdateDate event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoading());
      try {
        final records = await attendanceRepository.fetchAttendance(
          event.newDate,
        );
        if (records.isEmpty) {
          final defaultRecords =
              employees.map((employee) {
                final checkIn = DateTime(
                  event.newDate.year,
                  event.newDate.month,
                  event.newDate.day,
                  9,
                  0,
                );
                final checkOut = DateTime(
                  event.newDate.year,
                  event.newDate.month,
                  event.newDate.day,
                  18,
                  0,
                );
                return Attendance(
                  employeeName: employee.name,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  isPresent: true,
                  overtimeHours: 0.0,
                );
              }).toList();
          emit(HomeLoaded(defaultRecords, event.newDate));
        } else {
          emit(HomeLoaded(records, event.newDate));
        }
      } catch (e) {
        emit(HomeError("Failed to update date: $e"));
        emit(currentState); // Revert to previous state on error
      }
    }
  }

  Future<void> _onUpdateCheckTime(
    UpdateCheckTime event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedAttendance =
          currentState.attendanceList.map((attendance) {
            if (attendance == event.attendance) {
              final newAttendance =
                  event.isCheckIn
                      ? attendance.copyWith(checkIn: event.newTime)
                      : attendance.copyWith(checkOut: event.newTime);
              return newAttendance.copyWith(
                overtimeHours: newAttendance.calculateOvertime(),
              );
            }
            return attendance;
          }).toList();
      emit(HomeLoaded(updatedAttendance, currentState.selectedDate));
    }
  }

  Future<void> _onSaveAttendance(
    SaveAttendance event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
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
        emit(HomeLoaded(updatedRecords, event.date));
      } catch (e) {
        emit(HomeError("Failed to save attendance: $e"));
        emit(currentState); // Revert to previous state on error
      }
    }
  }
}
