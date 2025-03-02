import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceListItem extends StatelessWidget {
  final Attendance attendance;
  final Future<void> Function(BuildContext, Attendance, bool)
  onSelectTime; 

  const AttendanceListItem({
    super.key,
    required this.attendance,
    required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            attendance.employeeName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => onSelectTime(context, attendance, true),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'In: ${DateFormat('hh:mm a').format(attendance.checkIn)}',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () => onSelectTime(context, attendance, false),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Out: ${DateFormat('hh:mm a').format(attendance.checkOut)}',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              Text(
                'OT: ${attendance.overtimeHours.toStringAsFixed(1)}h',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          trailing: Text(
            attendance.isPresent ? 'Present' : 'Absent',
            style: TextStyle(
              color: attendance.isPresent ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
