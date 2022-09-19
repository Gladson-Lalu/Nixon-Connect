import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class RoomService {
  final String? apiURI = dotenv.env['API_URI'];
  final timeout = const Duration(seconds: 5);
  //create room http post request
  Future<http.Response> createRoom(
      {required String roomName,
      required String roomType,
      required String roomDescription,
      required String roomPassword,
      required String roomPerimeter,
      required String userToken,
      required LocationData locationData}) async {
    try {
      final response = await http
          .post(
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
              'location': {
                'latitude': locationData.latitude,
                'longitude': locationData.longitude,
              }
            }),
          )
          .timeout(timeout);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  //join room http post request
  Future<http.Response> joinRoom(
      {required String roomId,
      required String roomPassword,
      required String userToken}) async {
    try {
      final response = await http
          .post(
            Uri.parse(apiURI! + 'room/join'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $userToken',
            },
            body: json.encode({
              'roomId': roomId,
              'roomPassword': roomPassword,
              'token': userToken
            }),
          )
          .timeout(timeout);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  //update room avatar http post request
  Future<http.Response> updateRoomAvatar(
      {required String roomId,
      required String roomAvatar,
      required String userToken}) async {
    try {
      final response = await http
          .post(
            Uri.parse(apiURI! + 'room/update-room-avatar'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'token': userToken,
              'roomId': roomId,
              'roomAvatarUrl': roomAvatar,
            }),
          )
          .timeout(timeout);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
