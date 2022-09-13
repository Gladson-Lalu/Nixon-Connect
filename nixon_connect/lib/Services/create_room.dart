import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RoomService {
  final String? apiURI = dotenv.env['API_URI'];

  //create room http post request
  Future<http.Response> createRoom({
    required String roomName,
    required String roomType,
    required String roomDescription,
    required String roomPassword,
    required String roomPerimeter,
    required String userToken,
  }) async {
    final response = await http.post(
      Uri.parse(apiURI! + 'room/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
      body: json.encode({
        'roomName': roomName,
        'roomType': roomType,
        'roomDescription': roomDescription,
        'roomPerimeter': roomPerimeter,
        'roomPassword': roomPassword,
      }),
    );
    return response;
  }
}
