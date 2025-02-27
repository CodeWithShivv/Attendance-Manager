import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAttendance extends AttendanceEvent {
  final DateTime date;
  LoadAttendance(this.date);
}

class UpdateAttendance extends AttendanceEvent {
  final DateTime date;
  final List<Attendance> attendanceList;
  UpdateAttendance(this.date, this.attendanceList);
}

