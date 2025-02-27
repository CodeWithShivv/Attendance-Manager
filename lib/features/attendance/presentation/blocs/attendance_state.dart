import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:equatable/equatable.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> records;
  final DateTime date;
  AttendanceLoaded(this.records, this.date);
}

class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
