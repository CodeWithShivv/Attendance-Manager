import 'dart:developer';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SheetsClient {
  final Map<String, dynamic> _credentials;

  SheetsClient()
    : _credentials = jsonDecode(dotenv.env['GOOGLE_CREDENTIALS'] ?? '{}') {
    if (_credentials.isEmpty) {
      throw Exception('Missing GOOGLE_CREDENTIALS in .env file');
    }
  }

  Future<sheets.SheetsApi> getApi() async {
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
}
