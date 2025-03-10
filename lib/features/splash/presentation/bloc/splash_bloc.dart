import 'dart:async';
import 'dart:developer';
import 'package:attendance_manager_app/features/employee/data/repositories/employee_repository.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<LoadSplash>(_onLoadSplash);
  }

  Future<void> _onLoadSplash(
    LoadSplash event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoaded());
  }
}
