import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String? apiURI = dotenv.env['API_URI'];

//authentication Uri
Uri loginURI = Uri.parse(apiURI! + 'auth/login');
Uri registerURI = Uri.parse(apiURI! + 'auth/register');
Uri forgotPasswordURI =
    Uri.parse(apiURI! + '/auth/forgot-password');

//SignIn method to get token
Future<http.Response> signIn(
    {required String email,
    required String password}) async {
  final response = await http.post(
    loginURI,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );
  return response;
}

//register method to get token
Future<http.Response> register(
    {required String name,
    required String email,
    required String userID,
    required String password}) async {
  final response = await http.post(
    registerURI,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'name': name,
      'email': email,
      'userID': userID,
      'password': password,
    }),
  );
  return response;
}

//forgotPassword method
Future<http.Response> forgotPassword(String email) async {
  final response = await http.post(
    forgotPasswordURI,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'email': email,
    }),
  );
  return response;
}
