// core/data_sources/google_sheets_data_source.dart
import 'package:attendance_manager_app/features/employee/domain/entities/employee.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSheetsApi {
  late String _spreadsheetId;
  late Map<String, dynamic> _credentials;

  GoogleSheetsApi() {
    _spreadsheetId = dotenv.env['SPREADSHEET_ID'] ?? '';
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
      print('Error initializing Sheets API: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> fetchAttendance(String date) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:D'; // Date, Employee, CheckIn, CheckOut
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);
      final values =
          response.values?.map((e) => e.cast<String>()).toList() ?? [];
      // Filter rows by date
      return values.where((row) => row.isNotEmpty && row[0] == date).toList();
    } catch (e) {
      print('Error fetching attendance: $e');
      return [];
    }
  }

  Future<void> updateAttendance(String date, List<List<dynamic>> data) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:D';

      // Fetch existing data to determine updates
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);
      final existingValues =
          response.values?.map((e) => e.cast<String>()).toList() ?? [];

      final updatedValues = <List<String>>[];
      final existingForDate =
          existingValues
              .where((row) => row.isNotEmpty && row[0] == date)
              .toList();
      final otherDates =
          existingValues
              .where((row) => row.isNotEmpty && row[0] != date)
              .toList();

      // Update or add new records
      for (var newRow in data) {
        final employee = newRow[1] as String;
        final existingRowIndex = existingForDate.indexWhere(
          (row) => row[1] == employee,
        );
        if (existingRowIndex != -1) {
          // Update existing row
          updatedValues.add(newRow.cast<String>());
        } else {
          // Add new row
          updatedValues.add([
            date,
            employee,
            newRow[2] as String,
            newRow[3] as String,
          ]);
        }
      }

      // Preserve rows for other dates
      updatedValues.addAll(otherDates);

      // Clear and rewrite the sheet
      await api.spreadsheets.values.clear(
        sheets.ClearValuesRequest(),
        _spreadsheetId,
        range,
      );

      if (updatedValues.isNotEmpty) {
        final request = sheets.ValueRange(values: updatedValues);
        await api.spreadsheets.values.update(
          request,
          _spreadsheetId,
          range,
          valueInputOption: 'RAW',
        );
      }
    } catch (e) {
      print('Error updating attendance: $e');
      rethrow;
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:B'; // A: Name, B: isActive
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);

      if (response.values == null) return [];

      return response.values!
          .map(
            (row) => Employee(
              name: row[0].toString(),
              isActive: row.length > 1 ? row[1] == 'true' : true,
              id: null,
            ),
          )
          .where((employee) => employee.name.isNotEmpty && employee.isActive)
          .toList();
    } catch (e) {
      print('Error fetching employees: $e');
      return [];
    }
  }

  Future<void> addEmployee(String employeeName) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:B';
      final request = sheets.ValueRange(
        values: [
          [employeeName, 'true'], // Add as active
        ],
      );
      await api.spreadsheets.values.append(
        request,
        _spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );
    } catch (e) {
      print('Error adding employee: $e');
      rethrow;
    }
  }

  Future<void> removeEmployee(String employeeName) async {
    try {
      final api = await _getSheetsApi();
      const range = 'Sheet1!A:B';
      final response = await api.spreadsheets.values.get(_spreadsheetId, range);

      if (response.values == null) return;

      final updatedValues =
          response.values!.map((row) {
            if (row.isNotEmpty && row[0] == employeeName) {
              return [row[0], 'false']; // Mark as inactive
            }
            return row.length > 1
                ? row
                : [row[0], 'true']; // Ensure all rows have isActive
          }).toList();

      await api.spreadsheets.values.update(
        sheets.ValueRange(values: updatedValues),
        _spreadsheetId,
        range,
        valueInputOption: 'RAW',
      );
    } catch (e) {
      print('Error removing employee: $e');
      rethrow;
    }
  }
}
