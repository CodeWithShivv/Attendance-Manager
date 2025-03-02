import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/attendance/presentation/widgets/attendance_widget.dart';
import 'package:attendance_manager_app/features/attendance/presentation/widgets/attendance_skelton_widget.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_bloc.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_event.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:attendance_manager_app/features/employee/presentation/widgets/alert_dialog_widget.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Main Attendance Widget
class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeStateUpdated) {
          context.read<HomeBloc>().add(RefreshHomeData(state.employees));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeSavingAttendance) {
              // Only show dialog for saving attendance
              AlertDialogWidget.show(context, 'Updating attendance...');
            } else if (state is HomeLoaded) {
              context.read<EmployeeBloc>().add(
                EmployeeUpdated(state.employees),
              );
            } else if (state is HomeSavedAttendance) {
              AlertDialogWidget.hide(context);
            }
          },
          builder: (context, state) {
            if (state is HomeLoaded) {
              return AttendanceWidget(state: state);
            }
            return const AttendanceSkeletonWidget();
          },
        ),
      ),
    );
  }
}
