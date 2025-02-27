// features/attendance/data/repositories/attendance_repository_impl.dart
import 'package:attendance_manager_app/core/data_sources/google_sheets_data_source.dart';
import 'package:attendance_manager_app/features/attendance/data/repositories/attendance_repository.dart';
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:intl/intl.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final GoogleSheetsApi googleSheetsApi;
  final DateFormat _timeFormat = DateFormat('hh:mm a'); // e.g., "09:00 AM"

  AttendanceRepositoryImpl(this.googleSheetsApi);

  @override
  Future<List<Attendance>> fetchAttendance(DateTime date) async {
    final formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(date); // e.g., "2025-02-26"
    final data = await googleSheetsApi.fetchAttendance(formattedDate);

    if (data.isEmpty) {
      return [];
    }

    return data.map((e) {
      final employeeName = e[0];
      final checkInString = e[1];
      final checkOutString = e[2];

      final checkIn = _parseTime(formattedDate, checkInString);
      final checkOut = _parseTime(formattedDate, checkOutString);

      return Attendance(
        employeeName: employeeName,
        checkIn: checkIn,
        checkOut: checkOut,
        isPresent: true, // Default to present if entry exists
        overtimeHours: _calculateOvertime(checkIn, checkOut),
      );
    }).toList();
  }

  @override
  Future<void> updateAttendance(
    DateTime date,
    List<Attendance> attendanceList,
  ) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final data =
        attendanceList.map((attendance) {
          return [
            attendance.employeeName,
            _timeFormat.format(attendance.checkIn), // e.g., "09:00 AM"
            _timeFormat.format(attendance.checkOut), // e.g., "06:00 PM"
          ];
        }).toList();

    await googleSheetsApi.updateAttendance(formattedDate, data);
  }

  DateTime _parseTime(String date, String timeString) {
    final parsedTime = _timeFormat.parse(timeString);
    final dateParts = date.split('-').map(int.parse).toList();
    return DateTime(
      dateParts[0], // year
      dateParts[1], // month
      dateParts[2], // day
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  double _calculateOvertime(DateTime checkIn, DateTime checkOut) {
    final hoursWorked = checkOut.difference(checkIn).inMinutes / 60.0;
    return hoursWorked > 9 ? hoursWorked - 9 : 0.0;
  }
}
