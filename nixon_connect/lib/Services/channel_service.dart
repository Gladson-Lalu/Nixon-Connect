import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChannelsService {
  String? apiURI = dotenv.env['API_URI'];
  final Duration timeout = const Duration(seconds: 5);
//SignIn method to get token
  Future<http.Response> refreshChannels(
      {required String token,
      required String latitude,
      required String longitude}) async {
    final response = await http
        .post(
          Uri.parse(apiURI! + 'inviting-rooms'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'token': token,
            'location': {
              'latitude': latitude,
              'longitude': longitude,
            }
          }),
        )
        .timeout(timeout);
    return response;
  }
}
