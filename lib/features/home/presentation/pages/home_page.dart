// features/home/presentation/screens/home_page.dart
import 'dart:developer';

import 'package:attendance_manager_app/core/navigation/app_router.dart';
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_bloc.dart';
import 'package:attendance_manager_app/features/employee/presentation/blocs/employee_state.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_event.dart';
import 'package:attendance_manager_app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showNavigationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Manage Employees"),
                onTap: () {
                  appRouter.pop();
                  appRouter.push('/employees');
                },
              ),
              ListTile(
                leading: const Icon(Icons.event_note),
                title: const Text("View Attendance"),
                onTap: () {
                  appRouter.pop();
                  appRouter.push('/attendance');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime currentDate) async {
    final bloc = context.read<HomeBloc>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != currentDate) {
      bloc.add(UpdateDate(picked));
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    Attendance attendance,
    bool isCheckIn,
  ) async {
    final bloc = context.read<HomeBloc>();
    final currentState = bloc.state;
    if (currentState is! HomeLoaded) return;

    final TimeOfDay? picked = await showTimePicker(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(RefreshHomeData());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeLoaded) {
              context.read<HomeBloc>().add(RefreshHomeData());
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return Center(child: Text(state.message));
              } else if (state is HomeLoaded) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(state.selectedDate)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              () => _selectDate(context, state.selectedDate),
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.attendanceList.length,
                        itemBuilder: (context, index) {
                          log(
                            "attendance list" + state.attendanceList.toString(),
                          );
                          final attendance = state.attendanceList[index];
                          return Card(
                            child: ListTile(
                              title: Text(attendance.employeeName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed:
                                        () => _selectTime(
                                          context,
                                          attendance,
                                          true,
                                        ),
                                    child: Text(
                                      'In: ${DateFormat('hh:mm a').format(attendance.checkIn)}',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => _selectTime(
                                          context,
                                          attendance,
                                          false,
                                        ),
                                    child: Text(
                                      'Out: ${DateFormat('hh:mm a').format(attendance.checkOut)}',
                                    ),
                                  ),
                                  Text(
                                    'OT: ${attendance.overtimeHours.toStringAsFixed(1)}h',
                                  ),
                                ],
                              ),
                              trailing: Text(
                                attendance.isPresent ? 'Present' : 'Absent',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                          SaveAttendance(
                            state.selectedDate,
                            state.attendanceList,
                          ),
                        );
                      },
                      child: const Text('Update Attendance'),
                    ),
                  ],
                );
              }
              return const Center(child: Text("No data available"));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNavigationSheet(context),
        child: const Icon(Icons.menu),
      ),
    );
  }
}
