import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String? apiURI = dotenv.env['API_URI'];
  final Duration timeout = const Duration(seconds: 5);
//SignIn method to get token
  Future<http.Response> signIn(
      {required String email,
      required String password}) async {
    final response = await http
        .post(
          Uri.parse(apiURI! + 'auth/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': email,
            'password': password,
          }),
        )
        .timeout(timeout);
    return response;
  }

//register method to get token
  Future<http.Response> register(
      {required String name,
      required String email,
      required String userID,
      required String password}) async {
    final response = await http
        .post(
          Uri.parse(apiURI! + 'auth/register'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': name,
            'email': email,
            'userID': userID,
            'password': password,
          }),
        )
        .timeout(timeout);
    return response;
  }

//forgotPassword method
  Future<http.Response> forgotPassword(String email) async {
    final response = await http
        .post(
          Uri.parse(apiURI! + 'auth/forgot-password'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': email,
          }),
        )
        .timeout(timeout);
    return response;
  }

  //update profile picture
  Future<http.Response> updateProfilePicture(
      {required String userToken,
      required String profilePicture}) async {
    final response = await http
        .post(
          Uri.parse(
              apiURI! + 'auth/update-profile-picture'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'token': userToken,
            'profilePicture': profilePicture,
          }),
        )
        .timeout(timeout);
    return response;
  }
}
