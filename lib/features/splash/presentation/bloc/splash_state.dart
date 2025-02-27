import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoaded extends SplashState {
  final List<Employee> employees;
  SplashLoaded({required this.employees});
}
