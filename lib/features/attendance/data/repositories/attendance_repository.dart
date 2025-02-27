// features/attendance/data/repositories/attendance_repository.dart
import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> fetchAttendance(DateTime date);
  Future<void> updateAttendance(DateTime date, List<Attendance> attendanceList);
}
