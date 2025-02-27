import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Attendance> attendanceList;
  final DateTime selectedDate;
  HomeLoaded(this.attendanceList, this.selectedDate);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object> get props => [message];
}
