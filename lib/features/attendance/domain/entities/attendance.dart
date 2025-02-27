// features/attendance/domain/entities/attendance.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.freezed.dart'; // Generated file

@freezed
class Attendance with _$Attendance {
  const Attendance._(); // Private constructor for adding methods

  const factory Attendance({
    required String employeeName,
    required DateTime checkIn,
    required DateTime checkOut,
    @Default(true) bool isPresent,
    @Default(0.0) double overtimeHours,
  }) = _Attendance;

  // Helper method to calculate overtime (if > 9 hours)
  double calculateOvertime() {
    final hoursWorked = checkOut.difference(checkIn).inMinutes / 60.0;
    return hoursWorked > 9 ? hoursWorked - 9 : 0.0;
  }
}
