// core/data_sources/google_sheets_data_source.dart
import 'dart:developer';

import 'package:attendance_manager_app/features/attendance/domain/entities/attendance.dart';
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class GoogleSheetsApi {
  late String _spreadsheetId;
  late Map<String, dynamic> _credentials;

  GoogleSheetsApi() {
    _spreadsheetId = dotenv.env['EMPLOYEE_SPREADSHEET_ID'] ?? '';
    final credentialsJson = dotenv.env['GOOGLE_CREDENTIALS'] ?? '{}';
    _credentials = jsonDecode(credentialsJson);
    if (_spreadsheetId.isEmpty || _credentials.isEmpty) {
      throw Exception('Missing environment variables in .env file');
    }
  }

  Future<sheets.SheetsApi> _getSheetsApi() async {
    try {
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(_credentials),
        [sheets.SheetsApi.spreadsheetsScope],
      );
      return sheets.SheetsApi(client);
    } catch (e) {
      log('Error initializing Sheets API: $e');
      rethrow;
    }
  }

  Future<List<Attendance>> fetchAttendance(String date) async {
    try {
      final api = await _getSheetsApi();
      const range =
          'Sheet1!A:E'; // Use Sheet1 for isActive, date, employee, checkIn, checkOut
      log(
        'Fetching attendance for date: $date, range: $range, spreadsheetId: $_spreadsheetId',
      );
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);
      final values =
          response.values?.map((e) => e.cast<String>()).toList() ?? [];
      // Skip header row and filter rows by date (non-empty date in column B)
      final dateFormat = DateFormat('yyyy-MM-dd');
      final timeFormat = DateFormat('hh:mm a');

      return values
          .skip(1) // Skip header row
          .where((row) => row.isNotEmpty && row[1].isNotEmpty && row[1] == date)
          .map((row) {
            final employeeName =
                row[2] ??
                ''; // Employee from column C, default to empty string if null
            final checkInString =
                row[3] ??
                ''; // CheckIn from column D, default to empty string if null
            final checkOutString =
                row[4] ??
                ''; // CheckOut from column E, default to empty string if null

            if (employeeName.isEmpty ||
                checkInString.isEmpty ||
                checkOutString.isEmpty) {
              log('Skipping invalid attendance row: $row');
              return null; // Skip invalid rows
            }

            // Parse date
            final parsedDate = dateFormat.parse(date);
            // Parse times with the date
            final checkIn = DateTime(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              timeFormat.parse(checkInString).hour,
              timeFormat.parse(checkInString).minute,
            );
            final checkOut = DateTime(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              timeFormat.parse(checkOutString).hour,
              timeFormat.parse(checkOutString).minute,
            );

            return Attendance(
              employeeName: employeeName,
              checkIn: checkIn,
              checkOut: checkOut,
              isPresent: true, // Default to true as per your app logic
              overtimeHours: _calculateOvertime(checkIn, checkOut),
            );
          })
          .whereType<Attendance>() // Filter out null values
          .toList();
    } catch (e) {
      log('Error fetching attendance: $e');
      return [];
    }
  }

  Future<void> updateAttendance(String date, List<List<dynamic>> data) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:E'; // Define the sheet range

      // Fetch existing data
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);
      final existingValues =
          response.values?.map((e) => e.cast<String>()).toList() ?? [];

      // Preserve header row
      final List<List<String>> updatedValues = [
        ['isActive', 'date', 'employee', 'checkIn', 'checkOut'],
      ];

      // Map to track existing records per employee on the given date
      final Map<String, List<String>> attendanceMap = {};

      // Populate map with existing attendance data for the given date
      for (var row in existingValues.skip(1)) {
        if (row.length < 5) continue; // Ensure valid row format
        final existingDate = row[1];
        final employee = row[2];
        final key = '${existingDate}_$employee';
        attendanceMap[key] = row;
      }

      // Process new attendance data
      for (var newRow in data) {
        if (newRow.length < 3) continue; // Ensure valid new row format

        final employee = (newRow[0] as String).trim();
        final checkIn = (newRow[1] as String).trim();
        final checkOut = (newRow[2] as String).trim();

        if (employee.isEmpty || checkIn.isEmpty || checkOut.isEmpty) continue;

        final key = '${date}_$employee';

        // Update existing entry or add a new one
        attendanceMap[key] = ['true', date, employee, checkIn, checkOut];
      }

      // Convert map back to a list and add to updated values
      updatedValues.addAll(attendanceMap.values);

      // Clear existing data and update with new data
      await api.spreadsheets.values.clear(
        sheets.ClearValuesRequest(),
        _spreadsheetId,
        range,
      );

      if (updatedValues.length > 1) {
        final request = sheets.ValueRange(values: updatedValues);
        await api.spreadsheets.values.update(
          request,
          _spreadsheetId,
          range,
          valueInputOption: 'RAW',
        );
      }
    } catch (e) {
      log('Error updating attendance: $e');
      rethrow;
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    try {
      final api = await _getSheetsApi();
      const range =
          'Sheet1!A:C'; // Fetch only isActive, date, employee (no attendance data)
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);

      if (response.values == null) return [];

      final employees =
          response.values!
              .skip(1) // Skip header row
              .where(
                (row) => row.isNotEmpty && row.length >= 3,
              ) // Ensure row is valid
              .map((row) {
                final isActive = _parseIsActive(
                  row[0],
                ); // Safely parse isActive from column A
                final employeeName = _parseEmployeeName(
                  row[2],
                ); // Safely parse employee name from column C
                if (!isActive || employeeName.isEmpty) {
                  return null; // Skip invalid rows
                }

                return Employee(
                  name: employeeName,
                  isActive: isActive,
                  id: null,
                );
              })
              .whereType<Employee>() // Filter out null values
              .toList();

      return employees;
    } catch (e) {
      return [];
    }
  }

  bool _parseIsActive(Object? value) {
    final strValue = (value as String?)?.trim().toLowerCase() ?? 'false';
    return strValue == 'true';
  }

  String _parseEmployeeName(Object? value) {
    return (value as String?)?.trim() ?? '';
  }

  Future<void> addEmployee(String employeeName) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:E'; // Use full range for consistency
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);
      final existingValues =
          response.values?.map((e) => e.cast<String>()).toList() ?? [];

      final updatedValues = <List<String>>[];
      bool employeeExists = false;

      // Preserve header
      updatedValues.add([
        'isActive',
        'date',
        'employee',
        'checkIn',
        'checkOut',
      ]);

      // Check if employee already exists (case-insensitive), handle null/empty
      final normalizedEmployeeName = employeeName.trim().toLowerCase();
      for (var row in existingValues.skip(1)) {
        // Skip header
        if (row.isNotEmpty && row.length > 2) {
          final employeeInRow =
              row[2].trim() ?? ''; // Employee name from column C
          if (employeeInRow.isNotEmpty &&
              employeeInRow.toLowerCase() == normalizedEmployeeName &&
              row[1].isEmpty) {
            if (row[0].toLowerCase() != 'true') {
              // Update to active if inactive
              updatedValues.add(['true', '', employeeInRow, '', '']);
            } else {
              updatedValues.add(row); // Keep as is if already active
            }
            employeeExists = true;
          } else {
            updatedValues.add(row);
          }
        } else {
          updatedValues.add(row); // Preserve incomplete rows
        }
      }

      if (!employeeExists && normalizedEmployeeName.isNotEmpty) {
        // Add new employee if not found
        updatedValues.add(['true', '', normalizedEmployeeName, '', '']);
      }

      await api.spreadsheets.values.update(
        sheets.ValueRange(values: updatedValues),
        _spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );
    } catch (e) {
      log('Error adding employee: $e');
      rethrow;
    }
  }

  // core/data_sources/google_sheets_data_source.dart
  Future<void> removeEmployee(String employeeName) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:E';
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);

      if (response.values == null || response.values!.isEmpty) {
        log('No data found in Sheet1 for removal.');
        return;
      }

      final normalizedEmployeeName = employeeName.trim().toLowerCase();
      final uniqueRows =
          <
            String,
            List<String>
          >{}; // Map to deduplicate rows by employee-date key
      bool employeeFound = false; // Track if the employee exists in Sheet1

      // Preserve header
      final updatedValues = [
        ['isActive', 'date', 'employee', 'checkIn', 'checkOut'],
      ];

      // Process each row: remove matching rows, preserve others
      for (var row in response.values!.skip(1)) {
        if (row.length < 3) {
          // Handle incomplete rows
          final castRow =
              row
                  .map((value) => (value as String?)?.toString() ?? '')
                  .cast<String>()
                  .toList();
          final key = 'incomplete_${castRow.join('_')}';
          uniqueRows[key] = castRow;
          log('Preserved incomplete row: $castRow');
          continue;
        }

        final employeeInRow = (row[2] as String?)?.trim() ?? '';
        final dateValue = (row[1] as String?)?.trim() ?? '';
        log('Processing row: employee=$employeeInRow, date=$dateValue');

        if (employeeInRow.toLowerCase() == normalizedEmployeeName) {
          employeeFound = true; // Employee exists in Sheet1
          log('Removed row for employee "$employeeName" (date=$dateValue).');
        } else {
          // Preserve non-matching rows
          final castRow =
              row
                  .map((value) => (value as String?)?.toString() ?? '')
                  .cast<String>()
                  .toList();
          final key =
              dateValue.isEmpty
                  ? '${employeeInRow.toLowerCase()}_'
                  : '${employeeInRow.toLowerCase()}_$dateValue';
          uniqueRows[key] = castRow;
          log('Preserved row: employee=$employeeInRow, date=$dateValue.');
        }
      }

      if (!employeeFound) {
        log('Warning: Employee "$employeeName" not found in Sheet1.');
        throw Exception('Employee "$employeeName" not found in Sheet1.');
      }

      // Add a new inactive employee-only row for the employee
      uniqueRows['${normalizedEmployeeName}_'] = [
        'false',
        '',
        employeeName,
        '',
        '',
      ];
      log('Added new inactive employee-only row for "$employeeName".');

      // Add unique rows to updatedValues
      updatedValues.addAll(uniqueRows.values);

      // Update the sheet with the modified data
      await api.spreadsheets.values.update(
        sheets.ValueRange(values: updatedValues),
        _spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );
      log(
        'Successfully removed employee "$employeeName" rows and marked as inactive in Sheet1.',
      );
    } catch (e) {
      log('Error removing employee "$employeeName": $e');
      rethrow;
    }
  }

  double _calculateOvertime(DateTime checkIn, DateTime checkOut) {
    final hoursWorked = checkOut.difference(checkIn).inMinutes / 60.0;
    return hoursWorked > 9 ? hoursWorked - 9 : 0.0;
  }
}
