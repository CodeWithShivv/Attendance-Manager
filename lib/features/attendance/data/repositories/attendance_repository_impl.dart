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
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final data = await googleSheetsApi.fetchAttendance(formattedDate);

    if (data.isEmpty) {
      return [];
    }

    return data;
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
}
