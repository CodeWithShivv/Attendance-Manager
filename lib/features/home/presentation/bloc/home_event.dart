import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {
  final DateTime date;
  LoadHomeData(this.date);
}

class UpdateDate extends HomeEvent {
  final DateTime newDate;
  UpdateDate(this.newDate);
}

class UpdateCheckTime extends HomeEvent {
  final Attendance attendance;
  final DateTime newTime;
  final bool isCheckIn;
  UpdateCheckTime(this.attendance, this.newTime, this.isCheckIn);
}

class SaveAttendance extends HomeEvent {
  final DateTime date;
  final List<Attendance> attendanceList;
  SaveAttendance(this.date, this.attendanceList);
}
