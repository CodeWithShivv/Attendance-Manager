import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/attendance/presentation/widgets/attendance_list_item.dart';
import 'package:attendance_manager_app/features/attendance/presentation/widgets/date_selector_widget.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart'
    show HomeBloc;
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceWidget extends StatelessWidget {
  final HomeLoaded state;

  const AttendanceWidget({super.key, required this.state});

  Future<void> _selectDate(BuildContext context) async {
    final bloc = context.read<HomeBloc>();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != state.selectedDate) {
      bloc.add(UpdateDate(picked));
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    Attendance attendance,
    bool isCheckIn,
  ) async {
    final bloc = context.read<HomeBloc>();
    if (bloc.state is! HomeLoaded) return;

    final currentState = bloc.state as HomeLoaded;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        isCheckIn ? attendance.checkIn : attendance.checkOut,
      ),
    );
    if (picked != null) {
      final newDateTime = DateTime(
        currentState.selectedDate.year,
        currentState.selectedDate.month,
        currentState.selectedDate.day,
        picked.hour,
        picked.minute,
      );
      bloc.add(UpdateCheckTime(attendance, newDateTime, isCheckIn));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateSelector(
          selectedDate: state.selectedDate,
          onSelectDate: () => _selectDate(context),
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              state.employees.isEmpty && state.attendanceList.isEmpty
                  ? const Center(
                    child: Text(
                      'Please add employees to manage attendance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                  : ListView.separated(
                    itemCount: state.attendanceList.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final attendance = state.attendanceList[index];
                      return AttendanceListItem(
                        attendance: attendance,
                        onSelectTime: _selectTime,
                      );
                    },
                  ),
        ),
        const SizedBox(height: 16),
        if (state.employees.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(
                SaveAttendance(state.selectedDate, state.attendanceList),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Update Attendance'),
          ),
      ],
    );
  }
}
