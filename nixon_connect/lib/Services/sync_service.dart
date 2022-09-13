//REST API SYNC SERVICE
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nixon_connect/Common/validator.dart';
import 'package:nixon_connect/Handlers/local_database_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncServer {
  static final SyncServer _instance =
      SyncServer._internal();
  factory SyncServer() => _instance;
  SyncServer._internal();
  static SyncServer get instance => _instance;

  final String? apiURI = dotenv.env['API_URI'];
  final Duration _timeout = const Duration(seconds: 5);
  final LocalDatabase _localDB = LocalDatabase.instance;
  void syncData({required String userToken}) async {
    final SharedPreferences _prefs =
        await SharedPreferences.getInstance();
    final String? lastSync =
        _prefs.getString('last-synced');

    final response = await http
        .post(
          Uri.parse(apiURI! + 'sync'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken',
          },
          body: jsonEncode({
            'lastSync':
                lastSync ?? '2021-01-01T00:00:00.000Z'
          }),
        )
        .timeout(_timeout);
    if (response.statusCode == 200) {
      _prefs.setString(
          'last-synced', DateTime.now().toIso8601String());
      final json = jsonDecode(response.body);
      print(
          "Synced data: ${DateTime.now().toIso8601String()}");
      _localDB.addRooms(json['rooms']);
      _localDB.addMessages(json['messages']);
    } else {
      showToast('Sync failed');
    }
  }
}
