import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:nixon_connect/Models/user_model.dart';
import 'package:nixon_connect/Services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  AuthCubit(this._authService) : super(const AuthInitial());

  //get the user from the local storage
  Future<void> getUser() async {
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();
    final String? user = prefs.getString('user');
    if (user != null) {
      final json = jsonDecode(user);
      final userModel = UserModel.fromJson(json);
      emit(AuthSuccess(user: userModel));
    } else {
      emit(const AuthInitial());
    }
  }

  //sign in
  Future<void> handleSignIn(
      {required String email,
      required String password}) async {
    try {
      emit(const AuthLoading());
      if (validateEmail(email) &&
          validatePassword(password)) {
        final response = await _authService.signIn(
          email: email,
          password: password,
        );
        if (response.statusCode == 200) {
          final user = UserModel.fromJson(
              json.decode(response.body)['user']);
          emit(AuthSuccess(user: user));
        } else {
          emit(const AuthError(error: ''));
          showToast(json.decode(response.body)['error']);
        }
      } else {
        emit(const AuthError(error: ''));
      }
    } catch (error) {
      emit(AuthError(error: error.toString()));
    }
  }

  //handle register
  Future<void> handleRegister(
      {required String email,
      required String password,
      required String name,
      required String userID,
      required String confirmPassword}) async {
    try {
      emit(const AuthLoading());
      if (validateEmail(email) &&
          validatePassword(password) &&
          validateName(name) &&
          validateUserID(userID) &&
          validateConfirmPassword(
              password, confirmPassword)) {
        final response = await _authService.register(
          name: name,
          email: email,
          userID: userID,
          password: password,
        );
        if (response.statusCode == 200) {
          showToast("Registration Successful");
          final user = UserModel.fromJson(
              json.decode(response.body)['user']);
          saveUserData(user: user);
          emit(AuthSuccess(user: user));
        } else {
          emit(const AuthError(error: ''));
          showToast(json.decode(response.body)['error']);
        }
      } else {
        emit(const AuthError(error: ''));
      }
    } catch (error) {
      emit(const AuthError(error: ''));
    }
  }

  handleForgotPassword({required String email}) async {
    if (validateEmail(email)) {
      Response response =
          await _authService.forgotPassword(email);
      if (response.statusCode == 200) {
        showToast(
            "Password reset link has been sent to your email");
      } else {
        showToast(json.decode(response.body)['error']);
      }
    }
  }

//save user data to local storage
  saveUserData({required UserModel user}) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    prefs.setString(
        'current-user', user.toJson().toString());
  }

//Show toast message
  void showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT);
  }

//validate userID
//lowercase,number, underscore, and length of 6-10
  bool validateUserID(String userID) {
    RegExp regex = RegExp(r'^[a-z0-9_]{6,10}$');
    if (regex.hasMatch(userID)) {
      return true;
    } else {
      showToast(
          'UserID should be lowercase, number, underscore and length of 6-10');
      return false;
    }
  }

//validate email
  validateEmail(String email) {
    if (email.isEmpty) {
      showToast("Email field is empty");
      return false;
    }
    bool validEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!validEmail) {
      showToast("Please enter a valid email");
      return false;
    }
    return true;
  }

//validate password
  validatePassword(String password) {
    if (password.isEmpty) {
      showToast("Password field is empty");
      return false;
    }
    bool validPassword =
        RegExp(r'^(?=.*?[a-z|A-Z])(?=.*?[0-9]).{8,}$')
            .hasMatch(password);
    if (!validPassword) {
      showToast(
          "Password should contain letters, numbers and must be 8 characters in length");
      return false;
    }
    return true;
  }

//validate name
  validateName(String name) {
    if (name.isEmpty) {
      showToast("Name field is empty");
      return false;
    }
    return true;
  }

//validate confirm password
  validateConfirmPassword(
      String password, String confirmPassword) {
    if (password != confirmPassword) {
      showToast(
          "Password and confirm password does not match");
      return false;
    }
    return true;
  }
}
