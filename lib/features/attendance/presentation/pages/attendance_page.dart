import 'package:attendance_manager_app/features/attendance/presentation/blocs/attendance_bloc.dart';
import 'package:attendance_manager_app/features/attendance/presentation/blocs/attendance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Manager')),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AttendanceLoaded) {
            return ListView.builder(
              itemCount: state.records.length,
              itemBuilder: (context, index) {
                final record = state.records[index];
                return ListTile(
                  title: Text(record.employeeName),
                  subtitle: Text(
                    "Check-in: ${record.checkIn}, Check-out: ${record.checkOut}",
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Data"));
        },
      ),
    );
  }
}
