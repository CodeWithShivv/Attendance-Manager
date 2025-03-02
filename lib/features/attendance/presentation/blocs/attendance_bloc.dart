import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/attendance/presentation/blocs/attendance_event.dart';
import 'package:attendance_manager_app/features/attendance/presentation/blocs/attendance_state.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;
  final List<Employee> employee; 
  AttendanceBloc(this.repository, this.employee) : super(AttendanceInitial()) {
    on<LoadAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final records = await repository.fetchAttendance(event.date);
        if (records.isEmpty) {
          // No records: Create default attendance (9 AM - 6 PM, Present)
          final defaultRecords =
              employee.map((e) {
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
                  employeeName: e.name,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  isPresent: true,
                  overtimeHours: 0.0, // No overtime for default 9-hour day
                );
              }).toList();
          emit(AttendanceLoaded(defaultRecords, event.date));
        } else {
          // Records exist: Emit them with calculated overtime
          emit(AttendanceLoaded(records, event.date));
        }
      } catch (e) {
        emit(AttendanceError('Failed to load attendance: $e'));
      }
    });

    on<UpdateAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        // Update the records in Google Sheets
        await repository.updateAttendance(event.date, event.attendanceList);
        // Emit the updated records with recalculated overtime
        final updatedRecords =
            event.attendanceList.map((attendance) {
              return attendance.copyWith(
                overtimeHours: attendance.calculateOvertime(),
              );
            }).toList();
        emit(AttendanceLoaded(updatedRecords, event.date));
      } catch (e) {
        emit(AttendanceError('Failed to update attendance: $e'));
      }
    });
  }
}
